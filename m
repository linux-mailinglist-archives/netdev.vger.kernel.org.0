Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DCD44D581
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhKKLJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhKKLJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 06:09:42 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6C4C061766;
        Thu, 11 Nov 2021 03:06:53 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6E54B22236;
        Thu, 11 Nov 2021 12:06:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1636628811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B5p/dVLuXbGMx3xKBjTjbL8B54ECPpXqaKXphyHJO7E=;
        b=sny/fJeTTbB1LxeKNQ6ky8Td0TS9hNWMvjXWvGDK/qaWkMCYm9294Lrt5qS24nBrjSNmZN
        v6N9/sPEDs2GBp8HyOp67c2S+tDNA+wXwoq2L8s9dOzJY2/1/tj1Jmi18wLo4NxfQCTcXz
        tE9x3jmoLvvan3YvqGvWOHYirbjS/do=
From:   Michael Walle <michael@walle.cc>
To:     apeksha.gupta@nxp.com
Cc:     LnxRevLi@nxp.com, davem@davemloft.net, hemant.agrawal@nxp.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nipun.gupta@nxp.com,
        qiangqing.zhang@nxp.com, sachin.saxena@nxp.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH 0/5] drivers/net: add NXP FEC-UIO driver
Date:   Thu, 11 Nov 2021 12:06:42 +0100
Message-Id: <20211111110642.3340300-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211110054838.27907-1-apeksha.gupta@nxp.com>
References: <20211110054838.27907-1-apeksha.gupta@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[linux-devel@linux.nxdi.nxp.com doesn't exist in the public, which is quite
annoying when you reply to an email and the MTA doesn't accept it due to
invalid domains]

> This patch series introduce the fec-uio driver, supported for the inbuilt
> NIC found in the NXP i.MX 8M Mini SoC. Basic hardware initialization is
> performed in kernel via userspace input/output(UIO) to support FEC
> ethernet device detection in user space.

Could you elaborate for what this driver is needed? Doesn't the imx8mm
already have a network driver? What is the difference between them?

As a user, I couldn't find what this is all about, neither in this
commit message nor in the Kconfig help text.

> Userspace PMD uses standard UIO interface to access kernel for PHY
> initialisation and for mapping the allocated memory of register &
> buffer descriptor with DPDK which gives access to non-cacheable memory
> for buffer descriptor.
> 
> Module fec-uio.ko will get generated.
> imx8mm-evk-dpdk.dtb is required to support fec-uio driver.

-michael
