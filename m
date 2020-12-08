Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5A72D206A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgLHB6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 20:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgLHB6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 20:58:49 -0500
Date:   Mon, 7 Dec 2020 17:58:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607392688;
        bh=+iUIQEC2J2HzyseQUuGLHXitIVa0CN+Kd/BeicPbqZ0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y7dxW5EOH7Xc7sSI89veczrZ3qs1IVvJ1mImNa/lKyA/HceJFVOm7Epzoi+p8qPVG
         BWQppRddrVePNtmANPcsQm8zNW+9kxh6VJwdB4Nk7LD/9s0Y/3bIxJqblgHiFzhu52
         D8BjksUESSe+NvJRvo/zXiI312SWwqhPBgftApayYXwDJ7OeEXo0pNgpLOHLUruLz/
         Y1jybuJ5yzon/ledYFxkr40fwXudo1Y23u4d47cDxnBhFRL7422b/R09OUy+6KFrcs
         /MnvtHD2lz75kvkjJf4L+psLeCzF7/njkhrsE55fKPrZQfyQXcbdM4olbRrLrrHHWa
         eXpAW1LbkJnwg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] dpaa2-mac: Add a missing of_node_put after
 of_device_is_available
Message-ID: <20201207175807.695fba40@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207150457.arjw5geu2k6h2h2u@skbuf>
References: <20201206151339.44306-1-christophe.jaillet@wanadoo.fr>
        <20201207150457.arjw5geu2k6h2h2u@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 15:04:58 +0000 Ioana Ciornei wrote:
> On Sun, Dec 06, 2020 at 04:13:39PM +0100, Christophe JAILLET wrote:
> > Add an 'of_node_put()' call when a tested device node is not available.
> > 
> > Fixes:94ae899b2096 ("dpaa2-mac: add PCS support through the Lynx module")
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>  
> 
> 
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied, thanks!
