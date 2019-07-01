Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB4930254
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfE3Sxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:53:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Sxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:53:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36FA314D9DD57;
        Thu, 30 May 2019 11:53:48 -0700 (PDT)
Date:   Thu, 30 May 2019 11:53:47 -0700 (PDT)
Message-Id: <20190530.115347.1992422954388539308.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, aacid@kde.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix MAC address being lost in PCI D3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <425a6651-4728-babb-3ac4-1dacc87d702a@gmail.com>
References: <425a6651-4728-babb-3ac4-1dacc87d702a@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:53:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 29 May 2019 07:44:01 +0200

> (At least) RTL8168e forgets its MAC address in PCI D3. To fix this set
> the MAC address when resuming. For resuming from runtime-suspend we
> had this in place already, for resuming from S3/S5 it was missing.
> 
> The commit referenced as being fixed isn't wrong, it's just the first
> one where the patch applies cleanly.
> 
> Fixes: 0f07bd850d36 ("r8169: use dev_get_drvdata where possible")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Reported-by: Albert Astals Cid <aacid@kde.org>
> Tested-by: Albert Astals Cid <aacid@kde.org>

Applied and queued up for -stable.
