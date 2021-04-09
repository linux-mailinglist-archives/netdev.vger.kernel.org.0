Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FA735A727
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhDITbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhDITbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 864736100B;
        Fri,  9 Apr 2021 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617996693;
        bh=slU6M+NDPqsUa2ktoqjSi0a+Hy3kzHGCj3dOZ0o5YGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gDYCl1492CqKk8Sb74+MusG2oCQDxz2A9k4uSbiqxuox8M9xpZff80AWAv8YUqhgG
         tkmRDEBXexltmZg4WZg5igb0z6TnkYsi6ruvyQC0O251LcL5b7JlhRtnCBY3OV8FZC
         co7Oo3hRBuHC1yz4eLQzsYyLf61+9Yg+TTWr9IR8Ugpnp79Zo+shx+obZgbQ0/qa5P
         MvFtxMuwDmbiYo/Wpg42AvMF33mjyLs9CHDo16jBJ79a+c121lHqYV7iB8AwrHbASo
         HPLbzyAvtUShLTpfugip/hW/8yTy5rfkPJHsZuifdTD1bG3f2zD0n/znETQ2Jr6Crm
         ms5VcDEmRhTtw==
Date:   Fri, 9 Apr 2021 12:31:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <20210409123132.351d65fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Apr 2021 21:41:06 +0300 Radu Pirea (NXP OSS) wrote:
> Add driver for tja1103 driver and for future NXP C45 PHYs.
> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>

drivers/net/phy/nxp-c45: struct mdio_device_id is 8 bytes.  The last of 1 is:
0x10 0xb0 0x1b 0x00 0xf0 0xff 0xff 0xff 
FATAL: modpost: drivers/net/phy/nxp-c45: struct mdio_device_id is not terminated with a NULL entry!
make[2]: *** [Module.symvers] Error 1
make[1]: *** [modules] Error 2
make: *** [__sub-make] Error 2
