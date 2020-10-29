Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB98E29E4A0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgJ2HkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgJ2HYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:52 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8F6C0604DD;
        Wed, 28 Oct 2020 23:07:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 0A0771409B1;
        Thu, 29 Oct 2020 07:07:28 +0100 (CET)
Date:   Thu, 29 Oct 2020 07:07:21 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, ashkan.boldaji@digi.com
Subject: Re: [PATCH v6 0/4] Add support for mv88e6393x family of Marvell
Message-ID: <20201029070721.2e650f99@nic.cz>
In-Reply-To: <cover.1603944740.git.pavana.sharma@digi.com>
References: <20201028122115.GC933237@lunn.ch>
        <cover.1603944740.git.pavana.sharma@digi.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 15:40:25 +1000
Pavana Sharma <pavana.sharma@digi.com> wrote:

> Updated patchset.
> 
> Split the patch to separate mv88e6393 changes from refactoring
> serdes_get_lane.
> Update Documentation before adding new mode.

Pavana, the patch adding support for Amethyst has to be the last in the
series. The patch refactoring the serdes_get_lane code must go before
the patch adding the support for the new family, because Amethyst
already needs this functionality.

