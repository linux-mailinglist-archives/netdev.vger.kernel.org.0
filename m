Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563C42EA067
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 00:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbhADXE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 18:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbhADXE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 18:04:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3665C207BC;
        Mon,  4 Jan 2021 23:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609801458;
        bh=R8/Mgnh4z8EC2sAL47MBrKCl6ThiI0yHEPc1AioqAZg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iQLRo53ClbAXtP6n7LYmibensqwT09wPSWhfVe7wYLENBzSBoZ5KXOSHGAKCOpoSc
         KgobQagK2KTDkxK3w5tAbLvanQXo2EEQxIelrIcE1UJLbAIm313qEChQhvMDu0+5r2
         fNs6r02QJ4waYwc42Ovks0t3aeteUrMPgoIfWkekUI641h3eFI8nN3W6vL0aO0oaXz
         gT9erXz/EsuZSuH2u+4N0A39BtSRffniEN7/IzYTL4UuYsef8/OGgBjjwuV/Ou9T5p
         BkHlGp/8DCIreyFRBcNZc3TCIYv62n/BcQOAyJ+cZR+IHWNIHJb4KUEun6kkEUwiJO
         4HmaFOutX2kag==
Date:   Mon, 4 Jan 2021 15:04:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <20210104150417.2115a21e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210103192920.18639-1-pablo@netfilter.org>
References: <20210103192920.18639-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 Jan 2021 20:29:17 +0100 Pablo Neira Ayuso wrote:
> Hi Jakub, David,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Missing sanitization of rateest userspace string, bug has been
>    triggered by syzbot, patch from Florian Westphal.
> 
> 2) Report EOPNOTSUPP on missing set features in nft_dynset, otherwise
>    error reporting to userspace via EINVAL is misleading since this is
>    reserved for malformed netlink requests.
> 
> 3) New binaries with old kernels might silently accept several set
>    element expressions. New binaries set on the NFT_SET_EXPR and
>    NFT_DYNSET_F_EXPR flags to request for several expressions per
>    element, hence old kernels which do not support for this bail out
>    with EOPNOTSUPP.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks!

> P.S: Best wishes for 2021.

Happy 2021!
