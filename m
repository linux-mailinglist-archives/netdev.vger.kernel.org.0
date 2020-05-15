Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129601D57FA
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgEORcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEORcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:32:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B4AC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 10:32:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB94D14DA8B64;
        Fri, 15 May 2020 10:32:08 -0700 (PDT)
Date:   Fri, 15 May 2020 10:32:08 -0700 (PDT)
Message-Id: <20200515.103208.906689697591119838.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     netdev@vger.kernel.org, sean.wang@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-mediatek@lists.infradead.org, linux@armlinux.org.uk,
        matthias.bgg@gmail.com, opensource@vdorst.com, tj17@me.com,
        foss@volatilesystems.org, riddlariddla@hotmail.com,
        szab.hu@gmail.com, fercerpav@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mt7530: fix VLAN setup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515152555.6572-1-dqfext@gmail.com>
References: <20200515152555.6572-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:32:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>
Date: Fri, 15 May 2020 23:25:55 +0800

> Allow DSA to add VLAN entries even if VLAN filtering is disabled, so
> enabling it will not block the traffic of existent ports in the bridge
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Applied, thank you.
