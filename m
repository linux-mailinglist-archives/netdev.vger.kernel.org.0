Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B136A57787B
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiGQVuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiGQVuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:50:05 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 697B9FD27;
        Sun, 17 Jul 2022 14:50:04 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 4CF2DFF95E;
        Sun, 17 Jul 2022 21:50:03 +0000 (UTC)
Date:   Sun, 17 Jul 2022 23:50:00 +0200
From:   Max Staudt <max@enpas.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] can: can327: remove useless header inclusions
Message-ID: <20220717235000.247bfa42.max@enpas.org>
In-Reply-To: <20220716170201.2020510-1-dario.binacchi@amarulasolutions.com>
References: <20220716170201.2020510-1-dario.binacchi@amarulasolutions.com>
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

On Sat, 16 Jul 2022 19:02:01 +0200
Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:

> -#include <linux/init.h>
>  #include <linux/module.h>
> -
> -#include <linux/bitops.h>
> -#include <linux/ctype.h>
> -#include <linux/errno.h>
> -#include <linux/kernel.h>
> -#include <linux/list.h>
> -#include <linux/lockdep.h>
> -#include <linux/netdevice.h>
> -#include <linux/skbuff.h>
> -#include <linux/spinlock.h>
> -#include <linux/string.h>
>  #include <linux/tty.h>
> -#include <linux/tty_ldisc.h>
> -#include <linux/workqueue.h>
> -
> -#include <uapi/linux/tty.h>
> -
> -#include <linux/can.h>
>  #include <linux/can/dev.h>
> -#include <linux/can/error.h>
>  #include <linux/can/rx-offload.h>

AFAIK, the coding style is to not rely on headers including other
headers. Instead, the appropriate header for every symbol used should
be included.

This is also valid for the similar patch you submitted for slcan.


Unless something has changed, this is a NAK from me, sorry.


Max
