Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6283E9F8A9
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfH1DTm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 23:19:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfH1DTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:19:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 329E2153B831E;
        Tue, 27 Aug 2019 20:19:41 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:19:40 -0700 (PDT)
Message-Id: <20190827.201940.2141115576553497735.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     john@phrozen.org, sean.wang@mediatek.com,
        nelson.chang@mediatek.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        linux@armlinux.org.uk, frank-w@public-files.de, sr@denx.de
Subject: Re: [PATCH net-next v4 0/3] net: ethernet: mediatek: convert to
 PHYLINK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190825174341.20750-1-opensource@vdorst.com>
References: <20190825174341.20750-1-opensource@vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 20:19:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>
Date: Sun, 25 Aug 2019 19:43:38 +0200

> These patches converts mediatek driver to PHYLINK API.
> 
> v3->v4:
> * Phylink improvements and clean-ups after review
> v2->v3:
> * Phylink improvements and clean-ups after review
> v1->v2:
> * Rebase for mt76x8 changes
> * Phylink improvements and clean-ups after review
> * SGMII port doesn't support 2.5Gbit in SGMII mode only in BASE-X mode.
>   Refactor the code.

Series applied.
