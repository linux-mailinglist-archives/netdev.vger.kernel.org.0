Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253305422AE
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353795AbiFHCqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447685AbiFHCmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 22:42:05 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A54E197633;
        Tue,  7 Jun 2022 17:22:13 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id CD01CFFB6C;
        Wed,  8 Jun 2022 00:22:12 +0000 (UTC)
Date:   Wed, 8 Jun 2022 02:22:10 +0200
From:   Max Staudt <max@enpas.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Message-ID: <20220608022123.05f73356.max@enpas.org>
In-Reply-To: <20220607171455.0a75020c@kernel.org>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
        <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
        <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
        <20220607182216.5fb1084e.max@enpas.org>
        <20220607150614.6248c504@kernel.org>
        <20220608014248.6e0045ae.max@enpas.org>
        <20220607171455.0a75020c@kernel.org>
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

On Tue, 7 Jun 2022 17:14:55 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> We have a ton of "magical" / hidden Kconfigs in networking, take a
> look at net/Kconfig. Quick grep, likely not very accurate but FWIW:

Fair enough. Thinking about it, I've grepped my distro's kernel config
for features more than just a handful of times...


> > How about making RX_OFFLOAD a separate .ko file, so we don't have
> > various possible versions of can_dev.ko?
> > 
> > @Vincent, I think you suggested that some time ago, IIRC?
> > 
> > (I know, I was against a ton of little modules, but I'm changing my
> > ways here now since it seems to help...)  
> 
> A separate module wouldn't help with my objections, I don't think.

In a system where the CAN stack is compiled as modules (i.e. a regular
desktop distribution), the feature's presence/absence would be easily
visible via the .ko file's presence/absence.

Then again, I have to agree, distributing a system where RX_OFFLOAD is
present, but no drivers using it whatsoever, seems... strange.

I guess I got lost in my thinking there, with my out of tree
development and all. Sorry for the noise.



Max
