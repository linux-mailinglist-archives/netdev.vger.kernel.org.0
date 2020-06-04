Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087BE1EEE02
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgFDW4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgFDW4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:56:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5325AC08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 15:56:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0112B11F5F8D1;
        Thu,  4 Jun 2020 15:56:09 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:56:09 -0700 (PDT)
Message-Id: <20200604.155609.603718530425256755.davem@davemloft.net>
To:     valentin@longchamp.me
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kuba@kernel.org, leoyang.li@nxp.com
Subject: Re: [PATCH] net: ethernet: freescale: remove unneeded include for
 ucc_geth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603212823.12501-1-valentin@longchamp.me>
References: <20200603212823.12501-1-valentin@longchamp.me>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:56:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Longchamp <valentin@longchamp.me>
Date: Wed,  3 Jun 2020 23:28:23 +0200

> net/sch_generic.h does not need to be included, remove it.
> 
> Signed-off-by: Valentin Longchamp <valentin@longchamp.me>

Applied.
