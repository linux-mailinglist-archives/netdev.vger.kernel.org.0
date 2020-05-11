Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1721CDA58
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgEKMm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:42:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbgEKMm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 08:42:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sinDIPAGMkTelQEyzHkAx61jqUBS8OA/yV4gH5A7mjA=; b=5QYScKwbb9/nzSLTIJzQ9yAeP8
        4sCsF1CWxK4bj68mt5Hw5cbVCxQ4SJBdqfjy0mUz10lZHIxuV4Xv/VAbvab37cK/HEEme4mWyQO0t
        55rj0zFMh8wPY+aQhCIvHDgMQWa9FqEniWfgiGzQz4606GsqomRRoXFmQhPPYzSOTpDE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jY7ld-001qpC-BU; Mon, 11 May 2020 14:42:45 +0200
Date:   Mon, 11 May 2020 14:42:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200511124245.GA409897@lunn.ch>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200511111134.GD25096@plvision.eu>
 <20200511112905.GH2245@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511112905.GH2245@nanopsycho>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >I understand this is not good, but currently this is simple solution to
> >handle base MAC configuration for different boards which has this PP,
> >otherwise it needs to by supported by platform drivers. Is there some
> >generic way to handle this ?
> 
> If the HW is not capable holding the mac, I think that you can have it
> in platform data. The usual way for such HW is to generate random mac.
> module parameter is definitelly a no-go.

And i already suggested it should be a device tree property.

    Andrew
