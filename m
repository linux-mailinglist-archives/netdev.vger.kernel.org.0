Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463971D59CF
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgEOTRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgEOTRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 15:17:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 463C520727;
        Fri, 15 May 2020 19:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589570255;
        bh=iZ1EUjEC+2Y+l5+nXbB4m4VmgBmQIvUqlo2SDOgiVvQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BEqpS0m1TzY7XWxfTcMozdptBCqT+5JvTFX7faUt9QIqh+jUZTidBPK7JCdAYnKJj
         9zBrB9jsStVR7kBXZ/xbCTUzyP008zNFY7GL5zWeWikvRZ8peeZWuc+Zw9FkdGp4J7
         JHZhdGU9iFhHCjOaIfkPiHk8SejKxE+45gutbMzw=
Date:   Fri, 15 May 2020 12:17:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200515121733.4f72842e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515165300.16125-1-ioana.ciornei@nxp.com>
References: <20200515165300.16125-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 19:52:53 +0300 Ioana Ciornei wrote:
> This patch set adds support for Rx traffic classes on DPAA2 Ethernet
> devices.
> 
> The first two patches make the necessary changes so that multiple
> traffic classes are configured and their statistics are displayed in the
> debugfs. The third patch adds a static distribution to said traffic
> classes based on the VLAN PCP field.
> 
> The last patches add support for the congestion group taildrop mechanism
> that allows us to control the number of frames that can accumulate on a
> group of Rx frame queues belonging to the same traffic class.

How is this configured from the user perspective? I looked through the
patches and I see no information on how the input is taken from the
user.
