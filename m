Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089AA52A70A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345519AbiEQPir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350563AbiEQPif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:38:35 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C171D50468;
        Tue, 17 May 2022 08:38:30 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id C621FFF88D;
        Tue, 17 May 2022 15:38:29 +0000 (UTC)
Date:   Tue, 17 May 2022 17:38:26 +0200
From:   Max Staudt <max@enpas.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220517173821.445c5e90.max@enpas.org>
In-Reply-To: <22590a57-c7c6-39c6-06d5-11c6e4e1534b@hartkopp.net>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
        <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
        <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
        <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
        <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
        <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
        <20220517104545.eslountqjppvcnz2@pengutronix.de>
        <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
        <20220517141404.578d188a.max@enpas.org>
        <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
        <20220517143921.08458f2c.max@enpas.org>
        <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
        <20220517154301.5bf99ba9.max@enpas.org>
        <22590a57-c7c6-39c6-06d5-11c6e4e1534b@hartkopp.net>
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

On Tue, 17 May 2022 16:35:05 +0200
Oliver Hartkopp <socketcan@hartkopp.net> wrote:

> I think it should be even more simple.
> 
> When you enter the current Kconfig page of "CAN Device Drivers" every 
> selection of vcan/vxcan/slcan should directly select CAN_DEV_SW.

I'm a bit lost - what would CAN_DEV_SW do?

If it enables can_dropped_invalid_skb(), then the HW drivers would also
need to depend on CAN_DEV_SW directly or indirectly, or am I missing
something?



Max
