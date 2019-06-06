Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F117937FB9
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbfFFVjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:39:07 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:34983 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbfFFVjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:39:06 -0400
Received: from [192.168.1.110] ([77.9.2.22]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M2fDr-1hYB1H1K3D-004FCS; Thu, 06 Jun 2019 23:39:00 +0200
Subject: Re: [PATCH] net: ipv4: fib_semantics: fix uninitialized variable
To:     David Ahern <dsahern@gmail.com>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
References: <1559832197-22758-1-git-send-email-info@metux.net>
 <0ba84175-49be-9023-271d-516c93e2d83e@gmail.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <16775959-1eb7-b8de-e4ad-b40da395d871@metux.net>
Date:   Thu, 6 Jun 2019 23:38:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <0ba84175-49be-9023-271d-516c93e2d83e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:22rxMNXXkOaSkI/weParmlfWRyLUi3KHyVCODClKyaos2cXwTnZ
 X92zZAWj8uuUfG9Y695vjEwecQCJ56gVdlHoGN/aUfCGEC4nUbYNY97ARR13y/t42nZLhNT
 6+PJsY+q0czFDM8H7OU9vMXA1OYN0vktQ7GnulcQGPqgbhYMleizdgJaS7IPLdyh/+WMR6V
 eICkfbe/omCo078eUHyVg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:M8JA6Vx3JuA=:CqyXtTBtdORF3nMpdJ/JA7
 72FrZS+LmdfP6yiIVtp19YrJ6po8Fht/3DuD3ePPYQ57pqnJmXqf6X0xxxQcf39Tsqd6CD8zU
 c/raZGFW/vKJQx/USeiJTYTkkbbBTDV8R5+eTS9Z1nM7H23f54x8gtfhOIOl2KgQnvi25B2lD
 0Nhvxjll7j33ErQVegBLcDA54zLfWj5/pk/MxiebOVpRlr9zKDjwMgYDliA6VpB7LSytDebQ0
 cb5qMRNe6JUYycxOaRjayHADbvj54MP327oSG+1c/J56uT/D4aDHMZMG1QhUp9KRflfBFB1bH
 fR9Ali6jRWW0GgJ3YvWwv7MUs7d3Z4R/8EnC/FFo1g0wqIIjBDLD1e+clgjAoyVJNFTIoP4vN
 Sa+DlTw8+i9BDK31HnIUDFtn1DjmP9ZZuBQuTbjivBJMq9uoEX6WbRjCp430DJl6AowDXDHag
 J+14nr03x4bSQsYnhiOj84mBRgGnPfmku0iwsHq53bygBuocdkphYxml0BQyXnHQfb01fl2LF
 4N8uM1STS5tmt0UHXdkupSBiKvRAdpaz1R4R5QA6GRzuYRDJR2JLqLj0Jwv+MpvfVSvKgHhs6
 iCi0mO1ljD2UMoLaMQUkV8HfDSIOaVJErQ9RzHOUGbGKnsCWIGzjt/1P/uLRFa0ftr3fQvtOk
 bWeFUD2VsqKWhqBzddtRGoHDK6Z8qzEGiWCuv0aIf0IQl4YY6IJBaKLebjIhJP6t/wJ45d0s1
 vVQW5CZRz1I1kqZbqHVQ+GaI+z3OssZxnga3Sphk1ywmOjfSKnSYekL5Rzw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.06.19 17:47, David Ahern wrote:
> 
> what compiler version?
> 
> if tbl is set, then err is set.
> 

gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
