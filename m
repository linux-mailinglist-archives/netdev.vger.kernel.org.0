Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF78DBA64
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 02:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503764AbfJRABv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 20:01:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441828AbfJRABu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 20:01:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4026E1433FC59;
        Thu, 17 Oct 2019 17:01:50 -0700 (PDT)
Date:   Thu, 17 Oct 2019 17:01:49 -0700 (PDT)
Message-Id: <20191017.170149.2131317490793787816.davem@davemloft.net>
To:     sean.wang@mediatek.com
Cc:     john@phrozen.org, nbd@openwrt.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Mark-MC.Lee@mediatek.com
Subject: Re: [PATCH net-next] net: Update address for MediaTek ethernet
 driver in MAINTAINERS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fc0692002216a32b045a69f910e95c83c1ff559c.1571260085.git.sean.wang@mediatek.com>
References: <fc0692002216a32b045a69f910e95c83c1ff559c.1571260085.git.sean.wang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 17:01:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sean.wang@mediatek.com>
Date: Thu, 17 Oct 2019 05:14:08 +0800

> From: Sean Wang <sean.wang@mediatek.com>
> 
> Update maintainers for MediaTek ethernet driver with Mark Lee.
> He is familiar with MediaTek mt762x series ethernet devices and
> will keep following maintenance from the vendor side.
> 
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Mark Lee <Mark-MC.Lee@mediatek.com>

Applied to 'net', thank you.
