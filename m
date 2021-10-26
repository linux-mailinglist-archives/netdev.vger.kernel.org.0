Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE37E43A964
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 02:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbhJZAsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 20:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234838AbhJZAsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 20:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B178360C4B;
        Tue, 26 Oct 2021 00:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635209174;
        bh=0U/WOPk1mOLqS9/rTm9CtSBpFFWPAklU0LH+BKcV1E4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sXDUurUTM9CXDtIkBiOk0c64tRuecP0F/uKOitj37XJ331qGA31eg6++yO8lw7gJp
         XbSqFoK2gAyGjNTkhdTAGtR7cktSNHEZlxTl64BjFwIz8WCKBNPdtOezAJx2DQCFxN
         03jrCoYvtVdIBb7lViNbz7gFLm506I3DCmZfTe1JANALlH61s58KGkb6mUbFIepbMU
         zL0PQcvlb4Qd+PkQ85G1bBHTsjhGL3sm7kf+iZlHEZ9l4dgliRSKz8ZVIj/fGA2HMG
         FtsaG306iTZmwdD2HlslApks6JbJtGCaAnStzQJsxgmsFcNHHHkEyg2jU/m8NMe92i
         hKrQadUiLuu8w==
Date:   Mon, 25 Oct 2021 17:46:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] amt: add initial driver for Automatic
 Multicast Tunneling (AMT)
Message-ID: <20211025174613.3c0a306b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211023193055.11427-1-ap420073@gmail.com>
References: <20211023193055.11427-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Oct 2021 19:30:55 +0000 Taehee Yoo wrote:
> This is an implementation of AMT(Automatic Multicast Tunneling), RFC 7450.
> https://datatracker.ietf.org/doc/html/rfc7450
> 
> This implementation supports IGMPv2, IGMPv3, MLDv1. MLDv2, and IPv4
> underlay.


Lots of sparse warnings here, please build the new code with C=1.
