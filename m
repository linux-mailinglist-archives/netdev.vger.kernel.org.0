Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFBA583222
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbiG0Sg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiG0SgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:36:11 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C5F2820EB;
        Wed, 27 Jul 2022 10:33:32 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 456C5FFCE8;
        Wed, 27 Jul 2022 17:33:15 +0000 (UTC)
Date:   Wed, 27 Jul 2022 19:33:13 +0200
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
        Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220727193313.71d54ce0.max@enpas.org>
In-Reply-To: <CABGWkvqF4HSKVrO8W8oyDPCMfx_B2xQZ_EWET11RZb6k8Kmb=w@mail.gmail.com>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
        <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
        <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
        <CABGWkvrmbQcCHdZ_ANb+_196d9HsAxAHc4QS94R19v5STHcbiA@mail.gmail.com>
        <20220727172101.iw3yiynni6feft4v@pengutronix.de>
        <CABGWkvqF4HSKVrO8W8oyDPCMfx_B2xQZ_EWET11RZb6k8Kmb=w@mail.gmail.com>
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

On Wed, 27 Jul 2022 19:28:45 +0200
Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:

> On Wed, Jul 27, 2022 at 7:21 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >
> > Ok - We avoided writing bit timing registers from user space into the
> > hardware for all existing drivers. If there isn't a specific use case,
> > let's skip this patch. If someone comes up with a use case we can think
> > of a proper solution.  
> 
> Ok. So do I also remove the 7/9 "ethtool: add support to get/set CAN
> bit time register"
> patch ?

If I may answer as well - IMHO, yes.

Unless we know that BTR is something other than just a different way to
express the bitrate, I'd skip it, yes. Because bitrate is already
handled by other, cross-device mechanisms.


Max
