Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E7455FFB1
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiF2MQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiF2MQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:16:27 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73CE31927;
        Wed, 29 Jun 2022 05:16:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LY0mv4Wyzz4xD8;
        Wed, 29 Jun 2022 22:16:15 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Mark Brown <broonie@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-spi@vger.kernel.org, linux-can@vger.kernel.org,
        Jiri Slaby <jirislaby@kernel.org>,
        chris.packham@alliedtelesis.co.nz,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Paolo Abeni <pabeni@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Dumazet <edumazet@google.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anatolij Gustschin <agust@denx.de>
In-Reply-To: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
References: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 1/4] powerpc/52xx: Remove dead code, i.e. mpc52xx_get_xtal_freq()
Message-Id: <165650492719.3004956.10259665965182865650.b4-ty@ellerman.id.au>
Date:   Wed, 29 Jun 2022 22:15:27 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 May 2022 13:01:44 +0300, Andy Shevchenko wrote:
> It seems mpc52xx_get_xtal_freq() is not used anywhere. Remove dead code.
> 
> 

Patches 1-3 applied to powerpc/next.

[1/4] powerpc/52xx: Remove dead code, i.e. mpc52xx_get_xtal_freq()
      https://git.kernel.org/powerpc/c/6d056b7254f9954522b7bb9947c8779a013d189f
[2/4] powerpc/mpc5xxx: Switch mpc5xxx_get_bus_frequency() to use fwnode
      https://git.kernel.org/powerpc/c/de06fba62af64144aca6f8a8bedbc848d2e5b440
[3/4] powerpc/52xx: Get rid of of_node assignment
      https://git.kernel.org/powerpc/c/00bcb550dc60f73d593d2dbb718c4f521c7d7be8

cheers
