Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF4C3231B3
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 20:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhBWT6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 14:58:04 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:43303 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbhBWT57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 14:57:59 -0500
Received: from [192.168.1.155] ([77.9.11.4]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MLA6k-1lWist0W38-00IAI0; Tue, 23 Feb 2021 20:54:49 +0100
Subject: Re: [PATCH] lib: vsprintf: check for NULL device_node name in
 device_node_string()
To:     Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, linux@rasmusvillemoes.dk,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20210217121543.13010-1-info@metux.net>
 <YC0fCAp6wxJfizD7@smile.fi.intel.com> <YC5jUqxphRvyuMEv@alley>
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
Message-ID: <29af7ed3-2ca8-133b-387a-375261ed1289@metux.net>
Date:   Tue, 23 Feb 2021 20:54:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC5jUqxphRvyuMEv@alley>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+GSdxcAZTu08i7MoQmwW4rr5qQ+FKVRtg/0h9Q+lDDFM+C9FSb5
 m2tlin1ii17wqFrpigGJMCHv2ubNnvu0VkwQosZMjLfp6xYT80yDv5u5Vk19qIQQovi443D
 Lwz33lJ5lgcbBF5XjFTTOvV3O5UavgiS++dGAC4GOmW2rFk7XeKGaCrGmZ7DL/2yEjue0/Z
 zF16vw2H6KiCq2iJRMNrA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5AbnWZgWfis=:wYCSgmvw6t1ok9kheC18cy
 uJRRs8U/pvunagUi4FFTQMpDw0liS9kWKym53eTt7wp65hW0Qd4jh6i7dPT49sjDqgZur+uZr
 DomX8koa2Td5ktfqHIYMCh954tIgLlf0CAs9xUfvWlR+4HSuHbZ5EXqho3YYvv4SmGmYJUGH6
 obK5ULqZHTYXD5KsHPT/xLtWxwUSbsb4ryrd11f99F7fhOIXLLcTPcQAr7sb6OOce/ym1aOgG
 owcOy5uzW3XOu+QLhzEOi1rpMv6TrZbzYheR/tKQeEg4ZkbYmDW9aJxcQgSFc78M/5pwYUdlZ
 XzyLhAT1V/dZ4wIpSSV/N4ZjmH442gZIHRAgKE1XEyiAg/oIP9wvLYngLoxeSYOdYexQWmfFu
 uxZQ8gGoQMCtytRWVh/gd7ExZic1M/3sFf6uPmWdLmwQ+StF6eTMY/pDDShsE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.21 13:53, Petr Mladek wrote:

> Please, use
> 
> 	if (check_pointer(&buf, end, p, spec))
> 		return buf;
> 
> It will print "(null)" instead of the name. It should be enough
> to inform the user this way. The extra pr_warn() does not help
> much to localize the problem anyway. And it is better to avoid
> recursion in this path.

thx, going to use it in v2.


--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
