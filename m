Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F2833AB3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfFCWEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:04:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfFCWEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:04:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 43CE3136E16AB;
        Mon,  3 Jun 2019 15:04:36 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:04:35 -0700 (PDT)
Message-Id: <20190603.150435.519222045740513627.davem@davemloft.net>
To:     sean.wang@mediatek.com
Cc:     john@phrozen.org, nbd@openwrt.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        mark-mc.lee@mediatek.com
Subject: Re: [PATCH net v1 2/2] net: ethernet: mediatek: Use NET_IP_ALIGN
 to judge if HW RX_2BYTE_OFFSET is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559348187-14941-2-git-send-email-sean.wang@mediatek.com>
References: <1559348187-14941-1-git-send-email-sean.wang@mediatek.com>
        <1559348187-14941-2-git-send-email-sean.wang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:04:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sean.wang@mediatek.com>
Date: Sat, 1 Jun 2019 08:16:27 +0800

> From: Sean Wang <sean.wang@mediatek.com>
> 
> Should only enable HW RX_2BYTE_OFFSET function in the case NET_IP_ALIGN
> equals to 2.
> 
> Signed-off-by: Mark Lee <mark-mc.lee@mediatek.com>
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>

Applied.
