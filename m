Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3DA43AC67
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 08:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhJZGuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 02:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbhJZGuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 02:50:06 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B46C061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 23:47:42 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t7so13179672pgl.9
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 23:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:to:cc:subject:date:in-reply-to:references
         :content-transfer-encoding:mime-version;
        bh=N7foNZMWCuMt/RHjVPWBs+8YsDXAMxeDDYI8SswUvrE=;
        b=JB4Dk2d58N0NhD56t6G1EKifcd3Cnj05F5jI25jEvPXzc8IgAwYyqKwboKIVzaB4sn
         6uuKYfH5MDBSgPMGfl52MuPJvuueyiXWvUMEZGxsqkltUzmhlMSo1ovHquCC8tHu2l8I
         /Oq0c4jCUvJ3CzuSY0u9eOFDO+A5Im+rLBcfQiV1UdKf54DFkk+8RINkE+C6cwResalK
         AY3LbdHNVlWSJk+Gbz2TCH7/pp35R7dhymnXUqpSL9SJGl3ykEnj9b5ma89VovWRMNxT
         0OtbFR5KYypQZLDc/oRPTXMx0l1EgHdkXUfPFHsYafnEqkma+NskGjrPegn9PXZLrwwK
         kLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:to:cc:subject:date:in-reply-to
         :references:content-transfer-encoding:mime-version;
        bh=N7foNZMWCuMt/RHjVPWBs+8YsDXAMxeDDYI8SswUvrE=;
        b=x96qQFCMGgODkDCXuTrxsfyuJCZ2vcN6f3dmKmsUqJuYnNqXmnmGIEXJ6WOhgwCTlw
         Mv8W39zfNCnMplqa1oOG0Et3DCILs8msMCxd2dIkFU+8E4dRs7Kmkjz1Wn2Xd+ATm97J
         wonhLVOThf61sFuh5ey4asXwjyb74Bi94eCFqzQpP9BH4gMTl8EPChziWZ99BYPpOh21
         fkFdl5zuDvMx1O10lQqwsiqjjNugVyPq0NU80KH8enuVkAUj37Q+IVeht4tPmhZ9JwUy
         6CFV+At2FfCYHCqeJwHVPOxOOI/uOBVw06zCC9RidUJRCmXpLsQd25PPRDoG1kgMItBf
         x45g==
X-Gm-Message-State: AOAM530l5WHxXGEymzhq107DeK2PgOzBSgtmwoV1PDh+tUCPvgfOdhW/
        rIODpIdnbCbDmXuNkJSSfMcBBion17Xx
X-Google-Smtp-Source: ABdhPJytqzrg4Qq8ugiNz+0HGbknnb3BQqcgXD7t9I7zpPpGh0WFViM6EiZyTsk+8tefLXPZL1T/Bw==
X-Received: by 2002:aa7:8209:0:b0:47b:df8c:7ec5 with SMTP id k9-20020aa78209000000b0047bdf8c7ec5mr18341146pfi.7.1635230862183;
        Mon, 25 Oct 2021 23:47:42 -0700 (PDT)
Received: from localhost ([114.201.226.241])
        by smtp.gmail.com with ESMTPSA id h13sm1281185pfc.140.2021.10.25.23.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 23:47:41 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed
Message-Id: <1635230304726.3600358701.2992435442@gmail.com>
From:   Janghyub Seo <jhyub06@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Add device 10ec:8162 to driver r8169
Date:   Tue, 26 Oct 2021 06:47:26 +0000
In-Reply-To: <ab517ec9-4930-474f-eb7e-34548afd5aaa@gmail.com>
References: <ab517ec9-4930-474f-eb7e-34548afd5aaa@gmail.com>
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tuesday 26 October 2021 05:27:55 AM (+09:00), Heiner Kallweit wrote:

 > On 25.10.2021 16:55, Janghyub Seo wrote:
 > >
 > > This patch makes the driver r8169 pick up device Realtek Semiconductor 
Co.
 > > , Ltd. Device [10ec:8162].
 > >
 >
 > Interesting that still new PCI ID's are assigned. Can you post the 
output
 > of dmesg | grep r8169 ? I'd be interested to know which chip version 
this is.
Yes, this is my output:
[    9.367868] libphy: r8169: probed
[    9.368507] r8169 0000:03:00.0 eth0: RTL8125B, 04:42:1a:85:c8:87, XID 
641, IRQ 71
[    9.368515] r8169 0000:03:00.0 eth0: jumbo features [frames: 9194 bytes, 
tx checksumming: ko]
[    9.802815] r8169 0000:03:00.0 enp3s0: renamed from eth0
[    9.867245] RTL8226B_RTL8221B 2.5Gbps PHY r8169-0-300:00: attached PHY 
driver (mii_bus:phy_addr=r8169-0-300:00, irq=MAC)
[   10.060719] r8169 0000:03:00.0 enp3s0: Link is Down
[   12.747165] r8169 0000:03:00.0 enp3s0: Link is Up - 1Gbps/Full - flow 
control rx

 > What kind of system is this?

It's a laptop computer, specifically `ASUS ROG Zephyrus G15 GA503QE`.

