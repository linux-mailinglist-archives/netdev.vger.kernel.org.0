Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8153EA5FF
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 15:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbhHLNvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 09:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232873AbhHLNvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 09:51:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11D0460EB5;
        Thu, 12 Aug 2021 13:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628776274;
        bh=+rTj9T8+qf3vER5Y6gQE40Pk6KGBv8elXJ5k+GEqStU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tzVWSUDT4l4z1WP7BTvdmr6AQwi+tEPw85TlaTqOAdRMdpbR+M1AZCtRmARo4MRwz
         RxNUSOIVoYnoL8eA8Nf+iVgXPbaVfkwCEQXrXp8QXaN2uZ7UANS+n6o3XvFhMKEMgp
         kkY2/OyE7tKumBXKhnF+/TLvWhfvzJ71mYsbboydOjqKyq6h9bh2ZxSoojHIedDkPc
         SoGmMmxTB+65wkgmfM/Ppf3UDGKEu+LqLZ+kvek3VbZ6M1W87dNy+nAVJQxxjjHxyA
         EnP9M/9dHVXD+DAovkOpiWdJkWg4EOYkgBMFONbfYvzPszeLRxb12AwjP3kQNT/Vex
         5eeYFf4U+jw/g==
Date:   Thu, 12 Aug 2021 06:51:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        richard.laing@alliedtelesis.co.nz, linux-arm-msm@vger.kernel.org
Subject: Re: [RESEND] Conflict between char-misc and netdev
Message-ID: <20210812065113.04cc1a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812133215.GB7897@workstation>
References: <20210812133215.GB7897@workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 19:02:15 +0530 Manivannan Sadhasivam wrote:
> Due to the below commit in netdev there is a conflict between char-misc
> and netdev trees:
> 
> 5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MRU")
> 
> Jakub, I noticed that you fixed the conflict locally in netdev:
> 
> d2e11fd2b7fc ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> 
> But the commit touches the MHI bus and it should've been merged into mhi
> tree then it goes via char-misc. It was unfortunate that neither
> linux-arm-msm nor me were CCed to the patch :/
> 
> Could you please revert the commit?

Apologies for missing the lacking CC list, the extra resolution work,
etc. etc. Let me try to sharpen the "were maintainers CCed" check in
patchwork to make this less likely in the future.

About the situation at hand - is the commit buggy? Or is there work
that's pending in char-misc that's going to conflict in a major way? 
Any chance you could just merge the same patch into mhi and git will 
do its magic?
