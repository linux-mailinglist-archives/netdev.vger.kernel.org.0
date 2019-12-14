Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3B511F41F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 22:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfLNVEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 16:04:42 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35391 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfLNVEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 16:04:42 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so1341439pgk.2
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 13:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GxVk8Us4QX0jIO77zzqxGEHCBtxb+KyT8rmpJGUmZuU=;
        b=sspMMPMo/UCMTdkijA0v+pMjxer5k5AfsxWwFTW3Al37N9RQwN1LKShOIHhsvicxO0
         NShCXo+c4GNJSYUB96M/WcBlnDXVCBy33+4PllwNT4i51Whoh8J6A66U5DbkBNy4RL7X
         gEfODwTvDNQP4Fzae363LZ79emcthEmqaKgd9Xq1W5rbC1MNqTdPOvcC7XI2L8pwKAXw
         4MIrqbR/qXnzO1AR+2lkU9vQ8QRWFNR1/YeGrTX+Z8/Sv9FrQAm6RiZiWosh9oRLK5z5
         1LpT6Z8nX3srceLroxJlarvHm3LavjmXdOHZe4K4R+FnFVhlGAD4xqjJJDrT1YCzJCKD
         O0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GxVk8Us4QX0jIO77zzqxGEHCBtxb+KyT8rmpJGUmZuU=;
        b=it4cJhAANNOEzqz2EttRs74GPt2MnsWKv7Imlny66chLMLXGwU0fGE0SGoUYLtA4Xd
         Z8idub1UFf5+XRUkORJXkytT19YBKLXdSqRm8ApEPGblaX/dUH35/+CQ6JAhO3yESea0
         QqDS0OIIBirkDPNkYw0AQ/mWM66J/8yHppKW7/xzWEcht76EdFWV1xkksi4BpsMcoLJ8
         H+PghyrVt/odemK90I3Mx92zPf3n2El5N9MTHHE+AtWnaoT4SR5nZ20rK5xCOb4B2jzy
         yJol82pLFQU3OrLhINCh9bE2EKKCwLM0+xa3iE3EDL1vxEJ/1B7kXEbdbn960r0v5TRD
         Y4Iw==
X-Gm-Message-State: APjAAAUjwQ0Vw/a2595sOnhfIccmFv3P50P42ZigkZENEL1Pv8l6W1G2
        B1DjbRbv9ic4xhRv2Y9zVhf4gZM/aK0=
X-Google-Smtp-Source: APXvYqxCHO/oDw2VeKW2MmTcvM2fOoJ2mbJGXVi7VMe0pEFuKPJkqMosDRNKsI2AtZPC1Tk5GMR+Qg==
X-Received: by 2002:a63:9d07:: with SMTP id i7mr8034393pgd.344.1576357481878;
        Sat, 14 Dec 2019 13:04:41 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id g191sm16103115pfb.19.2019.12.14.13.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 13:04:41 -0800 (PST)
Date:   Sat, 14 Dec 2019 13:04:38 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <aelior@marvell.com>, <skalluru@marvell.com>
Subject: Re: [PATCH v2 net 0/2] bnx2x: bug fixes
Message-ID: <20191214130438.34353698@cakuba.netronome.com>
In-Reply-To: <20191211175956.11948-1-manishc@marvell.com>
References: <20191211175956.11948-1-manishc@marvell.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 09:59:54 -0800, Manish Chopra wrote:
> This series has two driver changes, one to fix some unexpected
> hardware behaviour casued during the parity error recovery in
> presence of SR-IOV VFs and another one related for fixing resource
> management in the driver among the PFs configured on an engine.
> 
> Please consider applying it to "net".

Applied to net, thank you. I'm not queuing for stable because there
were no Fixes tags. Please try to provide those, even if they just
point at the initial driver commit.
