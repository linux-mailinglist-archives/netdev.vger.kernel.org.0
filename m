Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C53817EE4A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgCJB7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:59:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34754 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCJB7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:59:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0D4D15A0A26C;
        Mon,  9 Mar 2020 18:59:10 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:59:10 -0700 (PDT)
Message-Id: <20200309.185910.831951812430142688.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: Re: [PATCH net] net: mscc: ocelot: properly account for VLAN
 header length when setting MRU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hrjTFiyNFhFL5vK=0ii7+wdER_kCWObMfSf_G_hP0B5rA@mail.gmail.com>
References: <20200309201608.14420-1-olteanv@gmail.com>
        <20200309.175551.444627983233718053.davem@davemloft.net>
        <CA+h21hrjTFiyNFhFL5vK=0ii7+wdER_kCWObMfSf_G_hP0B5rA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:59:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 10 Mar 2020 03:30:26 +0200

> When you merge net into net-next you can use this patch as reference
> for the conflict resolution, since it is going to conflict with
> 69df578c5f4b ("net: mscc: ocelot: eliminate confusion between CPU and
> NPI port") - both rename some variables.

Ok, thanks for letting me know.
