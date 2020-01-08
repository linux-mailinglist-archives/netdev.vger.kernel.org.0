Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94F2134FC2
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgAHXF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:05:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49250 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHXFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:05:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0DF21585B0C7;
        Wed,  8 Jan 2020 15:05:49 -0800 (PST)
Date:   Wed, 08 Jan 2020 15:05:49 -0800 (PST)
Message-Id: <20200108.150549.1889209588136221613.davem@davemloft.net>
To:     willy@infradead.org
Cc:     yukuai3@huawei.com, klassert@kernel.org, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, hslester96@gmail.com, mst@redhat.com,
        yang.wei9@zte.com.cn, netdev@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH V2] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108215929.GM6788@bombadil.infradead.org>
References: <20200106125337.40297-1-yukuai3@huawei.com>
        <20200108.124021.2097001545081493183.davem@davemloft.net>
        <20200108215929.GM6788@bombadil.infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 15:05:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Wed, 8 Jan 2020 13:59:29 -0800

> This waas a mistaken version; please revert and apply v3 instead.

Are you sure?

[davem@localhost net-next]$ git show e102774588b3ac0d221ed2d03a5153e056f1354f >x.diff
[davem@localhost net-next]$ patch -p1 -R <x.diff 
patching file drivers/net/ethernet/3com/3c59x.c
[davem@localhost net-next]$ mv ~/Downloads/V3-net-3com-3c59x-remove-set-but-not-used-variable-mii_reg1.patch ./
[davem@localhost net-next]$ patch -p1 <V3-net-3com-3c59x-remove-set-but-not-used-variable-mii_reg1.patch 
patching file drivers/net/ethernet/3com/3c59x.c
[davem@localhost net-next]$ git diff
[davem@localhost net-next]$

There is no difference in the code of the commit at all between V2 and V3.
