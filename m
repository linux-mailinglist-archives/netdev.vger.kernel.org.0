Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE052676B5
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgILAOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILANz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:13:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFDBC061573;
        Fri, 11 Sep 2020 17:13:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C33211FFCA2E;
        Fri, 11 Sep 2020 16:57:03 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:13:45 -0700 (PDT)
Message-Id: <20200911.171345.398356612906542473.davem@davemloft.net>
To:     rikard.falkeborn@gmail.com
Cc:     kuba@kernel.org, jerinj@marvell.com, gakula@marvell.com,
        lcherian@marvell.com, sgoutham@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] octeontx2-af: Constify
 npc_kpu_profile_{action,cam}
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911220015.41830-1-rikard.falkeborn@gmail.com>
References: <20200911220015.41830-1-rikard.falkeborn@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 16:57:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Date: Sat, 12 Sep 2020 00:00:15 +0200

> These are never modified, so constify them to allow the compiler to
> place them in read-only memory. This moves about 25kB to read-only
> memory as seen by the output of the size command.
> 
> Before:
>    text    data     bss     dec     hex filename
>  296203   65464    1248  362915   589a3 drivers/net/ethernet/marvell/octeontx2/af/octeontx2_af.ko
> 
> After:
>    text    data     bss     dec     hex filename
>  321003   40664    1248  362915   589a3 drivers/net/ethernet/marvell/octeontx2/af/octeontx2_af.ko
> 
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>

Applied, thank you.
