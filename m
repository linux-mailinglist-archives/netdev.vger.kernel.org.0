Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5122726AEFA
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgIOUqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgIOUm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:42:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46F4C06174A;
        Tue, 15 Sep 2020 13:42:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 830BC1368570E;
        Tue, 15 Sep 2020 13:26:06 -0700 (PDT)
Date:   Tue, 15 Sep 2020 13:42:52 -0700 (PDT)
Message-Id: <20200915.134252.1280841239760138359.davem@davemloft.net>
To:     oded.gabbay@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        SW_Drivers@habana.ai, gregkh@linuxfoundation.org, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 13:26:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>
Date: Tue, 15 Sep 2020 20:10:08 +0300

> This is the second version of the patch-set to upstream the GAUDI NIC code
> into the habanalabs driver.
> 
> The only modification from v2 is in the ethtool patch (patch 12). Details
> are in that patch's commit message.
> 
> Link to v2 cover letter:
> https://lkml.org/lkml/2020/9/12/201

I agree with Jakub, this driver definitely can't go-in as it is currently
structured and designed.  And because of the RDMA'ness of it, the RDMA
folks have to be CC:'d and have a chance to review this.
