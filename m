Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71307228C33
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgGUWtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUWtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:49:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DDAC061794;
        Tue, 21 Jul 2020 15:49:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4741B11E45904;
        Tue, 21 Jul 2020 15:32:50 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:49:34 -0700 (PDT)
Message-Id: <20200721.154934.1304491888556758023.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net 0/4] net: hns3: fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
References: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:32:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Tue, 21 Jul 2020 19:03:50 +0800

> There are some bugfixes for the HNS3 ethernet driver.

Series applied, thank you.
