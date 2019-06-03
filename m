Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5213397F
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 22:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfFCUEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 16:04:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfFCUEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 16:04:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D256714D3AC68;
        Mon,  3 Jun 2019 13:04:20 -0700 (PDT)
Date:   Mon, 03 Jun 2019 13:04:20 -0700 (PDT)
Message-Id: <20190603.130420.1439611131492320104.davem@davemloft.net>
To:     rasmus.villemoes@prevas.dk
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus.Villemoes@prevas.se
Subject: Re: [PATCH net-next v3 00/10] net: dsa: mv88e6xxx: support for
 mv88e6250
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 13:04:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Mon, 3 Jun 2019 14:42:11 +0000

> This adds support for the mv88e6250 chip.

Please make the rearrangements requested by Andrew in patch #1 and
respin.  It looks otherwise ready to go to me :-)

