Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4832713DBEC
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgAPNaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:30:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40984 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgAPNaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:30:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g1qwtKIRjlBajTodzOst5ddyTTUcuYWbTRPXsMESids=; b=2ECly9xqL7ZjMne7Gw+M+ysy1d
        /7HZ35Le8voRmEzt+T0tpSwyIwWvia+UREroW3r0qd9euHylc6hvW07tf9i1WAnOMBjG9az1NP8+h
        jAUuZ5HNpRekdP7lp0ZyAEqbepMWpqGADpnWeBI124VKpmHIdwcsCWDO7eOGAMs9OOrg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1is5EA-00054x-2R; Thu, 16 Jan 2020 14:30:26 +0100
Date:   Thu, 16 Jan 2020 14:30:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH 1/4] net: phy: adin: const-ify static data
Message-ID: <20200116133026.GB19046@lunn.ch>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
 <20200116091454.16032-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116091454.16032-2-alexandru.ardelean@analog.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 11:14:51AM +0200, Alexandru Ardelean wrote:
> Some bits of static data should have been made const from the start.
> This change adds the const qualifier where appropriate.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
