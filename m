Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5389D8529
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 03:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390430AbfJPBD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 21:03:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42652 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfJPBD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 21:03:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD32A1265001C;
        Tue, 15 Oct 2019 18:03:56 -0700 (PDT)
Date:   Tue, 15 Oct 2019 18:03:56 -0700 (PDT)
Message-Id: <20191015.180356.268577945716013325.davem@davemloft.net>
To:     Mark-MC.Lee@mediatek.com
Cc:     sean.wang@mediatek.com, john@phrozen.org,
        nelson.chang@mediatek.com, matthias.bgg@gmail.com, andrew@lunn.ch,
        robh+dt@kernel.org, mark.rutland@arm.com, opensource@vdorst.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net,v3 0/2] Update MT7629 to support PHYLINK API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014071518.11923-1-Mark-MC.Lee@mediatek.com>
References: <20191014071518.11923-1-Mark-MC.Lee@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 18:03:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MarkLee <Mark-MC.Lee@mediatek.com>
Date: Mon, 14 Oct 2019 15:15:16 +0800

> This patch set has two goals :
> 	1. Fix mt7629 GMII mode issue after apply mediatek
> 	   PHYLINK support patch.
> 	2. Update mt7629 dts to reflect the latest dt-binding
> 	   with PHYLINK support.

Series applied, thank you.
