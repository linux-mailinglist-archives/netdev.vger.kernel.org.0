Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC146D915
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbhLHRDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:03:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234612AbhLHRDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 12:03:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gerSWqQqzt7MQ8zUzD7fNyZU4DWu0FKxHBXy3uTIVKU=; b=HFyEegVTt/BI2BJvWZKXSu2ILh
        1sz272Jcbeb8iuxh20GPNFB+HPXZr0JCcMuYcmDddgg25ICd9PuUdeUjiOjt5B4DElE4CKH8iRFI7
        J6qIl+5nrTbkhuLcujLUszzYInwVqdJe9T6yiEPQWQjwjgXu+rCxzMz6VGg+UYWCbmt8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv0IX-00Fu2h-CN; Wed, 08 Dec 2021 18:00:05 +0100
Date:   Wed, 8 Dec 2021 18:00:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <YbDkldWhZNDRkZDO@lunn.ch>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
 <20211207190730.3076-2-holger.brunck@hitachienergy.com>
 <20211207202733.56a0cf15@thinkpad>
 <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208162852.4d7361af@thinkpad>
 <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208171720.6a297011@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208171720.6a297011@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Or maybe two properties:
>   serdes-tx-amplitude-millivolt = <700 1000 1100>;
>   serdes-tx-amplitude-modes = "sgmii", "2500base-x", "10gbase-r";

I think this is good. But you are missing the DT email list from Cc:
You need Robs input.

We probably should list the accepted mode values somehow. I don't know
if we can reference ethernet-controller.yaml : phy-connection-type, or
if we need a new list. This gets interesting when PCIe and USB needs
to use this property, what names are used, and if it is possible to
combine two different lists?

	Andrew
