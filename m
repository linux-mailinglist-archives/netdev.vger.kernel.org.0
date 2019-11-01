Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D158FECA12
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKAU7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:59:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfKAU7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 16:59:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6LFUYdtd/z6Wr9IKwpWqo+i0nhUSa4STX4GMDfZLnVM=; b=TwU2swBh1LPX6w8Fg51nF5S1eA
        1MinZbzKnGyCGHxdSUL5v3Fq/GrMEKqWUrFsSzrTyG9nAlTfxzW9VwMix2U9wLtmASS7uEzwNUnWe
        fVUnOb2pzQ1M4dunPcQNjwhBw6MtqSKZVsmdfv8zoFTWlv3IvYY3iMyGlsr45RfkuYmc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iQe1E-0000NN-KN; Fri, 01 Nov 2019 21:59:40 +0100
Date:   Fri, 1 Nov 2019 21:59:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 06/12] net: ethernet: ti: introduce cpsw
 switchdev based driver part 1 - dual-emac
Message-ID: <20191101205940.GF31534@lunn.ch>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-7-grygorii.strashko@ti.com>
 <20191029122422.GL15259@lunn.ch>
 <d87c72e1-cb91-04a2-c881-0d8eec4671e2@ti.com>
 <20191101203913.GD31534@lunn.ch>
 <8f3eb934-7dcd-b43a-de96-6a864ef67c92@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f3eb934-7dcd-b43a-de96-6a864ef67c92@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > And please you the standard file naming and location,
> > Documentation/networking/devlink-params-foo.txt
> Ok. I will.
> But I'd like to clarify:
> - drivers documentation placed in ./Documentation/networking/device_drivers/ti/
> so could you confirm pls, that you want me to add devlink-params documentation in separate file
> and palace it in ./Documentation/networking/ folder directly?

Hi Grygorii

That appears to be the expected place for devlink documentation. You
can link to it from your document in the ti subdirectory.

    Andrew
