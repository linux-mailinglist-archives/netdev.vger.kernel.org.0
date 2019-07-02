Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09EAE5D5E2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGBSGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:06:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBSGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:06:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B04FA133E9BEA;
        Tue,  2 Jul 2019 11:06:47 -0700 (PDT)
Date:   Tue, 02 Jul 2019 11:06:42 -0700 (PDT)
Message-Id: <20190702.110642.1497627672189280557.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] iavf: remove unused debug function
 iavf_debug_d
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702062021.41524-1-yuehaibing@huawei.com>
References: <20190702062021.41524-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 11:06:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 2 Jul 2019 14:20:21 +0800

> There is no caller of function iavf_debug_d() in tree since
> commit 75051ce4c5d8 ("iavf: Fix up debug print macro"),
> so it can be removed.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Jeff, please queue this up or handle however is otherwise appropriate.

Thanks.
