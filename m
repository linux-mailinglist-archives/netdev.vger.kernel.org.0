Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190D72F243A
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388067AbhALAZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404260AbhALASB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:18:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D61D22C7E;
        Tue, 12 Jan 2021 00:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610410640;
        bh=1+jA8zGmmaPXe5UoGQObKxeySnl2/vI6n7vFfgr7PvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jhtsKzv1huOt26oheSeVLgUjUd8P08xTy4pXc3RAFX0WuaG3JdjARswK2Xva+GcWV
         mPMloGw9uBMzNTOaCr8yI0ZZ7Z1YL+834lW2E46bnu+E1tTCnzeCixVoLVAjJ3ZI7R
         Q3emGI1eJSt1CPuF0fqeJp9soWqZWgHKHw3fRnDCKPfekXUdwxstrIfH6IsfnyIpf9
         VPiuxhGTKsZhQZGP8JDwX1AUp4XiDnH337kx7LFIc58rpb+k/KT3VJHQ7G55C21/DH
         39PP+8owqxb1mxMqUy+c8OmizhB85Kb3HaneBFESsr33GP+gavLQZzukEHttL6NAp3
         TR5kGIfp/IIxQ==
Date:   Mon, 11 Jan 2021 16:17:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next] net: dsa: felix: the switch does not support
 DMA
Message-ID: <20210111161719.3e85b797@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b64a110c-e38e-7cc8-39d8-164cf048f62a@gmail.com>
References: <20210109203415.2120142-1-olteanv@gmail.com>
        <b64a110c-e38e-7cc8-39d8-164cf048f62a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Jan 2021 17:24:39 -0800 Florian Fainelli wrote:
> On 1/9/2021 12:34 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > The code that sets the DMA mask to 64 bits is bogus, it is taken from
> > the enetc driver together with the rest of the PCI probing boilerplate.
> > 
> > Since this patch is touching the error path to delete err_dma, let's
> > also change the err_alloc_felix label which was incorrect. The kzalloc
> > failure does not need a kfree, but it doesn't hurt either, since kfree
> > works with NULL pointers.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!
