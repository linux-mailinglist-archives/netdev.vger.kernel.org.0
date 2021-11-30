Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EDB46399E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243961AbhK3PRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:17:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39930 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244858AbhK3PQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:16:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3795CE1A0D;
        Tue, 30 Nov 2021 15:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756D1C53FC1;
        Tue, 30 Nov 2021 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638285186;
        bh=nIS7rhL2Hg2Jxh77suuv7PBv670aiPweqb3ofL8cjy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mVE38cq7UsTCABRKP+wGlkr7SWyGVy+y5w90eBUp04v0RNHxS9gjR2NV71KhTzx4m
         KefBJ7GIfw3j+uIxozM8GsKZLdLAUfc7KTvX+u+nbOeXhNXaLLUJ1HZY2g1jodg2SK
         IG1etQ4ojCRFCrsPsf6ykRAKEYGOxTKby2VnQtyaezay6ST7BVRgcRLajK3+ovL0KR
         4vWCqGReZZL2msbe7Ko5dDFumm/T+5YVsl8KwUFaMmiOKiwUCq4anql9RgEwnBQxx4
         dQ+zTGHxHlqRndQKoooZbA8NTVVTdhWHey7DomZ8bNfmIn4bWpBfHw4BvFjC3tgZNP
         RCM8glqOaZW4w==
Date:   Tue, 30 Nov 2021 07:13:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v1] devlink: Simplify devlink resources
 unregister call
Message-ID: <20211130071305.28c3121c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YaXaHCW3/WQiiTeS@unreal>
References: <e8684abc2c8ced4e35026e8fa85fe29447ef60b6.1638103213.git.leonro@nvidia.com>
        <20211129201400.488c8ef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YaXaHCW3/WQiiTeS@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 10:00:28 +0200 Leon Romanovsky wrote:
> > Hiding struct devlink_resource is not mentioned in the commit message
> > and entirely unrelated to removal of the unused argument.  
> 
> devlink_resources_unregister() was the API function that is declared in
> the devlink.h that used "struct devlink_resource". Once we removed extra
> parameter from that function, the "struct devlink_resource" left as not
> used at all. So this "hiding" is related and part of this simplification
> patch.
> 
> I will add it to the commit message.

Forward declarations exist. The author did not have to disclose the
definition of the structure. Removing this definition is not related,
you just like doing it.
