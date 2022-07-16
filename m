Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97587577170
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 22:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiGPUrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 16:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGPUrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 16:47:11 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F801928C
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 13:47:07 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220716204703euoutp028f982f5dbcdd57e9b5819ae2b0527d2a~Caj0AIo3O3026930269euoutp02h
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 20:47:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220716204703euoutp028f982f5dbcdd57e9b5819ae2b0527d2a~Caj0AIo3O3026930269euoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658004423;
        bh=dYjVPvaA3MePB0Fe2ldOnYnXCcMdp5GJeMDF8Z97AdA=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=oOqStke6cgQE9Hnpnxu3eBgzqeACQVc0HdoLbsM1tkkeulO7S807srl41796RxAQI
         f0OSdJGZP5uwT3mDt0kQmKtJHrFQeDugO2zWseIGJwW2OpLJJGK8n56wToh3ZT4S+w
         ztF8km4OhESZsRQRT2KKbWUFuUlIp1JST4sVVSMc=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220716204701eucas1p1cb400c9d5539e95b227ed56f2e5189ad~CajywEBFU0411204112eucas1p1X;
        Sat, 16 Jul 2022 20:47:01 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 0B.FF.10067.5C323D26; Sat, 16
        Jul 2022 21:47:01 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220716204701eucas1p1cd9d17857b50339074b22320373ef1b6~CajyWfvm10184601846eucas1p1i;
        Sat, 16 Jul 2022 20:47:01 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220716204701eusmtrp22cf9950e5dc08cce89b2ed7a3f546537~CajyV5D_h0499904999eusmtrp2M;
        Sat, 16 Jul 2022 20:47:01 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-d2-62d323c5dfca
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 6B.4A.09095.5C323D26; Sat, 16
        Jul 2022 21:47:01 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220716204700eusmtip19f16c0bcf2c4ae679436591f39405379~Cajx9d1Ke0268902689eusmtip1I;
        Sat, 16 Jul 2022 20:47:00 +0000 (GMT)
Message-ID: <cffd2484-e40d-7519-167b-f4c16377dab4@samsung.com>
Date:   Sat, 16 Jul 2022 22:47:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] net: fix compat pointer in get_compat_msghdr()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc:     Dylan Yudaken <dylany@fb.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <bc98a0f1-199d-a84d-21bc-274a47fae5a6@kernel.dk>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWy7djPc7pHlS8nGXz/qGax+m4/m8XUPx4W
        71rPsVgcWyDmwOIxsfkdu8fls6UenzfJBTBHcdmkpOZklqUW6dslcGW83n+aseA3X8WSs9/Z
        GxgX83QxcnJICJhI/JizjRnEFhJYwSjR/7Oui5ELyP7CKPF02Td2COczo8SeFSfZYDp+vVnG
        CtGxnFHi6kIuiKKPjBLT1n1lBEnwCthJrLw3GWwsi4CqxP4ZR1kh4oISJ2c+YQGxRQWSJc6d
        vQo2VFjAWWLL9w9gNcwC4hK3nsxnArFFBDIkvq45wAYRV5TY//k1WJxNwFCi620XWJxTwFZi
        2qLZUDXyEtvfzmEGOUhCYC2HRN+L+0AvcAA5LhKz9ihCPCAs8er4FnYIW0bi/06QXSAl+RJ/
        ZxhDhCskrr1ewwxhW0vcOfeLDaSEWUBTYv0ufYiwo8TTi3+gOvkkbrwVhDiAT2LStunMEGFe
        iY42IYhqNYlZx9fB7Tx44RLzBEalWUhBMgvJ67OQvDILYe8CRpZVjOKppcW56anFRnmp5XrF
        ibnFpXnpesn5uZsYgSnk9L/jX3YwLn/1Ue8QIxMH4yFGCQ5mJRHejO2XkoR4UxIrq1KL8uOL
        SnNSiw8xSnOwKInzJmduSBQSSE8sSc1OTS1ILYLJMnFwSjUwLXno9l2r+5vaKomnBybIHpHa
        JjgtJ+hP7tL/pswHyxo/P+vtm/I47+HOmsCrx28I9h/Wmr+r7YVWzlUNng//tG+6cv1c1bb8
        dVrmgrzZj5a9f/rdqS2o9dCxueVdHdpq6h+cz5WsaDYytjwwg+u4bG6oiEPH/+I5bEWffQ9t
        yhCvKDLa7LhB1sfSfN/tgqMtHGls51e/stZo35tpdXoPzz/PsF0H/B9afop+yXwlRrXuapfN
        uqjG3TJlyyZkrvpX8aOtoFX5UslEDX++R0wPNkyL3CDpM/0VO7fmlUt+M1YezVoTHXd5SZDg
        9pB3L1mYK+cr6O9duzBK2TKuyk7V9WAEn/SRJ57nF+q+unjPVYmlOCPRUIu5qDgRACsyiCOQ
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xu7pHlS8nGTRO57JYfbefzWLqHw+L
        d63nWCyOLRBzYPGY2PyO3ePy2VKPz5vkApij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1
        DI3NY62MTJX07WxSUnMyy1KL9O0S9DJe7z/NWPCbr2LJ2e/sDYyLeboYOTkkBEwkfr1ZxtrF
        yMUhJLCUUWL2gVZmiISMxMlpDawQtrDEn2tdbBBF7xkldiz8AZbgFbCTWHlvMlgDi4CqxP4Z
        R6HighInZz5hAbFFBZIlmrccYgKxhQWcJbZ8/wBWwywgLnHryXywuIhAhsSjQ6ug4ooS+z+/
        BosLCdhItJw9AjafTcBQoustyBGcHJwCthLTFs1mg6g3k+ja2sUIYctLbH87h3kCo9AsJGfM
        QrJuFpKWWUhaFjCyrGIUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAiMnm3Hfm7ewTjv1Ue9Q4xM
        HIyHGCU4mJVEeDO2X0oS4k1JrKxKLcqPLyrNSS0+xGgKDIuJzFKiyfnA+M0riTc0MzA1NDGz
        NDC1NDNWEuf1LOhIFBJITyxJzU5NLUgtgulj4uCUamDSlBE9e515+xrbWfOW7r3f0/bIn9dV
        53X0iVteguWf1l58Fcj+VPoS7xZfhhm+Xw1kFmi+tS2+rmv8Odi9cf2JjTwaxftPH49Iva8T
        0bVBop1H6LJ46JK0VefWK2+JO76Tmy/pcMlDrjuBlz+qpZ16q/tDx7I8TmDLN6fyV9lq3Lq7
        F4QkTM8XzJBrznWcL1kwtetS0pu/Z3deZ7fa/jh28ke+Dy8CRO17V16R2V8VMeVfgHHHvS9/
        rshXLn37aU5y+fVT2db63xsOt9yVb3x7UtubV/9jhVl22j3n5acTrtYpGl7xZJBltw2d80nU
        rOTIJc8laglMs8XO8f34Icaf9v1KuwvHNTMp3hc1AtZKLMUZiYZazEXFiQALnlPfJwMAAA==
X-CMS-MailID: 20220716204701eucas1p1cd9d17857b50339074b22320373ef1b6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220716204701eucas1p1cd9d17857b50339074b22320373ef1b6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220716204701eucas1p1cd9d17857b50339074b22320373ef1b6
References: <bc98a0f1-199d-a84d-21bc-274a47fae5a6@kernel.dk>
        <CGME20220716204701eucas1p1cd9d17857b50339074b22320373ef1b6@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.07.2022 00:03, Jens Axboe wrote:
> A previous change enabled external users to copy the data before
> calling __get_compat_msghdr(), but didn't modify get_compat_msghdr() or
> __io_compat_recvmsg_copy_hdr() to take that into account. They are both
> stil passing in the __user pointer rather than the copied version.
>
> Ensure we pass in the kernel struct, not the pointer to the user data.
>
> Link: https://lore.kernel.org/all/46439555-644d-08a1-7d66-16f8f9a320f0@samsung.com/
> Fixes: 1a3e4e94a1b9 ("net: copy from user before calling __get_compat_msghdr")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

This fixes the issue I've reported.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>
> As this was staged in the io_uring tree, I plan on applying this fix
> there as well. Holler if anyone disagrees.
>
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 6b7d5f33e642..e61efa31c729 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -398,7 +398,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
>   	if (copy_from_user(&msg, sr->umsg_compat, sizeof(msg)))
>   		return -EFAULT;
>   
> -	ret = __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr);
> +	ret = __get_compat_msghdr(&iomsg->msg, &msg, &iomsg->uaddr);
>   	if (ret)
>   		return ret;
>   
> diff --git a/net/compat.c b/net/compat.c
> index 513aa9a3fc64..ed880729d159 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -89,7 +89,7 @@ int get_compat_msghdr(struct msghdr *kmsg,
>   	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
>   		return -EFAULT;
>   
> -	err = __get_compat_msghdr(kmsg, umsg, save_addr);
> +	err = __get_compat_msghdr(kmsg, &msg, save_addr);
>   	if (err)
>   		return err;
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

