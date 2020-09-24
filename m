Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6C27656B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgIXAvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIXAvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:51:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922EAC0613CE;
        Wed, 23 Sep 2020 17:51:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A019712117692;
        Wed, 23 Sep 2020 17:34:50 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:51:35 -0700 (PDT)
Message-Id: <20200923.175135.339096113926173453.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: dsa: bcm_sf2: Additional DT changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922200356.2611257-1-f.fainelli@gmail.com>
References: <20200922200356.2611257-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:34:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 22 Sep 2020 13:03:54 -0700

> This patch series includes some additional changes to the bcm_sf2 in
> order to support the Device Tree firmwares provided on such platforms.

Series applied, thanks Florian.
