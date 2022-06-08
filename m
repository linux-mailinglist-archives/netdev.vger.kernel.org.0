Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB29542297
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379059AbiFHCqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354025AbiFHCgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 22:36:07 -0400
Received: from mail.enpas.org (zhong.enpas.org [IPv6:2a03:4000:2:537::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C99EE13F928;
        Tue,  7 Jun 2022 17:15:46 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id AD247FFB6C;
        Wed,  8 Jun 2022 00:15:44 +0000 (UTC)
Date:   Wed, 8 Jun 2022 02:15:37 +0200
From:   Max Staudt <max@enpas.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] can: slcan: extend supported features
Message-ID: <20220608021537.04c45cf9.max@enpas.org>
In-Reply-To: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dario, thank you so much for working on slcan!


To speed up the slcan cleanup, may I suggest looking at can327?

It started as a modification of slcan, and over the past few months,
it has gone through several review rounds in upstreaming. In fact, a
*ton* of things pointed out during reviews would apply 1:1 to slcan.

What's more, there's legacy stuff that's no longer needed. No
SLCAN_MAGIC, no slcan_devs, ... it's all gone in can327. May I suggest
you have a look at it and bring slcan's boilerplate in line with it?

It's certainly not perfect (7 patch series and counting, and that's
just the public ones), but I'm sure that looking at the two drivers
side-by-side could serve as a good starting point, to avoid
re-reviewing the same things all over again.


The current out-of-tree version can be found here (the repo name is
still the old one, elmcan), where I occasionally push changes before
bundling them up into an upstreaming patch. If a specific line seems
strange to you, "git blame" on this repo is likely to dig up a helpful
commit message, explaining the choice:

  https://github.com/norly/elmcan
  https://git.enpas.org/?p=elmcan.git


Max
