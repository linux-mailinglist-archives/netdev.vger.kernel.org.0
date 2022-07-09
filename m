Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EF356C795
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 08:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiGIGlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 02:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiGIGlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 02:41:18 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CD7642AD3
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 23:41:15 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2696fED8004884;
        Sat, 9 Jul 2022 08:41:14 +0200
Date:   Sat, 9 Jul 2022 08:41:14 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Michelle Bies <mimbies@outlook.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: TPROXY + Attempt to release TCP socket in state 1
Message-ID: <20220709064114.GA4860@1wt.eu>
Reply-To: netdev@vger.kernel.org
References: <HE1P193MB01236F580D05214179C7AAC0A8819@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
 <HE1P193MB01233D583E9A7B1418A77713A8859@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1P193MB01233D583E9A7B1418A77713A8859@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Jul 09, 2022 at 06:14:14AM +0000, Michelle Bies wrote:
> Hi Eric
> unfortunately, nobody response to my problem :(
> Did I report my problem to the right mailing list? 

You sent it only 4 days ago! As you might have noticed you're not the
only one to request help, code reviews or anything that requires time
from only a few people. What progress have you made on your side on
the analysis of this problem in during this time, that you could share
to save precious time to those who are going to help you, and to make
your issue more interesting to analyse than other ones ?

Also, I'm seeing that your kernel is tainted by an out-of-tree module:

> >   CPU: 5 PID: 0 Comm: swapper/5 Tainted: GO 5.4.181+ #9
                                             ^^

Most likely it's this "xt_geoip" module but it may also be anything
else I have not spotted in your dump. Have you rechecked without it ?
While unlikely to be related, any out-of-tree code must be handled
with extreme care, as their impact on the rest of the kernel remains
mostly unknown, so they're the first ones to disable during
troubleshooting.

> > My current kernel is 5.4 and these are my iptables config:

Please always mention the exact version in reports. I've seen "5.4.181+"
in your dump, which means 5.4.181 plus extra patches. Have you tried
again without them ?

Hoping this helps,
Willy
