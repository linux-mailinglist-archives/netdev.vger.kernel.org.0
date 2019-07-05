Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D8860DC2
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfGEW0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:26:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfGEW0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:26:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53487150420B2;
        Fri,  5 Jul 2019 15:26:10 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:26:09 -0700 (PDT)
Message-Id: <20190705.152609.559945402112829129.davem@davemloft.net>
To:     hariprasad.kelam@gmail.com
Cc:     maxime.ripard@bootlin.com, wens@csie.org, ynezz@true.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: allwinner: Remove unneeded memset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704025906.GA20005@hari-Inspiron-1545>
References: <20190704025906.GA20005@hari-Inspiron-1545>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:26:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Date: Thu, 4 Jul 2019 08:29:06 +0530

> Remove unneeded memset as alloc_etherdev is using kvzalloc which uses
> __GFP_ZERO flag
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Applied.
