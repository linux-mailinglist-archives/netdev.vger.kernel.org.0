Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85867B3818
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfIPKdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:33:10 -0400
Received: from mout.web.de ([212.227.15.4]:41303 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfIPKdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 06:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1568629975;
        bh=MmG0AFh9t9sKeZ3P1EE1tiYnOTRXVWpq3OKi4adZ0Uk=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=sGlkxWvliLUF3ExjJFGr561AFjo7QSGcfQDqA3lx45RMkYM0b2BhvAfNGQkTGq2aQ
         tKwO14im7rLhfpZbz22qwuh4mKHJ4IGmdjXPfwsjLL0w76MVzgsrZzQzo8aQEyk1JZ
         UObROWvaj4Gk7SEDOthn6prPKutxtrI4XHukPOMU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.32.36]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MEEdU-1huP310fpw-00FU89; Mon, 16
 Sep 2019 12:32:55 +0200
Subject: Re: ss: Checking selected network ports
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Josh Hunt <johunt@akamai.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <1556674718-5081-1-git-send-email-johunt@akamai.com>
 <3d1c67c8-7dfe-905b-4548-dae23592edc5@web.de>
 <20190601.164838.1496580524715275443.davem@davemloft.net>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <9153b2b5-7988-92b4-e357-b5acfe19318e@web.de>
Date:   Mon, 16 Sep 2019 12:32:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190601.164838.1496580524715275443.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:wo+/1s09x7gDgWKENRFkSVAAPFzGSg0cw+VKmlbNbUjF0ezOQFZ
 343G8mm410NSRVw9gV49mIezLEQklvK3t4KUYE3EaQdwC5gQBizxhUqWR2+4/2SMpedhFnf
 rw8s4rkA4GU+MdFIQPGzqb+X4OUqxN2QGSdSPKo17cWERSqNEIiMaa8TM1LGoRo1jPLqrEF
 HrhT35vhUpY7eelwhO5lw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pixmFXdhl9k=:I6PxJ3yc3xWDtcNm0BFppW
 GdXmi51fiNqsmyvn61SyHYtwTUnV1nPMa3Tpdpy8hcYCcws04tFRfVZmm8vSUnhZ1qx4Edc5w
 KFPRPaDtDNeKVqNJragVjl44uSEy85iODuFP1kVCA7LanbWFwH3YWMGD4fBiAvYo90TlTR+fm
 PKAUHhR7K0Q4TEi149VvE0lrQvkqsFqXqUI3SsCq7vTPnfZSFcHF9YmDrKFlL0qXZdZTWUxO3
 YcV/sYKxqWv1djyjPpS2r3LY4xqIoaqkV6MBXpOfC+Oxp78tVJZ59yiAlIYQcLD2rSJiXJAb7
 uDm18OiDkEF4etYDYzM0ZTqEckIP/qsepOS788Y8Rfksqt7ZDkk3wTHlKK1swBvh+bN9Axd4f
 Al0H2mTaL1n/yJ3zE2IRyBAqRFSX3YoJhxU7Jyxnzoo4NjmYBfIUlH2vGwg830uj1twtf5gET
 Z1LyTkI77K5LgzC0Yys4UURTQPIlhG7YbRPER4HzYV8ABgiNpGknd362g4ekvgtr5weJ8Eh4V
 FKEhbnoHzlAxpIuj3efDKldseho2No1nz/ZZ4eATn2NgLvBQGnfxR8QCBDJcrDs+swXwgwlv7
 7GDpoFcNFoodh7wC4mF1mG+EQ9vhHRfWsWHL9wlRx39L5FX8w5zcol6wuLGOJbjwrMnSxhUCb
 OU2UU3VwYwWqyT6X5VMTFaZYX4Jliv+lbKcCjeHmPNc15WbeUjY0WC0uvsS7jvSsQoOl3u11V
 3dbxRaRvIxJaZFHiC7t2wl9aBeyYZ10PRcZgD/0iv+5QSxQScdkDrCozxC3Lji3SQAKvhvhYE
 UVKF2fB5SiWQ8X3H/cchnCioxx8aRH11xU3UZh1BwqnJEfIdq5MmSzhdKEZDz8toAKo8HtFN8
 iN0532VXS4Nt6aZgzO9T0Yu367VaXU/bhahACBdqwIU7+8kXHawjlcPMNFZrslu7dz/qDPHY5
 iw34B1K+7DD3NOO0s0sQkZ6FiuAFcX8hqe/c7blb3Kuf3YAyIqobxwAw+B35sHvACH7XqUbo1
 1+kfDWrxp5MHXPkCrwSrU4cDcF1CjxnB8PJ1xu8KwGnODtRxl0bbndwQBR1gKy+s1D+KPNkAX
 vnBu7gWPDpPhyelrnzMGqu/yYx20VRFJuyxaKSsurf5kKYeHbAN5nsCu1o2BdrWrF7EM7krem
 ncZLiI60frvuA1cpH9hUajqCMcEJ96CBokjiJWcs0HmjMgQJbWkub8PHjOjfjcxwNwaWg370O
 guuQDS7tTrIJ9yJnDCEjvcNO/8oYzq/yhrPHYon26x8R+f85OtSlDcg24588=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you use netlink operations directly, you can have the kernel filter
> on various criteria and only get the socket entries you are interested in.

I suggest to take another look at software design options.


> This whole discussion has zero to do with what text format 'ss' outputs.

Is there a need to improve the software documentation any further?

Which programming interface should be used to check the receive queue
for a single port (without retrieving more network data before)?

Regards,
Markus
