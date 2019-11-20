Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFB110455D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfKTUul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:50:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKTUul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:50:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB3DB14C2D796;
        Wed, 20 Nov 2019 12:50:40 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:50:40 -0800 (PST)
Message-Id: <20191120.125040.71624116290343942.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8169: smaller improvements to firmware
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6bb940ea-f479-f264-bc12-b4be52293dd6@gmail.com>
References: <6bb940ea-f479-f264-bc12-b4be52293dd6@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:50:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 20 Nov 2019 21:06:08 +0100

> This series includes few smaller improvements to firmware handling.

Series applied, thanks Heiner.
