Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0707632D47
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiKUTum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiKUTuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:50:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4B9D5A2E;
        Mon, 21 Nov 2022 11:50:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAFDDB815E0;
        Mon, 21 Nov 2022 19:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92931C433C1;
        Mon, 21 Nov 2022 19:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669060236;
        bh=QKobMZ1J3q+8zOnwrL3k1c3KPx7Ojyo1PDazC7Em/to=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SHes+vxwS659gFfBWwaqXZPSbiRkkrN/bA+6vJRz0eIKx923+vUM8MedFwHED34Lw
         bqVxReLBFEDtnBV1wN/R2u1V1KPstL2vdPWa4SYv9W76GJg1ylsI2B7pCz10n7e+t4
         t5BugGchbvRhoceR4B90Nhp5FpvlZVVPH7rzLnzHylrgORb6UfXjp7sWVobVpp7Icc
         QkOdxQQM+x0aXsSpUstTO+2e9SIs7wg+kRgVYIMBj0h2HExYjRNnUcwzKlQLrF0hs4
         Xt6ugGeCHY8JfV1REAhgG3MVyWv9aPIavnpLu+GlG0QK8y+VkhsnS6zXIz/8gVk27A
         s88r0ji6xvYxg==
Date:   Mon, 21 Nov 2022 11:50:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several
 modules
Message-ID: <20221121115034.03fe007e@kernel.org>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Nov 2022 23:03:57 +0000 Alexander Lobakin wrote:
> Subject: [PATCH 00/18] treewide: fix object files shared between several modules

Could you repost the networking changes separately in v2?
I'm not seeing any reason why this would have to be a treewide
series when merging.

> monotonic

monotonous, unless you mean steady progress ;)
