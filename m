Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26D227D1B0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgI2Ope (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728198AbgI2Opd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 10:45:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 480112074F;
        Tue, 29 Sep 2020 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601390733;
        bh=wU7R9R0MTmlBqL5POesNvwXw0JSijeNoaoiScI/KOXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bXKn+rvYD/4Kn2mNaTJrd2x7Z8nvmpu1cNlbgG5rWYRpHDcuMET0xkPvGZkld0qSb
         jDB2puKYbgYze6BK4Xsc+v8aRY9lX41oFfZ5bMS8K6AlWhhah0LvPTTuGCmg8nsaRC
         PQCwF43UY+QFNdEXDfw8aaH1iZFbZSA0CzbuasF8=
Date:   Tue, 29 Sep 2020 07:45:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [RFC PATCH v2 net-next 07/21] net: mscc: ocelot: add
 definitions for VCAP ES0 keys, actions and target
Message-ID: <20200929074530.418d1182@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929101016.3743530-8-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
        <20200929101016.3743530-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 13:10:02 +0300 Vladimir Oltean wrote:
> As a preparation step for the offloading to ES0, let's create the
> infrastructure for talking with this hardware block.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

drivers/net/ethernet/mscc/ocelot_vsc7514.c:778:19: warning: symbol 'vsc7514_vcap_es0_actions' was not declared. Should it be static?
