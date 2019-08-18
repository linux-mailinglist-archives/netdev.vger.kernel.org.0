Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C61C919B3
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfHRVR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 17:17:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfHRVR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 17:17:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70421145F4F53;
        Sun, 18 Aug 2019 14:17:26 -0700 (PDT)
Date:   Sun, 18 Aug 2019 14:17:26 -0700 (PDT)
Message-Id: <20190818.141726.699941540105787008.davem@davemloft.net>
To:     sr@denx.de
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        opensource@vdorst.com, daniel@makrotopia.org,
        sean.wang@mediatek.com, john@phrozen.org
Subject: Re: [PATCH net-next 4/4 v3] net: ethernet: mediatek: Add MT7628/88
 SoC support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190816132325.28426-4-sr@denx.de>
References: <20190816132325.28426-1-sr@denx.de>
        <20190816132325.28426-4-sr@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 14:17:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Roese <sr@denx.de>
Date: Fri, 16 Aug 2019 15:23:25 +0200

> This patch adds support for the MediaTek MT7628/88 SoCs to the common
> MediaTek ethernet driver. Some minor changes are needed for this and
> a bigger change, as the MT7628 does not support QDMA (only PDMA).
> 
> Signed-off-by: Stefan Roese <sr@denx.de>

Applied.

Please submit your patch series properly next time, which means including
a "[PATCH 0/N]" introductory posting which explains what the patch series
is doing, how it is doing it, and why it is doing it that way.

It not only provides a proper organizational object for your patch series,
it also makes less work for me because I can just reply to that single email
when I apply your series instead of having to reply to every single one
in the set.

Thanks.
