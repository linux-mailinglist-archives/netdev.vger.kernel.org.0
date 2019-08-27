Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2668C9F5C7
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 00:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfH0WE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 18:04:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51378 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfH0WE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 18:04:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 33FBF15363D7D;
        Tue, 27 Aug 2019 15:04:57 -0700 (PDT)
Date:   Tue, 27 Aug 2019 15:04:56 -0700 (PDT)
Message-Id: <20190827.150456.509211205582645335.davem@davemloft.net>
To:     zhangsha.zhang@huawei.com
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuehaibing@huawei.com, hunongda@huawei.com, alex.chen@huawei.com
Subject: Re: [PATCH v2] bonding: force enable lacp port after link state
 recovery for 802.3ad
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190823034209.14596-1-zhangsha.zhang@huawei.com>
References: <20190823034209.14596-1-zhangsha.zhang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 15:04:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <zhangsha.zhang@huawei.com>
Date: Fri, 23 Aug 2019 11:42:09 +0800

> - If speed/duplex getting failed here, the link status
>   will be changed to BOND_LINK_FAIL;

How does it fail at this step?  I suspect this is a driver specific
problem.

