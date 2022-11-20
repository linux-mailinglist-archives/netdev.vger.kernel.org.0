Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105656313E4
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 13:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKTM0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 07:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKTM0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 07:26:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B5A29CB1;
        Sun, 20 Nov 2022 04:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE87B60BD4;
        Sun, 20 Nov 2022 12:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DBBC433C1;
        Sun, 20 Nov 2022 12:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668947167;
        bh=3F+SFAJjn2MK8gC4K4VJE2JRGmOrBJQxqEiSJ+913xw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zm8gRFF1Y8fwjiyd+tZ8Ib14lxvua2J/nkWZ+oSAOy6IbnbjoqTKTjqZRoqmB4PTu
         xWGpZlEQMKtmhcbcuAampibsrW+u/4ZqV+ySCaGbKj3LGYsOY7+B/VkdqPpc7UPJXG
         g5SwS7MiqNXOefDwHS9SwNauWAUB2+wLuzTSBEoXFXrFEFG/y2gRkFDZw+JDAaisDh
         XRtmpklWqzohIUxAr3NGCneMAEMugjK+rAPRz3l3vvF8tEk96f6oT4ALrCS9Qd7Dre
         SOE5tmt8BpN1fvrW41nFwa/DD2vxcz1rnADS35/o7Cfi8CyMQ+TxsuPNjSQxe/pJAw
         OuypwI+RZQjWw==
Date:   Sun, 20 Nov 2022 12:26:00 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Alexander Lobakin <alobakin@pm.me>, linux-kbuild@vger.kernel.org,
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several
 modules
Message-ID: <Y3oc2B6y0TB51+/j@spud>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <Y3oWYhw9VZOANneu@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3oWYhw9VZOANneu@sirena.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 11:58:26AM +0000, Mark Brown wrote:
> On Sat, Nov 19, 2022 at 11:03:57PM +0000, Alexander Lobakin wrote:
> 
> Your mails appear to be encrypted which isn't helping with
> review...

https://lore.kernel.org/all/20221119225650.1044591-1-alobakin@pm.me/

Looks un-encrypted on lore. pm.me looks to be a protonmail domain - I
had issues with protonmail where it picked up Maz's key via Web Key
Directory. "Kernel.org publishes the WKD for all developers who have
kernel.org accounts" & unfortunately proton doesn't (or didn't) offer a
way to disable this. If someone's key is available it gets used & proton
told me, IIRC, that not having a way to disable this is a privacy
feature.

Unfortunately, my workaround was leaving protonmail.

