Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDDE9A4C1
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 03:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387676AbfHWBJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 21:09:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53622 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730545AbfHWBJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 21:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bubYkOWQv/TmjmevXp07B1YxRSMrPurV5Qv8qeYJzMg=; b=PxaSz34QDnYHyaA6CFTIHBtfGH
        ow2ULEN3il0uWeBGbbnScQcUzT2s+cnFmmS8jlf2UaTXTGryJXIkg7tMZ8VqYXuNldBrgggMhycEG
        EXmpf5NKePxcDTTu5kP1ATysD0t/uYER73kH4IW5Z/eNsXf+9OwJ4dZnXOMZ8huSwcM4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0y52-0000ap-FE; Fri, 23 Aug 2019 03:09:28 +0200
Date:   Fri, 23 Aug 2019 03:09:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     opensource@vdorst.com, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, john@phrozen.org,
        linux-mips@vger.kernel.org, frank-w@public-files.de
Subject: Re: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK and
 add support for port 5
Message-ID: <20190823010928.GK13020@lunn.ch>
References: <20190821144547.15113-1-opensource@vdorst.com>
 <20190822.162047.1140525762795777800.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190822.162047.1140525762795777800.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 04:20:47PM -0700, David Miller wrote:
> From: René van Dorst <opensource@vdorst.com>
> Date: Wed, 21 Aug 2019 16:45:44 +0200
> 
> > 1. net: dsa: mt7530: Convert to PHYLINK API
> >    This patch converts mt7530 to PHYLINK API.
> > 2. dt-bindings: net: dsa: mt7530: Add support for port 5
> > 3. net: dsa: mt7530: Add support for port 5
> >    These 2 patches adding support for port 5 of the switch.
> > 
> > v1->v2:
> >  * Mostly phylink improvements after review.
> > rfc -> v1:
> >  * Mostly phylink improvements after review.
> >  * Drop phy isolation patches. Adds no value for now.
> 
> This definitely needs some review before I'll apply it.

That would be Russell.

We should try to improve MAINTAINER so that Russell King gets picked
by the get_maintainer script.

   Andrew
