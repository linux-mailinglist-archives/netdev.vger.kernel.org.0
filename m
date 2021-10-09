Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751D742755A
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 03:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhJIBQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 21:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhJIBQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 21:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CCA860F93;
        Sat,  9 Oct 2021 01:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633742077;
        bh=PGXPfQDsWo5ndIAe7BgQ9USkxeGk3b62bxNyG5UGLd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=paXTN+vevS9m2/vHez84nJ5RaRZhhSDJDWulWbZfqa7HoHNKfHaW5hTgafL9J8ubV
         okN/C4dHlH3+6TfUbq5ltXuzrxk7I7UVCn9+kVaMigI/NzHLqw+NuoYincaCXju65a
         IFWRYER9+TUQ+4rVIkvtsrDVZfgxfjLIZUrxbMBnbl0GSuvwlnLrUNbiF1IOoLyZXL
         jlDakBtzkQkUTEyRP2RBVQmEdyZAzB1TKu0vqFcEG+l0Jjz8uOlwboj+yBtVY0NAOh
         9JhxV8PET2GReX43xWEGhkHVcLPVT77/fg/cWsK7JJUBu+K15uTdETVZjt+IiCAf25
         T38iTz5xbulsg==
Date:   Fri, 8 Oct 2021 18:14:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v15 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20211008181435.742e1e44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1633697183.git.lorenzo@kernel.org>
References: <cover.1633697183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Oct 2021 14:49:38 +0200 Lorenzo Bianconi wrote:
> Changes since v14:
> - intrudce bpf_xdp_pointer utility routine and
>   bpf_xdp_load_bytes/bpf_xdp_store_bytes helpers
> - drop bpf_xdp_adjust_data helper
> - drop xdp_frags_truesize in skb_shared_info
> - explode bpf_xdp_mb_adjust_tail in bpf_xdp_mb_increase_tail and
>   bpf_xdp_mb_shrink_tail

I thought the conclusion of the discussion regarding backward
compatibility was that we should require different program type
or other explicit opt in. Did I misinterpret?
