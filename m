Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152C333AAF
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfFCWEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:04:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36040 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfFCWEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:04:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B82AA136DF6FB;
        Mon,  3 Jun 2019 15:04:30 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:04:30 -0700 (PDT)
Message-Id: <20190603.150430.1257765088076082369.davem@davemloft.net>
To:     sean.wang@mediatek.com
Cc:     john@phrozen.org, nbd@openwrt.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        mark-mc.lee@mediatek.com
Subject: Re: [PATCH net v1 1/2] net: ethernet: mediatek: Use hw_feature to
 judge if HWLRO is supported
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559348187-14941-1-git-send-email-sean.wang@mediatek.com>
References: <1559348187-14941-1-git-send-email-sean.wang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:04:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sean.wang@mediatek.com>
Date: Sat, 1 Jun 2019 08:16:26 +0800

> From: Sean Wang <sean.wang@mediatek.com>
> 
> Should hw_feature as hardware capability flags to check if hardware LRO
> got support.
> 
> Signed-off-by: Mark Lee <mark-mc.lee@mediatek.com>
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>

Applied.
