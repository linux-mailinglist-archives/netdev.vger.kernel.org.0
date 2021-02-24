Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2AC3247B0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhBXX6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:58:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56696 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234118AbhBXX6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:58:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lF429-008JvQ-S7; Thu, 25 Feb 2021 00:57:33 +0100
Date:   Thu, 25 Feb 2021 00:57:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 04/12] Documentation: networking: dsa:
 remove references to switchdev prepare/commit
Message-ID: <YDbn7fJgzlC/jiXj@lunn.ch>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-5-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 11:33:47PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After the recent series containing commit bae33f2b5afe ("net: switchdev:
> remove the transaction structure from port attributes"), there aren't
> prepare/commit transactional phases anymore in most of the switchdev
> objects/attributes, and as a result, there aren't any in the DSA driver
> API either. So remove this piece.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
