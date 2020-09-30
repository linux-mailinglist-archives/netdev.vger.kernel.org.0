Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8337427F415
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgI3VUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgI3VUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:20:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36689C061755;
        Wed, 30 Sep 2020 14:20:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8CB1013C6700A;
        Wed, 30 Sep 2020 14:03:12 -0700 (PDT)
Date:   Wed, 30 Sep 2020 14:19:59 -0700 (PDT)
Message-Id: <20200930.141959.1549354522227525326.davem@davemloft.net>
To:     geert@linux-m68k.org
Cc:     kuba@kernel.org, robh+dt@kernel.org, sergei.shtylyov@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, linux@rempel-privat.de,
        philippe.schenker@toradex.com, hkallweit1@gmail.com,
        dmurphy@ti.com, kazuya.mizuguchi.ks@renesas.com,
        wsa+renesas@sang-engineering.com, magnus.damm@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/5] net/ravb: Add support for explicit
 internal clock delay configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdU2k5MmUe2_g7a9268XG2=9phiWoaSTeQ9ZbxoAs3QFfw@mail.gmail.com>
References: <20200917135707.12563-1-geert+renesas@glider.be>
        <CAMuHMdU2k5MmUe2_g7a9268XG2=9phiWoaSTeQ9ZbxoAs3QFfw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:03:13 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 30 Sep 2020 14:21:30 +0200

> Is there anything still blocking this series?

If it's not active in networking patchwork, it needs to be resubmitted
or similar.

