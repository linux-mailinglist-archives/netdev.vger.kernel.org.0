Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B419423F926
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 23:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHHV33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 17:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHV33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 17:29:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2600FC061756;
        Sat,  8 Aug 2020 14:29:29 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C956127362A5;
        Sat,  8 Aug 2020 14:12:42 -0700 (PDT)
Date:   Sat, 08 Aug 2020 14:29:26 -0700 (PDT)
Message-Id: <20200808.142926.883053326455909981.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Convert to use the fallthrough macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596874990-22437-1-git-send-email-linmiaohe@huawei.com>
References: <1596874990-22437-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Aug 2020 14:12:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Sat, 8 Aug 2020 16:23:10 +0800

> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Convert the uses of fallthrough comments to fallthrough macro.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied.
