Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC09C41A44D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238330AbhI1Av5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238236AbhI1Av4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 20:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3412D611C0;
        Tue, 28 Sep 2021 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632790218;
        bh=cbujdjTTm0D/u4CJF1Jz9vGIjRG8vE+ox6QJ42kveEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dUmnnVOh1BFbnJB14CLNXgzBRaB3ART+roH7T6GmrGd4NZzNyfTclJmf8m4e732Gz
         u2D2/Ze7D6UAd2msCoNQ0lT5ZkX/AcF0btTP34qGdKw/RMFqYbqgNW9j+3+x78b7wi
         3phSOwQKLAdBPCVbtezqA/+x6PVZ62il0tXR1NtUrHP9pAGOh4FHfonqKauPf128HB
         EjSMWJgyBZbrEuP44p4R5Kgzru61yeUDXuWoKvO5cus79fzCV7Jl5/Ib6qHNkxIWwL
         uvuZPfu8D7xr1D69VfJ4ghy/C/8+GILDJfP0qtcdm6X57MEujoZUux4/EkyA8BA1gg
         GLixVIRtPi0eA==
Date:   Mon, 27 Sep 2021 17:50:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 0/3] net: add new socket option SO_RESERVE_MEM
Message-ID: <20210927175017.57348a9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210927182523.2704818-1-weiwan@google.com>
References: <20210927182523.2704818-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Sep 2021 11:25:20 -0700 Wei Wang wrote:
> This patch series introduces a new socket option SO_RESERVE_MEM. 
> This socket option provides a mechanism for users to reserve a certain
> amount of memory for the socket to use. When this option is set, kernel
> charges the user specified amount of memory to memcg, as well as
> sk_forward_alloc. This amount of memory is not reclaimable and is
> available in sk_forward_alloc for this socket.
> With this socket option set, the networking stack spends less cycles
> doing forward alloc and reclaim, which should lead to better system
> performance, with the cost of an amount of pre-allocated and
> unreclaimable memory, even under memory pressure.

Does not apply cleanly - would you mind rebasing/resending?

Would you be able to share what order of magnitude improvements you see?

Thanks!
