Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF3A3F21EF
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 22:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhHSUxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 16:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhHSUxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 16:53:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5ECA60200;
        Thu, 19 Aug 2021 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629406359;
        bh=wdL8a/fXPWpVp5mfgdFlPXoXUvv9vnXL6JSjBLeymuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fAiHeT3YvAA2PDxj2uln6KTyXKsqvS1Q7M0MsIjyuP0Z3OQCcgjajHVxwJPkdyE8G
         NN8L6aaHNVimj+xOGnS1m5NW8Pt0Z0fdLI7NSBpKfZJszK1C3ubFiAbYrLHeXRCiJt
         GJYQQHKfV/x/Z5bOsaryf7ogxJos/ajVRKEqHl6A/3LROdeoFiCoIZGbtwzyE3d89J
         g6iD/dYRatDTFbwgFFW0iu63WmFuVh+2iAmxRTspzWUc8PiwfFnAH/ARAH+3mKHEVW
         NXXTv3ZdKdLnIYOIghhA9jkzUoK/HHKwZSgA8siuNM7nXPlxTHDeVQxyVVDDulrEtO
         SLlokJTA/fwug==
Date:   Thu, 19 Aug 2021 13:52:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCH 2/6] batman-adv: Move IRC channel to hackint.org
Message-ID: <20210819135238.354db062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819153334.18850-3-sw@simonwunderlich.de>
References: <20210819153334.18850-1-sw@simonwunderlich.de>
        <20210819153334.18850-3-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 17:33:30 +0200 Simon Wunderlich wrote:
> From: Sven Eckelmann <sven@narfation.org>
> 
> Due to recent developments around the Freenode.org IRC network, the
> opinions about the usage of this service shifted dramatically. The majority
> of the still active users of the #batman channel prefers a move to the
> hackint.org network.
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>

This one is missing your sign-off:

Commit 71d41c09f1fa ("batman-adv: Move IRC channel to hackint.org")
	committer Signed-off-by missing
	author email:    sven@narfation.org
	committer email: sw@simonwunderlich.de
	Signed-off-by: Sven Eckelmann <sven@narfation.org>
