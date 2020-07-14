Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FF521FEA3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGNUeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgGNUeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:34:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D19C061755;
        Tue, 14 Jul 2020 13:34:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C59215E18273;
        Tue, 14 Jul 2020 13:34:22 -0700 (PDT)
Date:   Tue, 14 Jul 2020 13:34:21 -0700 (PDT)
Message-Id: <20200714.133421.2049734897794187158.davem@davemloft.net>
To:     chenweilong@huawei.com
Cc:     kuba@kernel.org, jiri@mellanox.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net] rtnetlink: Fix memory(net_device) leak when
 ->newlink fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714074814.108767-1-chenweilong@huawei.com>
References: <20200714074814.108767-1-chenweilong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 13:34:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weilong Chen <chenweilong@huawei.com>
Date: Tue, 14 Jul 2020 15:48:14 +0800

> Fixes: e51fb152318ee6 (rtnetlink: fix a memory leak when ->newlink fails)

This is still not correct.

Read the feedback given to you carefully.
