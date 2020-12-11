Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C842D6CA0
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732915AbgLKAho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:37:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732869AbgLKAhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 19:37:24 -0500
Date:   Thu, 10 Dec 2020 16:36:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607647003;
        bh=KPVeueNPjivginV5QPbDb2G84Ho/kxGrnhybboVZqyc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=KgVtsVY6aVuW0hfCIyX3NHkb/U6mv736d1M3DLQQg/ybeJlXf2jPC+vjzLMP4EwSC
         Iw2aIlFOhYYf3zfjyNVoD7ntN8ErFDolNQLBuSBZiW7yNB7ryBo5puTh3EzzxBB4ko
         QVtxjb1NYXMXgn8Nli1wq62H6YyWbOYGLN90xVZQeozMtFpEQDcm3/HUTBqhwYaaad
         cSMIu4Gpl0U2V+ZH4jU/vkaPydw5AMKV9NcoPTCE/fnUFtzowbwo6TIJXhyCtBikYU
         Vmq2pQcFiGv23EbQ8+acAOWj4c9l9S75yM6cCJRdecRBXG0gL6bUmYBfBuGB76YGI1
         8eWGWJfLsb9lw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kaber@trash.net>, <edumazet@google.com>,
        <vyasevic@redhat.com>, <alexander.duyck@gmail.com>
Subject: Re: [PATCH iproute2-next v1] iplink macvlan: Added bcqueuelen
 parameter
Message-ID: <20201210163642.28e32aa4@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <6f97161f-68a1-7224-18ac-ce221c7c2c5e@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
        <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <80f814c3-0957-7f65-686c-f5fbb073f65c@paneda.se>
        <6f97161f-68a1-7224-18ac-ce221c7c2c5e@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 17:07:51 +0100 Thomas Karlsson wrote:
> On 2020-11-30 15:23, Thomas Karlsson wrote:
> > This is a follow up patch to iproute2 that allows the user
> > to set and retrieve the added IFLA_MACVLAN_BC_QUEUE_LEN parameter
> > via the bcqueuelen command line argument
> > 
> > 
> > v1 Initial version
> >    Note: This patch first requires that the corresponding
> >    kernel patch in 0c88607c-1b63-e8b5-8a84-14b63e55e8e2@paneda.se
> >    to macvlan is merged to be usable.  
> 
> Just to follow up so this one isn't forgotten. The macvlan patch was merged
> into net-next a week ago, commit d4bff72c8401e6f56194ecf455db70ebc22929e2
> 
> So this patch should be ready for review/incusion I think.
> 
> (Only sending this message since I noticed the patch was archived in patchworks).

Best if you repost it if it got lost in PW. Please make sure to CC David
Ahern who maintainers iproute2-next.
