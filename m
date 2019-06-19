Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B484BB69
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfFSO0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:26:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfFSO0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:26:21 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC535152366DD;
        Wed, 19 Jun 2019 07:26:20 -0700 (PDT)
Date:   Wed, 19 Jun 2019 10:26:19 -0400 (EDT)
Message-Id: <20190619.102619.618962498575895795.davem@davemloft.net>
To:     rasmus.villemoes@prevas.dk
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Rasmus.Villemoes@prevas.se, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix shift of FID bits in
 mv88e6250_g1_vtu_loadpurge()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619100224.11848-1-rasmus.villemoes@prevas.dk>
References: <20190619100224.11848-1-rasmus.villemoes@prevas.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 07:26:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Wed, 19 Jun 2019 10:02:38 +0000

> The comment is correct, but the code ends up moving the bits four
> places too far, into the VTUOp field.
> 
> Fixes: bec8e5725281 (net: dsa: mv88e6xxx: implement vtu_getnext and vtu_loadpurge for mv88e6250)
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Also applied, thank you.
