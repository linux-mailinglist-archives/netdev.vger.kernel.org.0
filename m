Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1D36152C4
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 21:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiKAULQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 16:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAULP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 16:11:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622591BEAC;
        Tue,  1 Nov 2022 13:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5xpg96Om8w7lKyZNGC2XBLyuJgrXdIN28YKdVG20z7k=; b=3OGtCQeZ7HFT5c45RO29Lw8E2w
        W3HkOZqzna47vwVz5q9AEeL0NNSj3qWpfkjdFQ3wr1Zy0GSvE0mMVFczlGEJ/1WTov/TFjgzcvvJF
        d1c/zpE4AvnL9H4Qu0yAAZcNIXJoEJ49ZVqEjm7/XcGPBrEzJBngXgc/k8xFLl/AgVaE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1opxaA-0018d2-5a; Tue, 01 Nov 2022 21:09:58 +0100
Date:   Tue, 1 Nov 2022 21:09:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: mediatek: ppe: add support for flow
 accounting
Message-ID: <Y2F9FuJPOCMRy9z5@lunn.ch>
References: <Y2F1e9fFhmXh/IKz@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2F1e9fFhmXh/IKz@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 07:37:31PM +0000, Daniel Golle wrote:
> The PPE units found in MT7622 and newer support packet and byte
> accounting of hw-offloaded flows. Add support for reading those
> counters as found in MediaTek's SDK[1].
> 
> [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

What about ethtool -S support? That is the official API for
statistics, not debugfs.

	    Andrew
