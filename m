Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69ECD2A1B5E
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 01:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgKAAWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 20:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgKAAWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 20:22:32 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F3BC20723;
        Sun,  1 Nov 2020 00:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604190151;
        bh=ZI3+5zl4BTVOn4iKvxKDry92OkkLDY2bbPgYhl0JOF0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sMtaDOXnHeLpg8KVKDrMcbJkNU1Ir+ZPbzd5tVkwykYnrrYN3Cgh2OLP0pe0vBDSo
         VMgGYyVe3/eevWdn71zmo47Rd0tZ1h1oWmTg4psI0vRTf15nnZJpiA67Hh2D0nfyiT
         fvhgIU0TDOCkhuXA3vVF7omnVQszkpV/yZ3HIo68=
Date:   Sat, 31 Oct 2020 17:22:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
Message-ID: <20201031172230.6a5120e2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1604028728-31100-1-git-send-email-wenxu@ucloud.cn>
References: <1604028728-31100-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 11:32:08 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The tunnel dvice such as vxlan, bareudp  and geneve in the lwt mode set
> the outer df only based TUNNEL_DONT_FRAGMENT. 
> And this is also the some behavior for gre device before switching to use 
> ip_md_tunnel_xmit as the following patch.
> 
> 962924f ip_gre: Refactor collect metatdata mode tunnel xmit to 
> ip_md_tunnel_xmit
> 
> When the ip_gre in lwt mode xmit with ip_md_tunnel_xmi changed the rule and
> make the discrepancy between handling of DF by different tunnels. So in the
> ip_md_tunnel_xmit should follow the same rule like other tunnels.
> 
> Fixes: cfc7381b3002 ("ip_tunnel: add collect_md mode to IPIP tunnel")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Applied, thanks.
