Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A111D21EB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbgEMWVe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 13 May 2020 18:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730064AbgEMWVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:21:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EEBC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 15:21:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F41DE12118550;
        Wed, 13 May 2020 15:21:33 -0700 (PDT)
Date:   Wed, 13 May 2020 15:21:33 -0700 (PDT)
Message-Id: <20200513.152133.211500623458865365.davem@davemloft.net>
To:     dgcbueu@gmail.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] net: mvneta: speed down the PHY, if WoL used, to save
 energy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <32495177.Bv3dSJjO3Z@tool>
References: <32495177.Bv3dSJjO3Z@tool>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 15:21:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel González Cabanelas <dgcbueu@gmail.com>
Date: Tue, 12 May 2020 19:59:48 +0200

> Some PHYs connected to this ethernet hardware support the WoL feature.
> But when WoL is enabled and the machine is powered off, the PHY remains
> waiting for a magic packet at max speed (i.e. 1Gbps), which is a waste of
> energy.
> 
> Slow down the PHY speed before stopping the ethernet if WoL is enabled,
> and save some energy while the machine is powered off or sleeping.
> 
> Tested using an Armada 370 based board (LS421DE) equipped with a Marvell
> 88E1518 PHY.
> 
> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>

Applied to net-next, thanks.
