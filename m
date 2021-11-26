Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D948245F5A9
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhKZULz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:11:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48326 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhKZUJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:09:54 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 15:09:54 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A15FCE2102
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 19:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69607C9305B;
        Fri, 26 Nov 2021 19:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637956637;
        bh=APqdsJKcNP+vf+oeR9IntmhhS/InhlSCPsSkRXS+j2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dcr1aq0Al5zbA9ZsBltrOt5sYZlBaDbpgR5BdXEe8+i4vhONnVmzr3eLeAyJGz6SV
         +qpWtP8ANDDwhHkVRBSIiQ2qLseKsPaw86Dgi6539jirqhZP0nD8C9KfGNCps8u1xo
         kYyCqDyzPJeFZT8FjV1ih4B4uevz4EoAoAVZLnvvJ5dT8AvjZx73SE3GqjMw7g7o3i
         eqbALe+g3CkCf+Z4ep9NCaVFg3C5YZRKZzjYYWVyXNNXw4prZWYAE6DwfwYmrRd8Dh
         /gsX+e/Hc8vk4tn2POJhORlhXskZsYFwaM3sY5eoJGtCj/viPEcH92VxgwV43QYOTD
         uupndBjRQ+XBA==
Date:   Fri, 26 Nov 2021 11:57:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Message-ID: <20211126115716.45951bcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126103726.6f3976a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
        <20211126103726.6f3976a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 10:37:26 -0800 Jakub Kicinski wrote:
> On Fri, 26 Nov 2021 16:42:48 +0100 Holger Brunck wrote:
> > This can be configured from the device tree. Add this property to the
> > documentation accordingly.
> > The eight different values added in the dt-bindings file correspond to
> > the values we can configure on 88E6352, 88E6240 and 88E6176 switches
> > according to the datasheet.
> > 
> > CC: Andrew Lunn <andrew@lunn.ch>
> > CC: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>  
> 
> Not sure why but FWIW your patches did not show up in patchwork on in
> lore. We can see Andrew's review but not the patches themselves:
> 
> https://lore.kernel.org/all/YaEIVQ6gKOSD1Vf%2F@lunn.ch/

Ah, they made it thru now, disregard.
