Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2004D83892
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732759AbfHFS3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:29:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfHFS3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:29:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCF3315412E0B;
        Tue,  6 Aug 2019 11:29:41 -0700 (PDT)
Date:   Tue, 06 Aug 2019 11:29:38 -0700 (PDT)
Message-Id: <20190806.112938.554749310736994710.davem@davemloft.net>
To:     wens@kernel.org
Cc:     mripard@kernel.org, wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: sun4i-emac: Support phy-handle
 property for finding PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806073539.32519-1-wens@kernel.org>
References: <20190806073539.32519-1-wens@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 11:29:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen-Yu Tsai <wens@kernel.org>
Date: Tue,  6 Aug 2019 15:35:39 +0800

> From: Chen-Yu Tsai <wens@csie.org>
> 
> The sun4i-emac uses the "phy" property to find the PHY it's supposed to
> use. This property was deprecated in favor of "phy-handle" in commit
> 8c5b09447625 ("dt-bindings: net: sun4i-emac: Convert the binding to a
> schemas").
> 
> Add support for this new property name, and fall back to the old one in
> case the device tree hasn't been updated.
> 
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Applied.
