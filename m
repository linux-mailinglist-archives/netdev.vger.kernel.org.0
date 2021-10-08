Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDD6426273
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 04:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhJHC3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 22:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhJHC3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 22:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B40560F94;
        Fri,  8 Oct 2021 02:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633660060;
        bh=FgcSH3Si33sVXXIUFvV0ax/Fqii3xw5zeZrGjpX8KKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SKK1sBfzl/9uXgZ0PdZzxMfxLBa3WSIhC5QA/C2zKix8igfWNygdm7wNR5VZsFSMb
         VND3vA9MKcRw8HJG7n2RSZM1/vhhGWAlDLH2OZDoh9W2QlCdMnBdYQ+ne3fC0OhhY4
         FnJkXNkzhZUBM2go2P3Ib1t8OZV3MbPIBkx4jVoX6/6KlOycwinZPkmxnDWD3/IEfc
         JzMCXCiBOo4jBeI48AEDhSa3GRGrOwYY9UUp7KTmLDKleqnJEoizqutsLCAPPKHl4c
         y73K+ENXbJuUYdDJA+v1ZTCxvMMHEtBmCCpj1fF68y+W8/VnvCCRWjNEeB1HkYjP2o
         e+STnbr/ZfnEQ==
Date:   Thu, 7 Oct 2021 19:27:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kys@microsoft.com, sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mana: Fix error handling in mana_create_rxq()
Message-ID: <20211007192739.59feaf52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1633646733-32720-1-git-send-email-haiyangz@microsoft.com>
References: <1633646733-32720-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Oct 2021 15:45:33 -0700 Haiyang Zhang wrote:
> Fix error handling in mana_create_rxq() when
> cq->gdma_id >= gc->max_num_cqs.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
