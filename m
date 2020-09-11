Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D854A26697A
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 22:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgIKUTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 16:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgIKUTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 16:19:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606C9C061795;
        Fri, 11 Sep 2020 13:19:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 137CD1365DC87;
        Fri, 11 Sep 2020 13:03:01 -0700 (PDT)
Date:   Fri, 11 Sep 2020 13:19:43 -0700 (PDT)
Message-Id: <20200911.131943.1509486357233508252.davem@davemloft.net>
To:     allen.lkml@gmail.com
Cc:     m.grzeschik@pengutronix.de, paulus@samba.org, oliver@neukum.org,
        woojung.huh@microchip.com, petkan@nucleusys.com,
        keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/8] drivers: net: convert tasklets to use new
 tasklet_setup()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAOMdWSJohOLK023ZM-yTnZiNHdy2TfyyWV3+iuuQiALiYV2NLQ@mail.gmail.com>
References: <20200817084614.24263-1-allen.cryptic@gmail.com>
        <CAOMdWSJohOLK023ZM-yTnZiNHdy2TfyyWV3+iuuQiALiYV2NLQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 13:03:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen <allen.lkml@gmail.com>
Date: Fri, 11 Sep 2020 11:26:52 +0530

> Will you pick these up or should I send these out again when I
> have fixed the two patches on the other thread.

Always resend.
