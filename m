Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C292B59BA04
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiHVHIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 03:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiHVHIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 03:08:36 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9765F6579;
        Mon, 22 Aug 2022 00:08:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 1A65680F9;
        Mon, 22 Aug 2022 07:01:29 +0000 (UTC)
Date:   Mon, 22 Aug 2022 10:08:32 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Peng Fan <peng.fan@nxp.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Doug Anderson <dianders@chromium.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux.dev,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Bring back driver_deferred_probe_check_state()
 for now
Message-ID: <YwMrcH6oix8b/O1v@atomide.com>
References: <20220819221616.2107893-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819221616.2107893-1-saravanak@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Saravana Kannan <saravanak@google.com> [220819 22:09]:
> A bunch of issues have been reported in the original series[1] that removed
> driver_deferred_probe_check_state(). While most of the issues have been
> fixed in a new series that improved fw_devlink [2], there are still a few
> unresolved issues I need to address.
> 
> So let's bring back driver_deferred_probe_check_state() until the other
> issues are resolved.
> 
> Greg,
> 
> Can we get this into 6.0-rcX please?

Yes please.

I just tested these against v6.0-rc2 and it fixes the deferred probe boot
issues I've been seeing. The patches already have my Tested-by for the
relevant patches, so as far as I'm concerned these are good to go.

Thanks,

Tony
