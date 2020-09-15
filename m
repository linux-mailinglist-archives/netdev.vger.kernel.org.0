Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A4B26AF42
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgIOVNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbgIOU0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:26:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DA9C06178A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 13:26:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C594913682891;
        Tue, 15 Sep 2020 13:10:00 -0700 (PDT)
Date:   Tue, 15 Sep 2020 13:26:46 -0700 (PDT)
Message-Id: <20200915.132646.1199076338091593984.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     mkubecek@suse.cz, michael.chan@broadcom.com, saeedm@nvidia.com,
        tariqt@nvidia.com, andrew@lunn.ch, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/8] ethtool: add pause frame stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915001159.346469-1-kuba@kernel.org>
References: <20200915001159.346469-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 13:10:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 14 Sep 2020 17:11:51 -0700

> This is the first (small) series which exposes some stats via
> the corresponding ethtool interface. Here (thanks to the
> excitability of netlink) we expose pause frame stats via
> the same interfaces as ethtool -a / -A.
> 
> In particular the following stats from the standard:
>  - 30.3.4.2 aPAUSEMACCtrlFramesTransmitted
>  - 30.3.4.3 aPAUSEMACCtrlFramesReceived
> 
> 4 real drivers are converted, I believe we got confirmation
> from maintainers that all exposed stats match the standard.
 ...

Series applied, thanks.
