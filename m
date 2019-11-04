Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC4DEF160
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 00:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbfKDXsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 18:48:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729595AbfKDXsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 18:48:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/QGn7N16//BUsqDchImHmJtNRiNEh4o8eOLdsJJE0Eo=; b=v+aYsrV65OIpyN891D2NfrtGmf
        e6bMrfMvEpRAYJ8IjCmibAZEJNlvlT2xWshDGKBledWLDV2RBLdgbdxqasrJtRWLP4/Lzgy0lJrIY
        gi9nJXUpOEulObAq2gE42klvgzP+ScSpHftmhJRfCrRHP821o00w/yj61SMw204DENng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRm4v-00079d-7w; Tue, 05 Nov 2019 00:48:09 +0100
Date:   Tue, 5 Nov 2019 00:48:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: bcm_sf2: Add support for
 optional reset controller line
Message-ID: <20191104234809.GB27339@lunn.ch>
References: <20191104215139.17047-1-f.fainelli@gmail.com>
 <20191104215139.17047-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104215139.17047-3-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 01:51:39PM -0800, Florian Fainelli wrote:
> Grab an optional and exclusive reset controller line for the switch and
> manage it during probe/remove functions accordingly. For 7278 devices we
> change bcm_sf2_sw_rst() to use the reset controller line since the
> WATCHDOG_CTRL register does not reset the switch contrary to stated
> documentation.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
