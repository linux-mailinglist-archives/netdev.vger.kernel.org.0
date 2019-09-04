Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA69A9671
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbfIDW2m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 18:28:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIDW2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:28:42 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 380CA15286012;
        Wed,  4 Sep 2019 15:28:38 -0700 (PDT)
Date:   Wed, 04 Sep 2019 15:28:37 -0700 (PDT)
Message-Id: <20190904.152837.1289570584021077118.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     sean.wang@mediatek.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux@armlinux.org.uk,
        john@phrozen.org, linux-mips@vger.kernel.org,
        frank-w@public-files.de
Subject: Re: [PATCH net-next v3 0/3] net: dsa: mt7530: Convert to PHYLINK
 and add support for port 5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190902130226.26845-1-opensource@vdorst.com>
References: <20190902130226.26845-1-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 15:28:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>
Date: Mon,  2 Sep 2019 15:02:23 +0200

> 1. net: dsa: mt7530: Convert to PHYLINK API
>    This patch converts mt7530 to PHYLINK API.
> 2. dt-bindings: net: dsa: mt7530: Add support for port 5
> 3. net: dsa: mt7530: Add support for port 5
>    These 2 patches adding support for port 5 of the switch.
> 
> v2->v3:
>  * Removed 'status = "okay"' lines in patch #2
>  * Change a port 5 setup message in a debug message in patch #3
>  * Added ack-by and tested-by tags
> v1->v2:
>  * Mostly phylink improvements after review.
> rfc -> v1:
>  * Mostly phylink improvements after review.
>  * Drop phy isolation patches. Adds no value for now.

Series applied.
