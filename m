Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3C1D21FF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbgEMWZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730064AbgEMWZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:25:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382B4C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 15:25:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0403C12118550;
        Wed, 13 May 2020 15:25:01 -0700 (PDT)
Date:   Wed, 13 May 2020 15:25:01 -0700 (PDT)
Message-Id: <20200513.152501.2023097002346051384.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     netdev@vger.kernel.org, sean.wang@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-mediatek@lists.infradead.org, linux@armlinux.org.uk,
        matthias.bgg@gmail.com, opensource@vdorst.com, tj17@me.com,
        foss@volatilesystems.org, riddlariddla@hotmail.com,
        szab.hu@gmail.com, fercerpav@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mt7530: set CPU port to fallback
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513153717.15599-1-dqfext@gmail.com>
References: <20200513153717.15599-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 15:25:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>
Date: Wed, 13 May 2020 23:37:17 +0800

> Currently, setting a bridge's self PVID to other value and deleting
> the default VID 1 renders untagged ports of that VLAN unable to talk to
> the CPU port:
> 
> 	bridge vlan add dev br0 vid 2 pvid untagged self
> 	bridge vlan del dev br0 vid 1 self
> 	bridge vlan add dev sw0p0 vid 2 pvid untagged
> 	bridge vlan del dev sw0p0 vid 1
> 	# br0 cannot send untagged frames out of sw0p0 anymore
> 
> That is because the CPU port is set to security mode and its PVID is
> still 1, and untagged frames are dropped due to VLAN member violation.
> 
> Set the CPU port to fallback mode so untagged frames can pass through.
> 
> Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Applied to net-next, thanks.
