Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E4741F750
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355772AbhJAWNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230296AbhJAWNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 318B561A8E;
        Fri,  1 Oct 2021 22:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633126276;
        bh=dq7gMoed+Q5xgZcFdyOjR1Sz72I2BtojtXMRJmJHLQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jG80FvHJ2BwbJFPfE7qGYcvsp4zWBixxT5CM0tL/JUJ6lUiLQShyXIHzgmt0fclny
         bGGtq1qlOpNawR7Ac7BeW1z8sm0vbzAei5aFh8ltHXH29nXKJvJULoHO7fuFhtxo+t
         JF08Xss9vyA5XMEN6ZsVlOD3aJp85uvotH1lnSBOAIrKIJ6lJ7hr83qgv5MxAvX5Hu
         jxMCMux1yUOej2DtZO8n3NK6SyuuiVRWYLJv1lXhWyMFrlTB2a0BkWyLeGPlBSjt+x
         bLqBcyTCzjwlDIXYW1Vf8LBh2BkVtKTUWlCkwwseoV0R+2Q0ACQs4DDHCQxjNGPUp9
         L8Na8EXIHlb/A==
Date:   Fri, 1 Oct 2021 15:11:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, vladimir.oltean@nxp.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, po.liu@nxp.com, leoyang.li@nxp.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com
Subject: Re: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on
 vsc9959
Message-ID: <20211001151115.5f583f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 15:59:40 +0800 Xiaoliang Yang wrote:
> VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
> This patch series add PSFP support on tc flower offload of ocelot
> driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add gate
> and police set to support PSFP in VSC9959 driver.

Vladimir, any comments? 
