Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 066DE5A686
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfF1Vod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:44:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfF1Vod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:44:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2A3F13CB3313;
        Fri, 28 Jun 2019 14:44:32 -0700 (PDT)
Date:   Fri, 28 Jun 2019 14:44:32 -0700 (PDT)
Message-Id: <20190628.144432.1552876534695826593.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, nadavh@marvell.com,
        stefanc@marvell.com, mw@semihalf.com, walan@marvell.com
Subject: Re: [PATCH net v2] net: mvpp2: prs: Don't override the sign bit in
 SRAM parser shift
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625140412.7e8c84c4@bootlin.com>
References: <20190620094245.10501-1-maxime.chevallier@bootlin.com>
        <20190625140412.7e8c84c4@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 14:44:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Tue, 25 Jun 2019 14:04:12 +0200

> I see that this patch was set as "Accepted" on patchwork, but hasn't
> made it to -net, I was wondering if this patch slipped through the
> cracks :)
> 
> https://patchwork.ozlabs.org/patch/1119311/

It should really be there now.

I don't know how that happened, honestly ;)
