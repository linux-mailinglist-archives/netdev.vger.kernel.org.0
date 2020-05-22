Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396601DF2CC
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgEVXPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731117AbgEVXPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:15:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9A1C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 16:15:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFDDD12751799;
        Fri, 22 May 2020 16:15:00 -0700 (PDT)
Date:   Fri, 22 May 2020 16:15:00 -0700 (PDT)
Message-Id: <20200522.161500.1480809218526294578.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix OCP access on RTL8117
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0cf2b89e-b2f5-cc94-8257-5b99a177818f@gmail.com>
References: <0cf2b89e-b2f5-cc94-8257-5b99a177818f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:15:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 21 May 2020 22:03:08 +0200

> According to r8168 vendor driver DASHv3 chips like RTL8168fp/RTL8117
> need a special addressing for OCP access.
> Fix is compile-tested only due to missing test hardware.
> 
> Fixes: 1287723aa139 ("r8169: add support for RTL8117")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable, thanks.
