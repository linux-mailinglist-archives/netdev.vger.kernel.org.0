Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A94E33C417
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbhCOR1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235832AbhCOR0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:26:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC3B864E99;
        Mon, 15 Mar 2021 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615829202;
        bh=9smVmP+su4ZGLkf/k8RcQC8ejCDWxblGt97AYa8OAUk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s0y5atD/cu9RchkXkDE3BCo9Qp2ZKSMDojpP7BkOE5/1JSSMmiANMghev8x2WbTA1
         WFATTiZPl6AGPY9talp3n5maL5yO3T1WxIbniH1V9/9msNuiCas5LTo7TXTeDDseW7
         djQZ59RgnCpCGazUg/C5k9MDdod85pzmEzAdzyTWhGfI0N6C0i/bSUgwtfxYvigTrF
         ZXzLU15fJZJLS48lwjIHwuEcSEkE3VIHE336zMLf9BxrC/7I1OP2QqLZINYldSV6t2
         lBujhmFsmIZKOXteRikEmgPDBZqB9YbZnfaAlg56FcAa+l3o+5TbxgDBzBWBMC5Bo6
         Ov7dUBWckSVjw==
Date:   Mon, 15 Mar 2021 10:26:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 0/4] Adding the Sparx5 Serdes driver
Message-ID: <20210315102640.461e473f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f856d877048319cd532602bc430c237f3576f516.camel@microchip.com>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
        <f856d877048319cd532602bc430c237f3576f516.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 16:04:24 +0100 Steen Hegelund wrote:
> Hi Kishon, Vinod, Andrew, Jacub, and David, 
> 
> I just wanted to know if you think that the Generic PHY subsystem might
> not be the right place for this Ethernet SerDes PHY driver after all.
> 
> Originally I chose this subsystem for historic reasons: The
> Microchip/Microsemi Ocelot SerDes driver was added here when it was
> upstreamed.
> On the other hand the Ocelot Serdes can do both PCIe and Ethernet, so
> it might fit the signature of a generic PHY better.

Are you saying this PHY is Ethernet only?

> At the moment the acceptance of the Sparx5 Serdes driver is blocking us
> from adding the Sparx5 SwitchDev driver (to net), so it is really
> important for us to resolve which subsystem the Serdes driver belongs
> to.
> 
> I am very much looking forward to your response.

FWIW even if this is merged via gen phy subsystem we can pull it into
net-next as well to unblock your other work in this dev cycle. You just
need to send the patches as a pull request, based on merge-base between
the gen phy tree and net-next.
