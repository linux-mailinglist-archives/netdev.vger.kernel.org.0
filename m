Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113B923F918
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 23:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgHHVXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 17:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgHHVXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 17:23:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A426C061756;
        Sat,  8 Aug 2020 14:23:53 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10A3C12730D17;
        Sat,  8 Aug 2020 14:07:07 -0700 (PDT)
Date:   Sat, 08 Aug 2020 14:23:51 -0700 (PDT)
Message-Id: <20200808.142351.782389886602997828.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] net: Remove meaningless jump label out_fs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596714859-25352-1-git-send-email-linmiaohe@huawei.com>
References: <1596714859-25352-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Aug 2020 14:07:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linmiaohe <linmiaohe@huawei.com>
Date: Thu, 6 Aug 2020 19:54:19 +0800

> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The out_fs jump label has nothing to do but goto out.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied.
