Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA45430E9
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbiFHM4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239510AbiFHMz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:55:58 -0400
Received: from mail.enpas.org (zhong.enpas.org [IPv6:2a03:4000:2:537::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADA4326AFD;
        Wed,  8 Jun 2022 05:55:54 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 18FEC100022;
        Wed,  8 Jun 2022 12:55:52 +0000 (UTC)
Date:   Wed, 8 Jun 2022 14:55:49 +0200
From:   Max Staudt <max@enpas.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] can: slcan: extend supported features
Message-ID: <20220608145549.67f0f831.max@enpas.org>
In-Reply-To: <20220608071947.pwl4whyzqpyubzqn@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
        <20220608021537.04c45cf9.max@enpas.org>
        <20220608071947.pwl4whyzqpyubzqn@pengutronix.de>
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

On Wed, 8 Jun 2022 09:19:47 +0200
Marc Kleine-Budde <mkl@pengutronix.de> wrote:

> On 08.06.2022 02:15:37, Max Staudt wrote:
> > To speed up the slcan cleanup, may I suggest looking at can327?
> > 
> > It started as a modification of slcan, and over the past few months,
> > it has gone through several review rounds in upstreaming. In fact, a
> > *ton* of things pointed out during reviews would apply 1:1 to slcan.
> > 
> > What's more, there's legacy stuff that's no longer needed. No
> > SLCAN_MAGIC, no slcan_devs, ... it's all gone in can327. May I
> > suggest you have a look at it and bring slcan's boilerplate in line
> > with it?  
> 
> +1
> 
> Most of Dario's series looks good. I suggest that we mainline this
> first. If there's interest and energy the slcan driver can be reworked
> to re-use the more modern concepts of the can327 driver.

Agreed. It does look good, and I'm glad to see slcan get some
love.

Thanks Dario!


Max
