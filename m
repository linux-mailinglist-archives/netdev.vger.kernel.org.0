Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B822E3558E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFEDLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:11:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFEDLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:11:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D7E7150477F8;
        Tue,  4 Jun 2019 20:11:23 -0700 (PDT)
Date:   Tue, 04 Jun 2019 20:11:22 -0700 (PDT)
Message-Id: <20190604.201122.810789004477157679.davem@davemloft.net>
To:     rasmus.villemoes@prevas.dk
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus.Villemoes@prevas.se
Subject: Re: [PATCH net-next v4 00/10] net: dsa: mv88e6xxx: support for
 mv88e6250
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
References: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 20:11:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Tue, 4 Jun 2019 07:34:22 +0000

> This adds support for the mv88e6250 chip. Initially based on the
> mv88e6240, this time around, I've been through each ->ops callback and
> checked that it makes sense, either replacing with a 6250 specific
> variant or dropping it if no equivalent functionality seems to exist
> for the 6250. Along the way, I found a few oddities in the existing
> code, mostly sent as separate patches/questions.
> 
> The one relevant to the 6250 is the ieee_pri_map callback, where the
> existing mv88e6085_g1_ieee_pri_map() is actually wrong for many of the
> existing users. I've put the mv88e6250_g1_ieee_pri_map() patch first
> in case some of the existing chips get switched over to use that and
> it is deemed important enough for -stable.
 ...

Series applied, thanks.
