Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C431AD126
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 22:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbgDPUdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 16:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728696AbgDPUc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 16:32:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227DCC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 13:32:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C450712756799;
        Thu, 16 Apr 2020 13:32:56 -0700 (PDT)
Date:   Thu, 16 Apr 2020 13:32:53 -0700 (PDT)
Message-Id: <20200416.133253.1036884388591864417.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     netdev@vger.kernel.org, sean.wang@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, linux-mediatek@lists.infradead.org,
        john@phrozen.org, foss@volatilesystems.org, gch981213@gmail.com,
        riddlariddla@hotmail.com, opensource@vdorst.com, szab.hu@gmail.com,
        ptpt52@gmail.com, fercerpav@gmail.com
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: fix tagged frames
 pass-through in VLAN-unaware mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414063408.4026-1-dqfext@gmail.com>
References: <20200414063408.4026-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Apr 2020 13:32:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>
Date: Tue, 14 Apr 2020 14:34:08 +0800

> In VLAN-unaware mode, the Egress Tag (EG_TAG) field in Port VLAN
> Control register must be set to Consistent to let tagged frames pass
> through as is, otherwise their tags will be stripped.
> 
> Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Applied and queued up for -stable, thanks.
