Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769892F69A5
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbhANSeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbhANSeo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 13:34:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F08123B1A;
        Thu, 14 Jan 2021 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610649243;
        bh=7Ob49bvS1Q/8oWaAH0J5ILup9PX2XqAipLc7yfNBWQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r+a14GuoKoTvM9/sT6Xh84PMjrVlFhPaL6Z6BHikBPawau7xFoSVxuFgCNxSQSVNV
         AQV/gP+K3mQmQTHwOoZLH+NkbNA3GkyD66Bj6lepNqMa0htEoLOt/md2BV2Qt/2LuZ
         K/1YwARXGnlSVoMU7lokDHROuK3BvgzHeGkAheLPFhnKGp4EVC2x+EWsHf84Go4B/p
         Wc9D6GQY05XcE9c5M1/u4cUdRLNCuTgYj8+Kt9cn+hzxFdmIJrdWXC6gP9mkNyrmUK
         JKqbMzPz3usNAUSWv5w6sLqXUsCk+V2qATNm1c2Wz9o8uvsR6gbIaXgw1Qg5NPPcKM
         C6z3TNLAqFJ5g==
Date:   Thu, 14 Jan 2021 10:34:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jon Maloy <jmaloy@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ying Xue <ying.xue@windriver.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH v6 12/16] net: tip: fix a couple kernel-doc markups
Message-ID: <20210114103402.31946ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <da52ef69-753a-7aa8-a2b1-1b5ef48df94e@redhat.com>
References: <cover.1610610937.git.mchehab+huawei@kernel.org>
        <9d205b0e080153af0fbddee06ad0eb23457e1b1b.1610610937.git.mchehab+huawei@kernel.org>
        <da52ef69-753a-7aa8-a2b1-1b5ef48df94e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 10:59:08 -0500 Jon Maloy wrote:
> On 1/14/21 3:04 AM, Mauro Carvalho Chehab wrote:
> > A function has a different name between their prototype
> > and its kernel-doc markup:
> >
> > 	../net/tipc/link.c:2551: warning: expecting prototype for link_reset_stats(). Prototype was for tipc_link_reset_stats() instead
> > 	../net/tipc/node.c:1678: warning: expecting prototype for is the general link level function for message sending(). Prototype was for tipc_node_xmit() instead
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>

Thanks! Applied this one to net, the cfg80211 one does not apply to
net, so I'll leave it to Johannes.
