Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF96284C60
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgJFNQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJFNQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:16:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFC3C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 06:16:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 937FC127C78F8;
        Tue,  6 Oct 2020 05:59:47 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:16:34 -0700 (PDT)
Message-Id: <20201006.061634.1596450157466769128.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch
Subject: Re: [PATCH v3 net-next 0/3] net: atlantic: phy tunables from mac
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201005153939.248-1-irusskikh@marvell.com>
References: <20201005153939.248-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 05:59:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Mon, 5 Oct 2020 18:39:36 +0300

> This series implements phy tunables settings via MAC driver callbacks.
> 
> AQC 10G devices use integrated MAC+PHY solution, where PHY is fully controlled
> by MAC firmware. Therefore, it is not possible to implement separate phy driver
> for these.
> 
> We use ethtool ops callbacks to implement downshift and EDPC tunables.
> 
> v3: fixed flaw in EDPD logic, from Andrew
> v2: comments from Andrew

Series applied, thank you.
