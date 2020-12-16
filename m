Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079832DC67B
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgLPS31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730768AbgLPS31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 13:29:27 -0500
Date:   Wed, 16 Dec 2020 09:59:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608141567;
        bh=z59wH0j+i6cCBxlaJvxQ1SPOyZU0tynGIPhs6wea738=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jCxv5f/B6dPSyFqHelcfXjyELKvrXSq1dr+If9X6LyDS8WR6bZDv4fR9hJcGyMn1Y
         es8ENDqtJr+6bVDg0kNbTfvKjr7IxoVo1d0i9Ik2i6EiV9+35kzT+1QqFbI6fZrPOU
         yW1D4cCjYSTKcmrVrJG5NsUP+sA9hI+5xSANYzWI7vKd4pYrFk/88CxtuZhUAGVmyh
         RyzJH+9BPMCJnggYmn53Cc4JUPbZ8Ni3s0hEIh5ltXWiWXtXFoPJYfrvCf9ht9myqC
         evmnyU3/GUN49paDjuwx03a/lqif0qZFErgP681Wf1F1w40WbXxRRBkYzmYEZHGXOM
         TPz6bxg2hoPdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <davem@davemloft.net>
Subject: Re: [PATCHv4 net-next] octeontx2-pf: Add RSS multi group support
Message-ID: <20201216095924.278777df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215041156.4504-1-gakula@marvell.com>
References: <20201215041156.4504-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 09:41:56 +0530 Geetha sowjanya wrote:
> Hardware supports 8 RSS groups per interface. Currently we are using
> only group '0'. This patch allows user to create new RSS groups/contexts
> and use the same as destination for flow steering rules.
> 
> usage:
> To steer the traffic to RQ 2,3
> 
> ethtool -X eth0 weight 0 0 1 1 context new
> (It will print the allocated context id number)
> New RSS context is 1
> 
> ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1
> 
> To delete the context
> ethtool -X eth0 context 1 delete
> 
> When an RSS context is removed, the active classification
> rules using this context are also removed.

This came in right as we were sending the PR for 5.11 to Linus, 
and it didn't make it to the current release. Please repost in 
two weeks when the merge window is over. Thanks!
