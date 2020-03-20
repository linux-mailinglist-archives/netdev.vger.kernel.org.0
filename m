Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8B718C64C
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgCTELo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Mar 2020 00:11:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46706 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgCTELo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:11:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6594F158FAD8C;
        Thu, 19 Mar 2020 21:11:43 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:11:42 -0700 (PDT)
Message-Id: <20200319.211142.227637721585547364.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     netdev@vger.kernel.org, frank-w@public-files.de, dqfext@gmail.com,
        landen.chao@mediatek.com, sean.wang@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        matthias.bgg@gmail.com, linux@armlinux.org.uk,
        linux-mediatek@lists.infradead.org, andrew.smith@digi.com
Subject: Re: [[PATCH,net]] net: dsa: mt7530: Change the LINK bit to reflect
 the link status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319134756.46428-1-opensource@vdorst.com>
References: <20200319134756.46428-1-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:11:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>
Date: Thu, 19 Mar 2020 14:47:56 +0100

> Andrew reported:
> 
> After a number of network port link up/down changes, sometimes the switch
> port gets stuck in a state where it thinks it is still transmitting packets
> but the cpu port is not actually transmitting anymore. In this state you
> will see a message on the console
> "mtk_soc_eth 1e100000.ethernet eth0: transmit timed out" and the Tx counter
> in ifconfig will be incrementing on virtual port, but not incrementing on
> cpu port.
> 
> The issue is that MAC TX/RX status has no impact on the link status or
> queue manager of the switch. So the queue manager just queues up packets
> of a disabled port and sends out pause frames when the queue is full.
> 
> Change the LINK bit to reflect the link status.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Reported-by: Andrew Smith <andrew.smith@digi.com>
> Signed-off-by: René van Dorst <opensource@vdorst.com>

Applied and queued up for -stable, thanks.
