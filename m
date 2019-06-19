Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814B84BB61
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbfFSOYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:24:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfFSOYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:24:23 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F8A2152366BE;
        Wed, 19 Jun 2019 07:24:22 -0700 (PDT)
Date:   Wed, 19 Jun 2019 10:24:21 -0400 (EDT)
Message-Id: <20190619.102421.1429386927501157217.davem@davemloft.net>
To:     rasmus.villemoes@prevas.dk
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Rasmus.Villemoes@prevas.se, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix shift of FID bits in
 mv88e6185_g1_vtu_loadpurge()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619100203.11749-1-rasmus.villemoes@prevas.dk>
References: <20190619100203.11749-1-rasmus.villemoes@prevas.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 07:24:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Wed, 19 Jun 2019 10:02:13 +0000

> The comment is correct, but the code ends up moving the bits four
> places too far, into the VTUOp field.
> 
> Fixes: 11ea809f1a74 (net: dsa: mv88e6xxx: support 256 databases)
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Applied and queued up for -stable.
