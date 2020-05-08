Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0681C9FE3
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgEHBAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgEHBAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:00:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB38C05BD43;
        Thu,  7 May 2020 18:00:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB4F2119376C2;
        Thu,  7 May 2020 18:00:31 -0700 (PDT)
Date:   Thu, 07 May 2020 18:00:30 -0700 (PDT)
Message-Id: <20200507.180030.809804789667183990.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net] hinic: fix a bug of ndo_stop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507043222.15522-1-luobin9@huawei.com>
References: <20200507043222.15522-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 18:00:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Thu, 7 May 2020 04:32:22 +0000

> +	ulong timeo;

Please fully spell out "unsigned long" for this type.

The same problem exists in your net-next patch submission as well.

Thank you.
