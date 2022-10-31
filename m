Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4F56131F9
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 09:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJaIx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 04:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJaIx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 04:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03AB1D3;
        Mon, 31 Oct 2022 01:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BFB760F7F;
        Mon, 31 Oct 2022 08:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EDDC433C1;
        Mon, 31 Oct 2022 08:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667206436;
        bh=KBG7B++aAvM/ROV60xTFkW51cjuAj+rwExEPVgb18zo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h6wMRVTsN0UVKxDi6/IvZpWFXs2I7dDSAEy54LQcB1LwG5EItbN6oPw4erlthpzGA
         HL/IfNRUuWLNedy+0gpKRLmFiHB3f/i34RvemANNRVgNKQ8Ksgx1nQptf6d5Kca0E3
         1J8xOGC7b/vYy87MdhKNMUmWWVmR/81C2sz43TxCYZ7O8q+jDmpileIxYBA1pacGKx
         XyiBncC8j7xw88C7ROMDh66ddG+6brWdVXAyRqiFepzn2LbAV9iFZ4I3Wvp3LElOKa
         gjIPgUQRZSSQ/s4aEyer1VqCDGws8UgKjfg2NFA09WmdutA3SYzp1/ZL+Boedw0S04
         9MTCDyOqhUgFA==
Date:   Mon, 31 Oct 2022 08:53:49 +0000
From:   Lee Jones <lee@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Gene Chen <gene_chen@richtek.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3 00/11] leds: deduplicate led_init_default_state_get()
Message-ID: <Y1+NHVS5ZJLFTBke@google.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <Y1gZ/zBtc2KgXlbw@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y1gZ/zBtc2KgXlbw@smile.fi.intel.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022, Andy Shevchenko wrote:

> On Tue, Sep 06, 2022 at 04:49:53PM +0300, Andy Shevchenko wrote:
> > There are several users of LED framework that reimplement the
> > functionality of led_init_default_state_get(). In order to
> > deduplicate them move the declaration to the global header
> > (patch 2) and convert users (patche 3-11).
> 
> Dear LED maintainers, is there any news on this series? It's hanging around
> for almost 2 months now...

My offer still stands if help is required.

-- 
Lee Jones [李琼斯]
