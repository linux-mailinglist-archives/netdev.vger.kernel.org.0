Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8895740B4A7
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhINQbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 12:31:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhINQbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 12:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=njN+e+7M4hzi6WYHOVWZV17tMFaFf10fm8CiV1MfHR4=; b=LpUCT+oREkyCgJaMiMhbSiuNxB
        RbVjjL0nAA+jVCLmp7CkAUWZh48/SXj+Q2uCvwRJ7T4E1cz4nd1Ct8vjNFDsCbSXHKfdpxOYal9fK
        wlhXOyG7C260yoziBFTBxy/GzKUNZhGL03g2gIUi/tR68xLEhQ5yfd2eqvr91wlRDFa4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQBJj-006cin-13; Tue, 14 Sep 2021 18:29:55 +0200
Date:   Tue, 14 Sep 2021 18:29:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Message-ID: <YUDOA9SKfCliXlTx@lunn.ch>
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
 <20210912213855.kxoyfqdyxktax6d3@skbuf>
 <YT+dL1R/DTVBWQ7D@lunn.ch>
 <20210914120617.iaqaukal3riridew@skbuf>
 <YUCytc0+ChhcdOo+@lunn.ch>
 <20210914151525.gg2ifaqqxrmytaxm@skbuf>
 <CANr-f5zNnywpNxMAmNDv60otqXo2oGKiQpT2BL3VraOZftGc4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5zNnywpNxMAmNDv60otqXo2oGKiQpT2BL3VraOZftGc4w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I submitted it, but Michal Simek argumented that dts files of FPGA
> logic shall not be part of mainline. I suggested that at least one
> reference platform for every FPGA based IP core should be allowed,
> but he said that no one is able to test it.  So it seems that you
> will never see any dts file which contains FPGA logic in mainline. I
> will try to submit it again if anyone will support me?

My opinion: If there is a real product out in the field using this,
the DT for the product can be in mainline.

Reference Design Kits for ASICs are well supported in mainline. So the
question is, is an FPGA sufficiently different to an ASIC that is
should be treated differently? Do you have an off the shelf platform
or something custom? How easy is it to get the platform which is used
as an RDK? Can you make a bitstream available for anybody to use?

	Andrew
