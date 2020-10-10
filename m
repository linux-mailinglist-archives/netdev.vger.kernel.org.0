Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160CE28A025
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 13:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgJJLMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 07:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbgJJKZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 06:25:58 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C277DC0613CF;
        Sat, 10 Oct 2020 03:24:24 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b26so9103542pff.3;
        Sat, 10 Oct 2020 03:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kAgtV/zlQ7qrkVa4Spm7AsOCtZ54oLdUWPo/1FrLzu0=;
        b=Fd/AOEa+CbBqIC2iF30QdGq2192retCk+TPZgJaHBT+CQ9SHE2CaD6qffOm4of7NXa
         Jn6gkZ9sbB3uIwq+HN1lSc/FAvfLOzyueqUZHqH1W1dxUaWOgvrQhlJYpR9asIc8xNEs
         NNJlhWJFXdyOwWP3U/1znuX833V8Id7ks0VQFHOUhn71OesHFOZMN8xScQpbf4Q232cL
         0IbU4m/k9zxnCEUXgthG2NtIuXGpbxmfgn8MdhvKlg1alnAfSaNULkiW3Lzuq9pl05LP
         +Vt4rd3xTqbW6Ht5w2s8Cx3beWjvs0BjgyYg7p0OuNNgv+5/pzFDGzZF17GmvqDjkmbx
         JhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kAgtV/zlQ7qrkVa4Spm7AsOCtZ54oLdUWPo/1FrLzu0=;
        b=duJcDUAiy+5VFIk2LWqW4t5bDQc9P4au3ZJeYcTI/Xd/FO2GBfHNf1Fnv1KX/dUepr
         MGlasqlw1txR5wbxTgAicntGmTklmC1urkeLZkM4t2PVjT1MDdG38zDhbUJTPM+fN3Bj
         hdU6qj8jJmNkFSLMF8TRJRDo7Tk9jvt11mgyfNA8O5qjzLbfuCaUPzMudL6/Qh49disJ
         TlVgLXzspPWKME88wlPQ5bFOM9qP7p9jKwySmo7fX6im9C0kJysZqme9oPyiv6riSsPy
         VaZKETbEg72zkMxbpfrketgGiQIghUYRKuAXej0srnJ0jh3zMWgrh8Ea7abWvzHZLpBh
         gErw==
X-Gm-Message-State: AOAM532wOMPPqPu88Jrsep3igXjuNlIBsnAzK0Nsmjiy8hMBDnfWlHCc
        brUrlcflbhKSbUhmbsijExM=
X-Google-Smtp-Source: ABdhPJwG1tv6wFNy3N3iskgS++slfqVQGNmRoe+3mCbntEk6+fX6eR6Nbu4g4GE2X+symJI6Uh/xNw==
X-Received: by 2002:a63:5b5c:: with SMTP id l28mr6393033pgm.243.1602325464218;
        Sat, 10 Oct 2020 03:24:24 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id jx17sm14821822pjb.10.2020.10.10.03.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 03:24:23 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 10 Oct 2020 18:24:16 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201010102416.hvbgx3mgyadmu6ui@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <20201010073514.GA14495@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201010073514.GA14495@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 04:35:14PM +0900, Benjamin Poirier wrote:
>On 2020-10-08 19:58 +0800, Coiby Xu wrote:
>> Initialize devlink health dump framework for the dlge driver so the
>> coredump could be done via devlink.
>>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/Kconfig        |  1 +
>>  drivers/staging/qlge/Makefile       |  2 +-
>>  drivers/staging/qlge/qlge.h         |  9 +++++++
>>  drivers/staging/qlge/qlge_devlink.c | 38 +++++++++++++++++++++++++++++
>>  drivers/staging/qlge/qlge_devlink.h |  8 ++++++
>>  drivers/staging/qlge/qlge_main.c    | 28 +++++++++++++++++++++
>>  6 files changed, 85 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/staging/qlge/qlge_devlink.c
>>  create mode 100644 drivers/staging/qlge/qlge_devlink.h
>>
>> diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
>> index a3cb25a3ab80..6d831ed67965 100644
>> --- a/drivers/staging/qlge/Kconfig
>> +++ b/drivers/staging/qlge/Kconfig
>> @@ -3,6 +3,7 @@
>>  config QLGE
>>  	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
>>  	depends on ETHERNET && PCI
>> +	select NET_DEVLINK
>>  	help
>>  	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
>>
>> diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
>> index 1dc2568e820c..07c1898a512e 100644
>> --- a/drivers/staging/qlge/Makefile
>> +++ b/drivers/staging/qlge/Makefile
>> @@ -5,4 +5,4 @@
>>
>>  obj-$(CONFIG_QLGE) += qlge.o
>>
>> -qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
>> +qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_devlink.o
>> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
>> index b295990e361b..290e754450c5 100644
>> --- a/drivers/staging/qlge/qlge.h
>> +++ b/drivers/staging/qlge/qlge.h
>> @@ -2060,6 +2060,14 @@ struct nic_operations {
>>  	int (*port_initialize)(struct ql_adapter *qdev);
>>  };
>>
>> +
>> +
>> +struct qlge_devlink {
>> +        struct ql_adapter *qdev;
>> +        struct net_device *ndev;
>
>This member should be removed, it is unused throughout the rest of the
>series. Indeed, it's simple to use qdev->ndev and that's what
>qlge_reporter_coredump() does.

It reminds me that I forgot to reply to one of your comments in RFC and
sorry for that,
>> +
>> +
>> +struct qlge_devlink {
>> +        struct ql_adapter *qdev;
>> +        struct net_device *ndev;
>
>I don't have experience implementing devlink callbacks but looking at
>some other devlink users (mlx4, ionic, ice), all of them use devlink
>priv space for their main private structure. That would be struct
>ql_adapter in this case. Is there a good reason to stray from that
>pattern?

struct ql_adapter which is created via alloc_etherdev_mq is the
private space of struct net_device so we can't use ql_adapter as the
the devlink private space simultaneously. Thus struct qlge_devlink is
required.

--
Best regards,
Coiby
