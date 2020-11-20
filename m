Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1923B2BB4DE
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbgKTTKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730265AbgKTTKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:10:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605899407;
        bh=3uUiUzjiGuX5fIXA4qQb1hzZCcnYPITW5x2NxZRww8c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FQbmeuY6yrmRfPrG4t04Bsag0qBG4W+8REFWgSJuxWbnfI8n+gMqI/THOMGMuLnV6
         TGlKGUwd2n9viiO/L65ZmnnO9MJ1jvAVxUqOFHLWQdgGbklumULnJr27GsQCmm/Ted
         GDvLZRijzJ6aTbpVUdV2lrXwrEH42zcuIuj+84oI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v10,net-next,0/3] Add Support for Marvell OcteonTX2
 Cryptographic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160589940691.22082.11413670206268995363.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 19:10:06 +0000
References: <20201118114416.28307-1-schalla@marvell.com>
In-Reply-To: <20201118114416.28307-1-schalla@marvell.com>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, kuba@kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, schandran@marvell.com,
        pathreya@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 18 Nov 2020 17:14:13 +0530 you wrote:
> This patchset adds support for CPT in OcteonTX2 admin function(AF).
> CPT is a cryptographic accelerator unit and it includes microcoded
> Giga Cipher engines.
> 
> OcteonTX2 SOC's resource virtualization unit (RVU) supports multiple
> physical and virtual functions. Each of the PF/VF's functionality is
> determined by what kind of resources are attached to it. When the CPT
> block is attached to a VF, it can function as a security device.
> The following document provides an overview of the hardware and
> different drivers for the OcteonTX2 SOC:
> https://www.kernel.org/doc/Documentation/networking/device_drivers/marvell/octeontx2.rst
> 
> [...]

Here is the summary with links:
  - [v10,net-next,1/3] octeontx2-pf: move lmt flush to include/linux/soc
    https://git.kernel.org/netdev/net-next/c/956fb852181e
  - [v10,net-next,2/3] octeontx2-af: add mailbox interface for CPT
    https://git.kernel.org/netdev/net-next/c/ae454086e3c2
  - [v10,net-next,3/3] octeontx2-af: add debugfs entries for CPT block
    https://git.kernel.org/netdev/net-next/c/76638a2e5850

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


