Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE403F1FBE
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 20:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhHSSQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 14:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234379AbhHSSQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 14:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0E3560E76;
        Thu, 19 Aug 2021 18:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629396959;
        bh=zwkEErFNObocNGdNcXBf9jzd9+Gw3asn8HaLxA0FRh8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R916WCQZLCPNDz2MHU+AJy2B4uhIxkpsjKfZYSIB7GKQEOXqgvWf6wG8brFeYRcK8
         C3NV+ljb8857htBe39lhacE3ItH7AoEsG9mZJUrUeELdlcc5ji67Hhy9Ns10OvSckj
         bWIyq6NMYn9JCNTeJ6rm4h9SFLKeT1/41n1xrkcddONzf/eZ22mzUYP52cagY2SZNq
         t9LamgAdqwgc9iYffW9YOFQlJ5CEo8qC0xMiQCwbFzwNFB5t3U/sWxDXlNDtJXnZtM
         PSjof2TWpMKcvazLi9UpUebrgxEbFCBVzIkMQ/HoNkb7vbIa/31TyBoOkuoMsV0ftf
         850feOXkd64Qw==
Date:   Thu, 19 Aug 2021 11:15:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: dpaa2-switch: disable the control interface on
 error path
Message-ID: <20210819111539.71d76241@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819152947.cnx3vyueud6rfupn@skbuf>
References: <20210819141755.1931423-1-vladimir.oltean@nxp.com>
        <20210819152947.cnx3vyueud6rfupn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 15:29:49 +0000 Ioana Ciornei wrote:
> On Thu, Aug 19, 2021 at 05:17:55PM +0300, Vladimir Oltean wrote:
> > Currently dpaa2_switch_takedown has a funny name and does not do the
> > opposite of dpaa2_switch_init, which makes probing fail when we need to
> > handle an -EPROBE_DEFER.

> > [E, ctrl_if_set_pools:2211, DPMNG]  ctrl_if must be disabled
> > 
> > So make dpaa2_switch_takedown do the opposite of dpaa2_switch_init (in
> > reasonable limits, no reason to change STP state, re-add VLANs etc), and
> > rename it to something more conventional, like dpaa2_switch_teardown.
> > 
> > Fixes: 613c0a5810b7 ("staging: dpaa2-switch: enable the control interface")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> 
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied, thanks!
