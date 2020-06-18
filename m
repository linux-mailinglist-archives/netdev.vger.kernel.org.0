Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5271FF2D8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgFRNSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbgFRNSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 09:18:04 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B042073E;
        Thu, 18 Jun 2020 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592486282;
        bh=XUJOGwyVT0oPdt2Xr1/X/9sFB5BfGk+cjJL4hpPUA9k=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=Mrx/rabAngAFQB3lZ2t+oKxpUtDoX5dXp8FnnNfCfSNpmoK00bXJpaR5EV0/Qq/TX
         GyuY6HAI23vW1zSiRdx7GN1N1v0kxdz2y9FEl/Ie2ANu4OE9Hu25ck7oJ8TrX+EH79
         d1Ed1rchxVkKPy9iAOW8aGZ6B8VX5NfSPiHYJdRc=
Date:   Thu, 18 Jun 2020 13:18:01 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Chen Yu <yu.c.chen@intel.com>
To:     davem@davemloft.net
Cc:     Chen Yu <yu.c.chen@intel.com>, netdev@vger.kernel.org
Cc:     <Stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [net 1/3] e1000e: Do not wake up the system via WOL if device wakeup is disabled
In-Reply-To: <20200616225354.2744572-2-jeffrey.t.kirsher@intel.com>
References: <20200616225354.2744572-2-jeffrey.t.kirsher@intel.com>
Message-Id: <20200618131802.16B042073E@mail.kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)").

The bot has tested the following trees: v5.7.2, v5.4.46, v4.19.128, v4.14.184, v4.9.227, v4.4.227.

v5.7.2: Build OK!
v5.4.46: Build OK!
v4.19.128: Build OK!
v4.14.184: Build OK!
v4.9.227: Failed to apply! Possible dependencies:
    c8744f44aeaee ("e1000e: Add Support for CannonLake")

v4.4.227: Failed to apply! Possible dependencies:
    16ecba59bc333 ("e1000e: Do not read ICR in Other interrupt")
    18dd239207038 ("e1000e: use BIT() macro for bit defines")
    74f31299a41e7 ("e1000e: Increase PHY PLL clock gate timing")
    c8744f44aeaee ("e1000e: Add Support for CannonLake")
    f3ed935de059b ("e1000e: initial support for i219-LM (3)")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
