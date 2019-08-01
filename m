Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495FE7D40F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfHADtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:49:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfHADts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PCDCXPclZrwxUwVB2c1/+btvEFjLvl7BH9rUBUTKiAU=; b=43DuNY+pWH5AkPKI3hZaLtmM2U
        x6RirTgfV4Xge3j5URn48cNp0djrarhSL5zqZAbwGguqU4QXejlwmWjJJId4nbUASuZ1jtL7qA4oS
        L9b5XMeKTJsyjWcdA8EIJg6FCciYHmRS7CGu909sVJ0d/NSm4apIltL4eXgqXjG3YePM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ht266-0001Ic-HX; Thu, 01 Aug 2019 05:49:46 +0200
Date:   Thu, 1 Aug 2019 05:49:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH net-next v2 6/6] net: dsa: mv88e6xxx: add PTP support for
 MV88E6250 family
Message-ID: <20190801034946.GF2713@lunn.ch>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
 <20190731082351.3157-7-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731082351.3157-7-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 10:23:51AM +0200, Hubert Feurstein wrote:
> This adds PTP support for the MV88E6250 family.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
