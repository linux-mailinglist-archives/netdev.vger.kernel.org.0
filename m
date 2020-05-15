Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0C41D42A6
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgEOBDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726122AbgEOBDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:03:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FF7C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 18:03:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA4AB14DDE4E5;
        Thu, 14 May 2020 18:03:37 -0700 (PDT)
Date:   Thu, 14 May 2020 18:03:36 -0700 (PDT)
Message-Id: <20200514.180336.1606261054620094922.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: r8169: don't include linux/moduleparam.h
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e3dab3ec-6ae9-ceeb-3277-2d84bf2ab93a@gmail.com>
References: <e3dab3ec-6ae9-ceeb-3277-2d84bf2ab93a@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 18:03:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 14 May 2020 23:44:07 +0200

> 93882c6f210a ("r8169: switch from netif_xxx message functions to
> netdev_xxx") removed the last module parameter from the driver,
> therefore there's no need any longer to include linux/moduleparam.h.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
