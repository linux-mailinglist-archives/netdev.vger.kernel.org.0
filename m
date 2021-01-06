Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF9B2EB772
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 02:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbhAFBHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 20:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAFBHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 20:07:14 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF8BC061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 17:06:34 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 9ED184CBCE1FB;
        Tue,  5 Jan 2021 17:06:33 -0800 (PST)
Date:   Tue, 05 Jan 2021 17:06:33 -0800 (PST)
Message-Id: <20210105.170633.704503794047767589.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        lukas@wunner.de
Subject: Re: [PATCH net-next V3 0/2] net: ks8851: Add KS8851 PHY support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210105141151.122922-1-marex@denx.de>
References: <20210105141151.122922-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 17:06:33 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Tue,  5 Jan 2021 15:11:49 +0100

> The KS8851 has a reduced internal PHY, which is accessible through its
> registers at offset 0xe4. The PHY is compatible with KS886x PHY present
> in Micrel switches, including the PHY ID Low/High registers swap, which
> is present both in the MAC and the switch.

Series applied, thanks.
