Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119EE6D750
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 01:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfGRXgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 19:36:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGRXgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 19:36:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42CBB1528C8A9;
        Thu, 18 Jul 2019 16:36:12 -0700 (PDT)
Date:   Thu, 18 Jul 2019 16:36:11 -0700 (PDT)
Message-Id: <20190718.163611.739573720782543608.davem@davemloft.net>
To:     sr@denx.de
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        opensource@vdorst.com, sean.wang@mediatek.com, nbd@openwrt.org,
        john@phrozen.org
Subject: Re: [PATCH] net: ethernet: mediatek: Add MT7628/88 SoC support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717110243.14240-1-sr@denx.de>
References: <20190717110243.14240-1-sr@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 16:36:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Roese <sr@denx.de>
Date: Wed, 17 Jul 2019 13:02:43 +0200

> This patch adds support for the MediaTek MT7628/88 SoCs to the common
> MediaTek ethernet driver. Some minor changes are needed for this and
> a bigger change, as the MT7628 does not support QDMA (only PDMA).
> 
> Signed-off-by: Stefan Roese <sr@denx.de>

Besides the feedback you've received, this kind of change is only appropriate
for the net-next tree at this time.

If you wish to keep sending versions for review until the net-next tree opens
back up, clearly indicate in your Subject line by saying "[PATCH RFC ...]" or
similar.

Thank you.
