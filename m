Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22FA25DEEB
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgIDQDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgIDQDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:03:17 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E501C061244;
        Fri,  4 Sep 2020 09:03:16 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so3410861pjb.4;
        Fri, 04 Sep 2020 09:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KHkXwx+jqaoaCS6UX8HzJ0+ftR5FngFSLzBY4NLpaHQ=;
        b=C1YTXxEfZmQ5IEeNYNmT8Umezg2XJu/IuxxhEW1fRiDqWU0qluZSyBTg0sW6JRq7EU
         mV4yZMMZ0/Xm7wQg0HJyE45MTNODIZ1Q0J27b1H+OzLjogdFPygr9ToDRr8j1RLgc3Ol
         rng/oMlR/BFdQAStpKtb2WKYlFDuuUPvd7pMrlYE34/ctCEONpH3NFw3PAULvPvZ2DKD
         bt/57I8IW7vH4kwNQOKtsa5ab2eppkXP+bctBv89kjXhvLSypehyorj72RZNARZZg4FU
         pDjRwoZ8yxJVdhVGawyPJmB3fYQK7/iIXSKMlpkP8iMooCBJ+Atti9jZLDeyoifr8e3m
         mP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KHkXwx+jqaoaCS6UX8HzJ0+ftR5FngFSLzBY4NLpaHQ=;
        b=J1QRVXRvKaH1JNjjUgg0kaKEVkZyxPSkU22VPQNGNH/zuSG6s6k3w3CK0EV4MtN7La
         7oH/qvnUpRAo6LuzESAeQ0uZvnyjVLxIBFHRQxYa1jHbvSR1ocyQlQzLg9CH2HzEZhlt
         Uo6E7rSo5yuuNXwCiKfFEQd5Hqz0IZM+6aOXv03hfIV2V/S+6kAPCh9sjJ/WUFDJoMe7
         +W523sNAyvuoiwcgcF7XeeLljvZaLZKgvH/orJpe5dzgGMmUPLc7D0EzS1HNL5pUjl2O
         ewUMYh4UCaqGXdOAUJxrTZTnddrnwuVCP/16A86uNqU6Ca0ACNVn0oiczWH3XTiSTGZ5
         VT+A==
X-Gm-Message-State: AOAM5316B3nAAtkOq1usH9plPZ9kEXnrOmt//GwItSq0rWAQsbxCg/G6
        z04pFO0JOQ5tUMfa/bI2pDU=
X-Google-Smtp-Source: ABdhPJw68D3zn12AwaSMv3IePjrL7SraUw8pPVUg5HAYxMdMInAXg/JKDg3oxRTe/VxqPoJtiRdqJg==
X-Received: by 2002:a17:90a:ab11:: with SMTP id m17mr8509478pjq.236.1599235395895;
        Fri, 04 Sep 2020 09:03:15 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id u3sm5510880pjn.29.2020.09.04.09.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 09:03:15 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 5 Sep 2020 00:03:08 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20200904160308.vpflvqfob7h7hz4v@Rk>
References: <20200902140031.203374-1-coiby.xu@gmail.com>
 <20200903034918.GA227281@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200903034918.GA227281@f3>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 12:49:18PM +0900, Benjamin Poirier wrote:
>On 2020-09-02 22:00 +0800, Coiby Xu wrote:
>> This fixes commit 0107635e15ac
>> ("staging: qlge: replace pr_err with netdev_err") which introduced an
>> build breakage of missing `struct ql_adapter *qdev` for some functions
>> and a warning of type mismatch with dumping enabled, i.e.,
>>
>> $ make CFLAGS_MODULE="QL_ALL_DUMP=1 QL_OB_DUMP=1 QL_CB_DUMP=1 \
>>   QL_IB_DUMP=1 QL_REG_DUMP=1 QL_DEV_DUMP=1" M=drivers/staging/qlge
>>
>> qlge_dbg.c: In function ‘ql_dump_ob_mac_rsp’:
>> qlge_dbg.c:2051:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
>>  2051 |  netdev_err(qdev->ndev, "%s\n", __func__);
>>       |             ^~~~
>> qlge_dbg.c: In function ‘ql_dump_routing_entries’:
>> qlge_dbg.c:1435:10: warning: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Wformat=]
>>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>>       |         ~^
>>       |          |
>>       |          char *
>>       |         %d
>>  1436 |        i, value);
>>       |        ~
>>       |        |
>>       |        int
>> qlge_dbg.c:1435:37: warning: format ‘%x’ expects a matching ‘unsigned int’ argument [-Wformat=]
>>  1435 |        "%s: Routing Mask %d = 0x%.08x\n",
>>       |                                 ~~~~^
>>       |                                     |
>>       |                                     unsigned int
>>
>> Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
>> Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>
>Thanks for following up on this issue.
>
>[...]
>> @@ -1632,8 +1635,8 @@ void ql_dump_wqicb(struct wqicb *wqicb)
>>
>>  void ql_dump_tx_ring(struct tx_ring *tx_ring)
>>  {
>> -	if (!tx_ring)
>> -		return;
>> +	struct ql_adapter *qdev = tx_ring->qdev;
>> +
>>  	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
>>  		   tx_ring->wq_id);
>>  	netdev_err(qdev->ndev, "tx_ring->base = %p\n", tx_ring->wq_base);
>
>Did you actually check to confirm that the test can be removed?

Thank you for the reminding! For the current code, when ql_dump_tx_ring
is called, tx_ring would never be null.

>
>This is something that you should mention in the changelog at the very
>least since that change is not directly about fixing the build breakage
>and if it's wrong, it can lead to null pointer deref.

I thought it is common practice in C that the caller makes sure
the passed parameter isn't a null pointer because a QEMU developer
also gave me the same advice after reviewing one of my patches for
QEMU a few weeks ago. I'll mention this in the commit message. Thank
you for the suggestion!


--
Best regards,
Coiby
