Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD0C6ABA03
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 10:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCFJgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 04:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjCFJgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 04:36:11 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC0C23323
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 01:36:02 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id a25so36018919edb.0
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 01:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678095361;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+vFW5To1+smj2gw7atPORu0HKgb6eHRbuZNVD+S3Cyw=;
        b=J6ixpz0GbkIYexAg0M01qPupSYB727GvC0vLtPh47Rrg8Ona6DbLgjTVPdZDHAUK+c
         6jA7BBlIRDqds8yA3SORrovAyRdJzm6gdBwaxN25rZDBhV7MaFNNDFQlMPHBe891O3vq
         mtLIVIROFgqDMtqECZLh2Neo2duonp2/uJ+28sLo6NxFSgkDu77m729WJ1qIOIxoA3iK
         wYgWz20kfbF449vHNSVFASFXtTXYg9czPqJ+fydVbxl4PrnsMKLHmLNtsJ59g2gg26b2
         GH6L77Pdth8c3P2sfLe/+pMS19hH06R4ClLKk6gX2GSEnPbnIyR47usZvbJszHr6L5PD
         kHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678095361;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+vFW5To1+smj2gw7atPORu0HKgb6eHRbuZNVD+S3Cyw=;
        b=ZbNZWX/Rboh6DEbHpkhf9gTqxVidlWT+4+G8Yx0LV8iFHJmMvrzrjzCMncm0K6W/sS
         1e0x7ev2HNJk46gImRz+wVv5Pr9VUzg2AWHdPIbPPK1t2zlrhYlLQX//Au0z/m4wf7bX
         lBp1H1ubVQBe0VhbOP5FOJe/0WLbyUL9KOfxnVHz6RLzro7qMdqZDcNtsQqhRRqpirzq
         tIfBvLqi1QA1TMWRYUVqMXf/imMYig0NRMEHHvkxcrxjLnloicM7XtzcTzsapCIEUnbW
         PJqphsVC+Oe9SpK3Yusn6MxRgIHTA16DkoN5CpT3lcl9NVvsdi/Y3cikVpxoLuXXlgYD
         wFgQ==
X-Gm-Message-State: AO0yUKUy52VY1mwoh7zBsF7JkXiSbJQcsdMvbkDw7vrcDIiM+YCea+KY
        ovhlohGYiWbA6nKU7wz5TVppc1LVb4Sw2W/Usx4=
X-Google-Smtp-Source: AK7set975TR0YRg8Sl3kS8cuQl5EJt5wlQKTlrttc/bhpiMyDZxkMXnbkUdiMFDLn8dSpsXrK62P7g==
X-Received: by 2002:aa7:d305:0:b0:4c0:4912:2006 with SMTP id p5-20020aa7d305000000b004c049122006mr8077733edq.11.1678095360979;
        Mon, 06 Mar 2023 01:36:00 -0800 (PST)
Received: from localhost ([203.28.246.189])
        by smtp.gmail.com with ESMTPSA id r29-20020a50d69d000000b004af70c546dasm4794446edi.87.2023.03.06.01.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 01:36:00 -0800 (PST)
Date:   Mon, 6 Mar 2023 11:35:54 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     =?utf-8?Q?Stanis=C5=82aw?= Czech <s.czech@nowatel.com>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: htb offload on vlan (mlx5)
Message-ID: <ZAWz+iSrxfLnXX+N@mail.gmail.com>
References: <dccaf6ea-f0f8-8749-6b59-fb83d9c60d68@nowatel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dccaf6ea-f0f8-8749-6b59-fb83d9c60d68@nowatel.com>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 07:04:43PM +0100, Stanisław Czech wrote:
> Hi,
> 
> I'm trying to use htb offload on vlan interface using  ConnectX-6 card
> (01:00.0 Ethernet controller: Mellanox Technologies MT28908 Family
> [ConnectX-6])
> but it seems there is no such a capability on the vlan interface?
> 
> On a physical interface:
> 
> ethtool -k eth0 | grep hw-tc-offload
> hw-tc-offload: on
> 
> On a vlan:
> 
> ethtool -k eth0.4 | grep hw-tc-offload
> hw-tc-offload: off [fixed]
> 
> so while there is no problem with:
> tc qdisc replace dev eth0 root handle 1:0 htb offload default 2
> 
> I can't do:
> tc qdisc replace dev eth0.4 root handle 1:0 htb offload default 2
> Error: hw-tc-offload ethtool feature flag must be on.

Hi Stanisław,

That's expected, vlan_features doesn't contain NETIF_F_HW_TC, and I
think that's the case for all drivers. Regarding HTB offload, I don't
think the current implementation in mlx5e can be easily modified to
support being attached to a VLAN only, because the current
implementation relies on objects created globally in the NIC.

CCed Nvidia folks in case they have more comments.

> 
> 
> modinfo mlx5_core
> filename: /lib/modules/6.2.1-1.el9.elrepo.x86_64/kernel/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko.xz
> license:        Dual BSD/GPL
> description:    Mellanox 5th generation network adapters (ConnectX series)
> core driver
> author:         Eli Cohen <eli@mellanox.com>
> srcversion:     59FA0D4A4E95B726AB8900D
> 
> Is there a different way to use htb offload on the vlan interface?
> 
> Greetings,
> *Stanisław Czech*
> 
