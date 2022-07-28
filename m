Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F664583C9A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbiG1K5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbiG1K5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:57:40 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90A945F134;
        Thu, 28 Jul 2022 03:57:39 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 00AF0FFCE8;
        Thu, 28 Jul 2022 10:57:36 +0000 (UTC)
Date:   Thu, 28 Jul 2022 12:57:34 +0200
From:   Max Staudt <max@enpas.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220728125734.1c380d25.max@enpas.org>
In-Reply-To: <20220728105049.43gbjuctezxzmm4j@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
        <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
        <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
        <20220727192839.707a3453.max@enpas.org>
        <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
        <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
        <20220728090228.nckgpmfe7rpnfcyr@pengutronix.de>
        <CABGWkvoYR67MMmqZ6bRLuL3szhVb-gMwuAy6Z4YMkaG0yw6Sdg@mail.gmail.com>
        <20220728105049.43gbjuctezxzmm4j@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 12:50:49 +0200
Marc Kleine-Budde <mkl@pengutronix.de> wrote:

> On 28.07.2022 12:23:04, Dario Binacchi wrote:
> > > > Does it make sense to use the device tree  
> > >
> > > The driver doesn't support DT and DT only works for static serial
> > > interfaces.  
> 
> Have you seen my remarks about Device Tree?

Dario, there seems to be a misunderstanding about the Device Tree.

It is used *only* for hardware that is permanently attached, present at
boot, and forever after. Not for dyamically added stuff, and definitely
not for ldiscs that have to be attached manually by the user.


The only exception to this is if you have an embedded device with an
slcan adapter permanently attached to one of its UARTs. Then you can
use the serdev ldisc adapter to attach the ldisc automatically at boot.

If you are actively developing for such a use case, please let us know,
so we know what you're after and can help you better :)


Max
