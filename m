Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0A3EE07D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhHPXjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232795AbhHPXjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:39:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5B7160F35;
        Mon, 16 Aug 2021 23:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629157138;
        bh=52TP+PQiVvIBz51C9ZPc0IrdwAmeo/svRG3yMfvdKhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TllsMgDo8gQxsHjYkhCoZcBvenYV1Dhoi6PHYz37CzmnYRkCL9LXGT1ELqfaQW7Mt
         rFaod8XbLwLBCoKniTPWJwhSV8LjXCnG5XFNFI0uHTfZ3t64bdxzvvGm/RQDiaFECy
         wKxxZk2QYkubW3XhFrmjhLPx1DHXjh8C5bPzJBXzQSKAmYYs1LAVxVNQT+wmZOSX6x
         motaGLiOKOmRG90Ov+6FkV3WiVNpctIwCekUiUiNw87804XsdBd1sqzy4YFFr9CPva
         bsq6Rc0thMrYwJSymLFYtLggnRk3IU0jYqlmqS2hq0C68WbbpSSaN3zvghGsG6p3Xj
         qxJoVwvoSF7tw==
Date:   Mon, 16 Aug 2021 16:38:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net
Subject: Re: [PATCH] vrf: Reset skb conntrack connection on VRF rcv
Message-ID: <20210816163857.33471874@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <58456069-ede2-bd22-e219-807c21a646fc@gmail.com>
References: <20210815120002.2787653-1-lschlesinger@drivenets.com>
        <d38916e3-c6d7-d5f4-4815-8877efc50a2a@gmail.com>
        <20210816144119.6f4ae667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <58456069-ede2-bd22-e219-807c21a646fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 17:28:49 -0600 David Ahern wrote:
> >> Looks correct to me.
> >> Reviewed-by: David Ahern <dsahern@kernel.org>  
> > Fixes: 73e20b761acf ("net: vrf: Add support for PREROUTING rules on vrf device")
> > ?  
> 
> This one.
>
> > Or maybe it fixes commit a0f37efa8225 ("net: vrf: Fix NAT within a
> > VRF")?

Applied, thanks!
