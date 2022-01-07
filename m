Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5B3486F54
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 02:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344952AbiAGBAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 20:00:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47148 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiAGBAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 20:00:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A17961E9B;
        Fri,  7 Jan 2022 01:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50683C36AE3;
        Fri,  7 Jan 2022 01:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517220;
        bh=dWaphkxeosDnzOLIsXfGqQdCs0GB28cQL553hwjSiig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ThklsKuo/uGCPpetV9gMpmKJrCNmeREMHr/2WI1G985/9PkmZSb0RduCS026APTmQ
         dmum1ndOVGJxFIwzeIPoIoPg3HXWpmrWNALqwtzCtMnvlxQKLjV4aD0wdGClazr7HU
         dMTFXgjr2uIL0Hcm6te3Qom1mmhMOORI2lJ1iRkNcm3AvVvQNeVjqiJZf55a1d1/Wz
         hC+yAGRsK6mT91vVIGj3ZGR25XnJRRtKWQeWFW8z+mOzYKWUeuHH52jycGKSR182NM
         NMQ7YJhwD3GF6VyvqSeFx4gGPip6+IQuiu8BF4hcwPsR9HhM2fupq+NthIIs90YI64
         fnLr59fpDjF5Q==
Date:   Thu, 6 Jan 2022 17:00:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
Message-ID: <20220106170019.730f45e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-13-miquel.raynal@bootlin.com>
        <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
        <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
        <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
        <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
        <20220104191802.2323e44a@xps13>
        <CAB_54W5quZz8rVrbdx+cotTRZZpJ4ouRDZkxeW6S1L775Si=cw@mail.gmail.com>
        <20220105215551.1693eba4@xps13>
        <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jan 2022 19:38:12 -0500 Alexander Aring wrote:
> > Also, just for the record,
> > - should I keep copying the netdev list for v2?  
> 
> yes, why not.

On the question of lists copied it may make sense to CC linux-wireless@
in case they have some precedent to share, and drop linux-kernel@.
