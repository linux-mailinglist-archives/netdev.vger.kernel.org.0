Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9251652BF17
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiERPsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbiERPsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:48:08 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 250BF21E0B;
        Wed, 18 May 2022 08:48:07 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 274BCFFBF3;
        Wed, 18 May 2022 15:48:06 +0000 (UTC)
Date:   Wed, 18 May 2022 17:48:03 +0200
From:   Max Staudt <max@enpas.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220518174803.010db67d.max@enpas.org>
In-Reply-To: <CAMZ6RqJ5hXwE5skJLxRVAH4-RB8UkXmQdZWW_z=jj+bXzJZY=Q@mail.gmail.com>
References: <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
        <20220517141404.578d188a.max@enpas.org>
        <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
        <20220517143921.08458f2c.max@enpas.org>
        <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
        <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
        <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net>
        <20220518132811.xfmwms2cu3bfxgrp@pengutronix.de>
        <CAMZ6RqJqeNjAtoDWADHsWocgbSXqQixcebJBhiBFS8BVeKCb3g@mail.gmail.com>
        <3dbe135e-d13c-5c5d-e7e4-b9c13b820fb8@hartkopp.net>
        <20220518143613.2a7alnw6vtkw7ct2@pengutronix.de>
        <482fd87a-df5a-08f7-522b-898d68c3b04a@hartkopp.net>
        <899706c6-0aac-b039-4b67-4e509ff0930d@hartkopp.net>
        <CAMZ6RqJ5hXwE5skJLxRVAH4-RB8UkXmQdZWW_z=jj+bXzJZY=Q@mail.gmail.com>
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

On Thu, 19 May 2022 00:38:51 +0900
Vincent MAILHOL <mailhol.vincent@wanadoo.fr> wrote:

> On Wed. 18 May 2022 at 23:59, Oliver Hartkopp
> <socketcan@hartkopp.net> wrote:
> > I can send a patch for this removal too. That's an easy step which
> > might get into 5.19 then.  
> 
> OK, go ahead. On my side, I will start to work on the other changes
> either next week or next next week, depending on my mood.


Any wishes for the next version of can327/elmcan?

Should I wait until your changes are in?


Max
