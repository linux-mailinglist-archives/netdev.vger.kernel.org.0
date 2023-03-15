Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D296BA719
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCOFaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjCOFaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:30:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4239E193F1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 22:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3A7B61AED
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C162CC433EF;
        Wed, 15 Mar 2023 05:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678858103;
        bh=JfF7VMBsazBe8o56N1unEvIuizknskaEl0txRG2UmA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H1/6zYFuHoDpvVgV+T25KRVQf7O6Wf9NDM0Bz4NR/b5WPXPbcoo4DYhm9vILrB+CN
         MZBxA1ckteVnZPYmClRgtXNFmv/g1RIehhOMjcXuFefWTGjPEdWiky+0lhAyvK4Gc/
         e2bJJAl0ph87+5/frsgtVF9efuZmqD0zxBhFDeCjJjDD13IqSbwH4A5Y011iUj5eKn
         0AI7oi/8qO1gn0rxSVKqQKg6iO5sq6OzOx3oStLlaFwW20dI8MzXp/X4+9U9csz2Gx
         jvTgmwvnIShosS88s1ZoylKA+4flRDWoKYe0NR3I1m/qheq1kJSJcMB2IyWectFDmb
         mWFs4W/5YUPsQ==
Date:   Tue, 14 Mar 2023 22:28:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, kernel@pengutronix.de
Subject: Re: [PATCH net-next 4/9] net: fec: Convert to platform remove
 callback returning void
Message-ID: <20230314222821.0988983c@kernel.org>
In-Reply-To: <20230314221508.lhumfl3y3qrybqj2@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
        <20230313103653.2753139-5-u.kleine-koenig@pengutronix.de>
        <20230314221508.lhumfl3y3qrybqj2@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 23:15:08 +0100 Uwe Kleine-K=C3=B6nig wrote:
> FTR: This patch depends on patch 2 of this series which has issues. So
> please drop this patch, too. Taking the other 7 patches should be fine
> (unless some more issues are discovered of course).

Could you post a v2 with just the right patches in it?
Would be quicker for us to handle and we're drowning in patches ATM :(
