Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1A66ACB2D
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCFRsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCFRsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:48:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1D53430B;
        Mon,  6 Mar 2023 09:48:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DCFC61048;
        Mon,  6 Mar 2023 17:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C157EC4339B;
        Mon,  6 Mar 2023 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678124819;
        bh=2xAqNTwrDq2LIIw4+r+fHmkupi82Qi06RmkBf/KDGw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F3d+6PemnsnEXRzXxdpfM+0fl9NG55ehEN2AGgFJLXKRu8jywGX8MMdFvu2vU+csi
         v5MB2ixaNbkmC/gyVabzDzB7Gn7gZsZn6s+W+lLf9qDZCeloQD0mHzEQUPcCHDeHyJ
         6L2WvvUOi5arbnSwbhnt6JR/bnIriSaxc9oXkthN3I28asRtICWqL/myJZEApY9B66
         iTyz4HMwqYiCE3EguNkMDPmhbrTkXq83n86pvHRRCxXhXyCtEXWVLNFeF921imGBmg
         8nsuRxFGIvRCKSgfu3wbLgrVCUFUXZF360Eapzo0Ywi1LKkie53BAET6uqBhodxiI3
         jlYAw8ZGWHnWQ==
Date:   Mon, 6 Mar 2023 09:46:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Gene Chen <gene_chen@richtek.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v4 11/11] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <20230306094657.6f1190d2@kernel.org>
In-Reply-To: <ZAYMvVR+6eQ9qjAk@smile.fi.intel.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
        <20230103131256.33894-12-andriy.shevchenko@linux.intel.com>
        <ZAYMvVR+6eQ9qjAk@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Mar 2023 17:54:37 +0200 Andy Shevchenko wrote:
> On Tue, Jan 03, 2023 at 03:12:56PM +0200, Andy Shevchenko wrote:
> > LED core provides a helper to parse default state from firmware node.
> > Use it instead of custom implementation.  
> 
> Jakub, if you are okay with thi, it may be applied now
> (Lee hadn't taken it in via LEDS subsystem for v6.3-rc1).

Just patch 11 into net-next? SG, but could you repost?
I'd have to manually pick it out of the series.
