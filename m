Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C226430B482
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBBBPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhBBBPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 20:15:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3FE964DD4;
        Tue,  2 Feb 2021 01:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612228483;
        bh=r4SBXFKilQAK4Te++xz8kgGSsU1rJ+SGLRmdFBt4Ocs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f17mtyhyxkGy4riaIZannNcex9+GmQTs37DoZNBmGhL/sbqS9/8g+xIkw0SjSmVZu
         2L6tQmTamrtxI+jZbf/PPU85bvlWeShO10eiZ84KHwDO5zG3DEPH323nfXqc9Tv9s0
         wNv9EtXfHrCS/+VXggQWVEJN3PSime6T/sk7QRu9GFzPGZCcp33RQRd3NQ9MfDNv6G
         DbuJvLYsJfFJmV18493K60MjLBt16ZJLTOcxFo12524Ac0HUTuABoS8+wv+aSgiShD
         LQp9QldDMMSUyWU653+bJb8eO+f9+p+3/FW/qAWvTlPLttXOtBA0C5dpfUY2GA5S9C
         6e/lTvAvaO5YA==
Date:   Mon, 1 Feb 2021 17:14:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, saeedm@nvidia.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v6] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210201171441.46c0edaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201020412.52790-1-cmi@nvidia.com>
References: <20210201020412.52790-1-cmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Feb 2021 10:04:12 +0800 Chris Mi wrote:
> In order to send sampled packets to userspace, NIC driver calls
> psample api directly. But it creates a hard dependency on module
> psample. Introduce psample_ops to remove the hard dependency.
> It is initialized when psample module is loaded and set to NULL
> when the module is unloaded.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

The necessity of making this change is not obvious (you can fix the
distro scripts instead), you did not include a clarification in the
commit message even though two people asked you why it's needed and 
on top of that you keep sending code which doesn't build. 

Please consider this change rejected and do not send a v7.
