Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5506C37EED
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfFFUmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:42:38 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:39445 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFFUmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:42:38 -0400
Received: from [192.168.1.110] ([77.9.2.22]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MsI0I-1ggb6G29BC-00tjwj; Thu, 06 Jun 2019 22:41:38 +0200
Subject: Re: [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)
To:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org
References: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
 <20190605142428.84784-3-wangkefeng.wang@huawei.com>
 <20190605091319.000054e9@intel.com>
 <721a48ce-c09a-a35e-86ae-eac5eec26668@huawei.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <37cbb3d8-bec8-4dd7-ba1f-31a2919316ca@metux.net>
Date:   Thu, 6 Jun 2019 22:41:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <721a48ce-c09a-a35e-86ae-eac5eec26668@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:pagADH4vxjoMgAeXBVQOtnRLYCAOD23dxJjVP31ezD5G4gsXRJl
 IPf4GGUspGV0Wew2LBbkhWOLzwqu3s9hBmkUoCldow0jMrDx/paEta5YHx1nf47mJHGCLJ8
 xFo1DjfxZlDMqHsaif8SurlPSDbwKN9yuSabInMOGFhmSDh8v2hrEpCKJi0/K3/C8ojGqW8
 cOxFkanD02JRD2hw5YmPw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yJg8HQSN4KI=:dWStSaB4teSzQlqTv/xoCO
 W35oNQGJLqSNaxNTV/GPRu8jAcUlli059kE5mTvvL9KLc5ZVLn43qrTGAAuxIZ11RRzcdCgHg
 P7c9aI+uAJ9cEFpZuzLzCJpcRIRYMWYTk5GIBYJr9L8R6yEQl4PLNrmqIroFTd/5M3HY3vqVs
 WfU7IlKOWpsqt1WFLW4x1RlH/yQ9ajmZ4qQ4wU5gbq7ujuK4/iMti414RZ2kk4q0k9TodkTyF
 RmSqSPhTMdzsQ6TOUC0oNPpwykMwMMm2qna8Kd7D8E4TqOOIJt/6yssuzaFGFZDT7A4tlZh9Q
 It+0ocQNTavPGosDFXmpyFGG8XQKDzr+BxLMYfK0D0OKXgkwJkrBmG5IbzOV4aSeWLZi/OuBC
 TsdAOCEL2yG9uWUVYTU8yt77QlsQJAXGBqf1nxiGtTOtA49YRimBIDbTTzLHoUtsZPF7/9v5u
 LRG9XyaRBk+U/CEVNh7oN37BOwqTwg0zdGKxN/r3ppLCkTaaZU0o0KK+p05+uyWP+UQ1uTU8R
 TKkhrY9UAGm546yIUohMOGpxm0V/PgIt0TVZ989OweSaJKbrpI2sBz+jM61xiv0XrYPxgZgQT
 R26NnndXHTKjw95zS9VepiFXfUOt6/U3kMd+be3lw5oEut2Wgh/aI9RZW+e0eEW9c0VibTnhK
 aStrqc6SH0/WbNJEI6qxWUhTUsQhkmuodoYQOpoyPMrMSd/UnqyZMTdmFiBIMYytOqulO3pD4
 Z9vDAb0PRY2vao2VwtU2zNvy5o/TvzHYbtiBPvqkN5Ij6b6RSfV3EHtE/D4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.06.19 03:39, Kefeng Wang wrote:

Hi folks,

> There is no different in assembly output (only check the x86/arm64), and
> the Enrico Weigelt have finished a cocci script to do this cleanup.

I haven't compared the assembly output, just logically deduced from the
macro. If I understand it correctly, the likely()/unlikely() macros
just add a hint to the compiler, which branch it should optimize harder.

No idea what the compiler's actually doing, but I believe its things
like optimized shortcut evaluation and avoiding jumps to likely
branches.

>> I'm not sure in the end that the change is worth it, so would like you
>> to prove it is, unless davem overrides me. :-)

Depends on what you count as worthy ;-)

This patch just makes a source a bit more compact / easier to read.
But shouldn't have any actual consequence on the generated binary.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
