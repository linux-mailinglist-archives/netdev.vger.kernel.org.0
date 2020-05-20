Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E44D1DBDF8
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgETT11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:27:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgETT10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 15:27:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4rHhSwlt0coVHMURe6/q1fSVBHKApGrHanOZroyRRls=; b=yJq3Ul7dmw24UfEWAAp7TeKPCO
        EELwjXzfv5c4o0CwVxXIej+jkdnnHCqT+KiLG1fVR2qCgWRhVOvlJWpVZclLWBykY9TcP+pM09qKa
        y6+ae1+zt8pEBsEiywLrG1G8Und2InNCz8uiuD2S8OU7QN8vGY9aC7OVG+/czQ6Lr+gM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbUN5-002pxx-0p; Wed, 20 May 2020 21:27:19 +0200
Date:   Wed, 20 May 2020 21:27:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
Message-ID: <20200520192719.GK652285@lunn.ch>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com>
 <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
 <20200520164313.GI652285@lunn.ch>
 <d5d46c21-0afa-0c51-9baf-4f99de94bbd5@ti.com>
 <41101897-5b29-4a9d-0c14-9b8080089850@gmail.com>
 <7e117c01-fa6e-45f3-05b7-4efe7a3c1943@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e117c01-fa6e-45f3-05b7-4efe7a3c1943@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan

> UGH I think I just got volunteered to do make them common.

There is code you can copy from PHY drivers. :-)

What would be kind of nice is if the validate was in the core as
well. Pass a list of possible delays in pS, and it will do a
phydev_err() if what is in DT does not match one of the listed
delays. Take a look around at what current drivers do and see if you
can find a nice abstraction which will work for a few drivers. We
cannot easily convert existing drivers without breaking DT, but a
design which works in theory for what we currently have has a good
chance of working for any new PHY driver.

     Andrew
