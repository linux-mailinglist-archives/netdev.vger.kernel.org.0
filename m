Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D80282B63
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 17:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgJDPWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 11:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDPWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 11:22:37 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17490C0613CE;
        Sun,  4 Oct 2020 08:22:35 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d6so4827938pfn.9;
        Sun, 04 Oct 2020 08:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pvroqbRx5SZxuMfn0fG0rh4X/fjh+1NFwkBq33dVcTw=;
        b=teHOIbjDcZXuU0nUYWE4sWIOTDMmcgFzJolY1eVD1IqXtyQGdwIYNkjY5LSvLBVIfQ
         9xxL8xeL637nIbZ2soBH425Zyrm4sU9FuhZMB4wdNDMQaoDob+lX8MkI2kSoz9p1hScT
         KIwaDC4pX77y3n1Z2TRwd+4tktfnuc/DzrrdWiOhsEtFgyEBxZYDclGkWs4cRWplRCZP
         9Vyu1dM+Mh3zXcKjk/zSS2tesdI4heh9I0LEwjW7h2Yhp08ei+jQRkRTcv4xAwjrVqft
         CqXwd6MM8zutCWlCX3HPTxOTFA+63brlP0Q8LeDKYgQy3N89QbWpN8eu8bqJL+Gq+iaN
         JxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pvroqbRx5SZxuMfn0fG0rh4X/fjh+1NFwkBq33dVcTw=;
        b=Sx9NsFSyjz7pxxUZQe/YK3eAcYlFguMeF90/JtURb6rlMlvOn2dLyWA6DAZ4Af+eSW
         fd3v4Nq+XMs/ok//DVx7OUrdii+l3c5vhwCrIqzZlwH3Q2Oav4ouWDdMsgjOTM4T5z9M
         GPrG0Q1xPJJWeiRgQIsjwEdKioxhu1sKithfGfH/tMhBD/TdLpMEILdiy56JxRDpFCYw
         rhnfKAHMjhOyC4ZU/Ngd3xtvosnXXlLPuxysL2/3MjcRa2oFuAp50Vvrhb7qlP+AtL6S
         8Osh1MQoCgvsjUgErl/bD7PcSd1C3UJ4wZHErkV4sRCjankWQzVYoOXNdmCd9WTaNLeK
         IkbQ==
X-Gm-Message-State: AOAM533Cg+kqJGudytaO//q4pzYa+n/A0sfaRZ4igCYgpWPLM0tlgB8S
        IrupTUZivuUPDoOqt9GIJ3E=
X-Google-Smtp-Source: ABdhPJxlmLJZr5oGfYIiPaxKycigStTVDD38XMWUV8QGirPUEWNx0KNkJOZKmxNloM2OnZcTwZ2hgQ==
X-Received: by 2002:a63:a546:: with SMTP id r6mr10326072pgu.160.1601824955325;
        Sun, 04 Oct 2020 08:22:35 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id c12sm9156251pfj.164.2020.10.04.08.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 08:22:34 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sun, 4 Oct 2020 23:22:30 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20201004152230.s2kxna2jl2uzlink@Rk>
References: <20201002235941.77062-1-coiby.xu@gmail.com>
 <20201003055348.GA100061@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201003055348.GA100061@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 02:53:48PM +0900, Benjamin Poirier wrote:
>On 2020-10-03 07:59 +0800, Coiby Xu wrote:
>> This fixes commit 0107635e15ac
>> ("staging: qlge: replace pr_err with netdev_err") which introduced an
>> build breakage of missing `struct ql_adapter *qdev` for some functions
>> and a warning of type mismatch with dumping enabled, i.e.,
>>
>> $ make CFLAGS_MODULE="-DQL_ALL_DUMP -DQL_OB_DUMP -DQL_CB_DUMP \
>>     -DQL_IB_DUMP -DQL_REG_DUMP -DQL_DEV_DUMP" M=drivers/staging/qlge
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
>> Note that now ql_dump_rx_ring/ql_dump_tx_ring won't check if the passed
>> parameter is a null pointer.
>>
>> Fixes: 0107635e15ac ("staging: qlge: replace pr_err with netdev_err")
>> Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>
>Reviewed-by: Benjamin Poirier <benjamin.poirier@gmail.com>

Thank you! Btw, I guess when this patch is picked, the "Reviewed-by" tag
will also be included. So I needn't to send another patch, am I right?

--
Best regards,
Coiby
