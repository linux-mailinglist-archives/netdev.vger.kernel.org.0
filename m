Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D9B210049
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgF3W7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgF3W7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:59:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB3BC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:59:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72572127BE244;
        Tue, 30 Jun 2020 15:59:24 -0700 (PDT)
Date:   Tue, 30 Jun 2020 15:59:23 -0700 (PDT)
Message-Id: <20200630.155923.250393127040353192.davem@davemloft.net>
To:     Andre.Edich@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next 4/8] smsc95xx: remove redundant link status
 checking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d6c3c83b3615391b555e11671094d0276348a67a.camel@microchip.com>
References: <d6c3c83b3615391b555e11671094d0276348a67a.camel@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 15:59:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <Andre.Edich@microchip.com>
Date: Mon, 29 Jun 2020 13:11:47 +0000

> @@ -51,8 +51,6 @@
>  #define SUSPEND_ALLMODES		(SUSPEND_SUSPEND0 |
> SUSPEND_SUSPEND1 | \

Your email client is mangling these patches.
