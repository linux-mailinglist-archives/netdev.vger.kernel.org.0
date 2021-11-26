Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EC545E68C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357817AbhKZDcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhKZDak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:30:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 510AB61059;
        Fri, 26 Nov 2021 03:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637897248;
        bh=yVOf9bLfdfNCUg8gSnriQ+l9Qf5+yCvOYQUOBsvzx8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=st+pbfomLoJASLcpBrRAcPheUVEPM/dVBTzHCiKpWFHyR3Ws749/fAU+MqwhBNReT
         1tiXJ7GKSzinP//SuVWWk7EDzs7dLFf5sGA9hqHoovt8Y6gef7PDAdvm/YTEPzSAvs
         BlRWyH8pmZA6Q+OkedvbW0GUbAiqCqk2eQiRsSgX3+V1iOJiCKelHs6sLD2QVYZ2kS
         ydwQJyELwNJ6n7PfF95Clj7fvaWlEycSXMA5acNjFIem69AiSJxnTD/HbJJslRUB/x
         sjk0jiHi70rj9TA8k9wWprXLiP33iZ9oZJekPoIaAN6cpRy8fToTW0QVbLpkYCKgQ9
         xolNvgCwAhLmA==
Date:   Thu, 25 Nov 2021 19:27:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rxrpc: Fix rxrpc_peer leak in
 rxrpc_look_up_bundle()
Message-ID: <20211125192727.74360e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
References: <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 14:37:33 +0000 David Howells wrote:
> From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> 
> Need to call rxrpc_put_peer() for bundle candidate before kfree() as it
> holds a ref to rxrpc_peer.
> 
> [DH: v2: Changed to abstract out the bundle freeing code into a function]
> 
> Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> Link: https://lore.kernel.org/r/20211121041608.133740-1-eiichi.tsukata@nutanix.com/ # v1

Are these supposed to go to net? They are addressed To: the author.
