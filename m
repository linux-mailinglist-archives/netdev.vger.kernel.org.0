Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50DCAA7733
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfICWl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:41:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfICWl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:41:29 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C343D14B7A8A2;
        Tue,  3 Sep 2019 15:41:27 -0700 (PDT)
Date:   Tue, 03 Sep 2019 15:41:20 -0700 (PDT)
Message-Id: <20190903.154120.2030052439962343992.davem@davemloft.net>
To:     alexandru.ardelean@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH 0/4] ethtool: implement Energy Detect Powerdown support
 via phy-tunable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190903160626.7518-1-alexandru.ardelean@analog.com>
References: <20190903160626.7518-1-alexandru.ardelean@analog.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Sep 2019 15:41:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Tue, 3 Sep 2019 19:06:22 +0300

> First 2 patches implement the kernel support for controlling Energy Detect
> Powerdown support via phy-tunable, and the next 2 patches implement the
> ethtool user-space control.

You should do this as two separate patch series, one for the kernel
portion and one for the ethtool part.
