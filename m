Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F3164889
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBSP13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:27:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53904 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgBSP12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 10:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LgL2DzEgrX9RO/F/GCD9K7RxSQzZA2rhMCjy6pPUGc4=; b=TMMyIzDd90A5BgjPpsTeIdCi0J
        K4PZst1cBcwpRlDEwH9dXOAsvKoGaxuPROxYfX+ZRHCXz+a03aO/5yCw3YG74pc3gHwMGaqhI8x6D
        mKb+WlKzaaoFuROK23nBwU7B1YaeUCL3rJJMuose3KBFpqTEXYLAWYa3c7fOTcOhKUBc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j4RG0-00011Z-3p; Wed, 19 Feb 2020 16:27:24 +0100
Date:   Wed, 19 Feb 2020 16:27:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next/devicetree 3/5] dt-bindings: net: dsa:
 ocelot: document the vsc9959 core
Message-ID: <20200219152724.GC3281@lunn.ch>
References: <20200219151259.14273-1-olteanv@gmail.com>
 <20200219151259.14273-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219151259.14273-4-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 05:12:57PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch adds the required documentation for the embedded L2 switch
> inside the NXP LS1028A chip.
> 
> I've submitted it in the legacy format instead of yaml schema, because
> DSA itself has not yet been converted to yaml, and this driver defines
> no custom bindings.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
