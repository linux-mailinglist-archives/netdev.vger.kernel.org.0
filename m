Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B867A251930
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHYNGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgHYNGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:06:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D4DC061574;
        Tue, 25 Aug 2020 06:06:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E63A11E4576D;
        Tue, 25 Aug 2020 05:49:53 -0700 (PDT)
Date:   Tue, 25 Aug 2020 06:06:39 -0700 (PDT)
Message-Id: <20200825.060639.509871156873858000.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     johannes.berg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netlink: remove duplicated
 nla_need_padding_for_64bit() check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825032517.61864-1-linmiaohe@huawei.com>
References: <20200825032517.61864-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 05:49:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Mon, 24 Aug 2020 23:25:17 -0400

> The need for padding 64bit is implicitly checked by nla_align_64bit(), so
> remove this explicit one.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Also applied, thank you.
