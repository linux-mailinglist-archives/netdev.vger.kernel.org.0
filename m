Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA725403A7
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343770AbiFGQW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243874AbiFGQWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:22:25 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4C7821A;
        Tue,  7 Jun 2022 09:22:20 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id E6B03100021;
        Tue,  7 Jun 2022 16:22:18 +0000 (UTC)
Date:   Tue, 7 Jun 2022 18:22:16 +0200
From:   Max Staudt <max@enpas.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Message-ID: <20220607182216.5fb1084e.max@enpas.org>
In-Reply-To: <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
        <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
        <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
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

On Tue, 7 Jun 2022 18:27:55 +0900
Vincent MAILHOL <mailhol.vincent@wanadoo.fr> wrote:

> Second, and regardless of the above, I really think that it makes
> sense to have everything built in can-dev.ko by default. If someone
> does a binary release of can-dev.ko in which the rx offload is
> deactivated, end users would get really confused.
> 
> Having a can-dev module stripped down is an expert setting. The
> average user which does not need CAN can deselect CONFIG_CAN and be
> happy. The average hobbyist who wants to do some CAN hacking will
> activate CONFIG_CAN and will automatically have the prerequisites in
> can-dev for any type of device drivers (after that just need to select
> the actual device drivers). The advanced user who actually read all
> the help menus will know that he should rather keep those to "yes"
> throughout the "if unsure, say Y" comment. Finally, the experts can
> fine tune their configuration by deselecting the pieces they did not
> wish for.
> 
> Honestly, I am totally happy to have the "default y" tag, the "if
> unsure, say Y" comment and the "select CAN_RX_OFFLOAD" all together.
> 
> Unless I am violating some kind of best practices, I prefer to keep it
> as-is. Hope this makes sense.

I wholeheartedly agree with Vincent's decision.

One example case would be users of my can327 driver, as long as it is
not upstream yet. They need to have RX_OFFLOAD built into their
distribution's can_dev.ko, otherwise they will have no choice but to
build their own kernel.


Max
