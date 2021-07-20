Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49133CF89C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237722AbhGTK0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237177AbhGTKZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 06:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8596C61107;
        Tue, 20 Jul 2021 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626779161;
        bh=+qOpfIZ2KxWKgu9KpXTV7Bv8qCzGPQfDmMztpoZHyv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SEqqevoxN4NlJXodCzUzIjOChh5kcF15Gp82uUtrHgrXKWWK0tY41MNSNW+rufBBE
         C3WYxcVyavA9BM6P01ftdsn0kl92lAUddMYDvrvgfERZ55zcccA5h1IGFaTV9kTGxD
         qZ0Wa5YSpnyG4ZbPf+kHyNk1qyfKcJcFe2Kt8x6m5jLUq6LMTiUdUYCqoNghuolrfR
         svT+DRKJzUTF7x6oCJCPLDtJuG/gdQzJatGJ5uESHopGjgRexa45mCXB6IKxW2+fnA
         vdEJoUAJQ9zP2jWzK8gWqjbSga9iAFKWiXfHXRdWhaiL+UQgrt+eACDR6SQ+0Suwwb
         5AbtFGUblPwtQ==
Date:   Tue, 20 Jul 2021 13:05:54 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jia He <justin.he@arm.com>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nd@arm.com,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: Re: [PATCH] Revert "qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()"
Message-ID: <20210720130554.5c85b3e6@cakuba>
In-Reply-To: <20210720092739.3539-1-justin.he@arm.com>
References: <20210720092739.3539-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Jul 2021 17:27:39 +0800, Jia He wrote:
> This reverts commit 2d2f5ded858a4f4659fc63e01dd55605598a8f05.

The hash looks wrong, the patch was applied to netdev/net AFAICT,
and the ref there is: 6206b7981a36 ("qed: fix possible unpaired
spin_{un}lock_bh in _qed_mcp_cmd_and_union()")

Please tag the subject with "net":

[PATCH net] Revert ...

> That patch added additional spin_{un}lock_bh(), which was harmless
> but pointless. The orginal code path has guaranteed the pair of
> spin_{un}lock_bh().
> 
> We'd better revert it before we find the exact root cause of the
> bug_on mentioned in that patch.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Jia He <justin.he@arm.com>

Please also add a Fixes tag.

Fixes: 6206b7981a36 ("qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()")
