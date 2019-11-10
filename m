Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B113FF6AA7
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKJSBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:01:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbfKJSBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:01:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Q1XQBYPAKa+ogzXzPzu08daJZ46bjupYqXjmDlfiCX0=; b=mtjvNxADPtrPONH+Y6CPSjy3x3
        9W2Fg3/ONIFCOIu6mFmiCvk9JpvzoOCC1Ns0fVgTSqCnD9diJZi76K7Fmj76b9kLIHe6QtXS9XFO0
        frPgyIdswUF1BYZWwslirpi77L1+u1SIknnJ4a0tD74svqS+RwjvIebMNHxwUagr5qYo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrWQ-0007Ck-6u; Sun, 10 Nov 2019 19:01:10 +0100
Date:   Sun, 10 Nov 2019 19:01:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/17] net: sfp: rename sfp_sm_ins_next() as
 sfp_sm_mod_next()
Message-ID: <20191110180110.GO25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnrD-00059f-Iz@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnrD-00059f-Iz@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:23PM +0000, Russell King wrote:
> sfp_sm_ins_next() modifies the module state machine.  Change it's name
> to reflect this.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

