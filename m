Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925BB74160
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbfGXW03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:26:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbfGXW00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:26:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 742691543BD0E;
        Wed, 24 Jul 2019 15:26:25 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:26:12 -0700 (PDT)
Message-Id: <20190724.152612.864896276004624257.davem@davemloft.net>
To:     schwab@suse.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: initialize stats array
From:   David Miller <davem@davemloft.net>
In-Reply-To: <mvmh87bih1y.fsf@suse.de>
References: <mvmh87bih1y.fsf@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:26:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Schwab <schwab@suse.de>
Date: Wed, 24 Jul 2019 17:32:57 +0200

> The memory allocated for the stats array may contain arbitrary data.
> 
> Signed-off-by: Andreas Schwab <schwab@suse.de>

Applied and queued up for -stable.
