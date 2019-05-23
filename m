Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7436F283BF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731156AbfEWQeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:34:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbfEWQeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:34:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C5F71509CAE6;
        Thu, 23 May 2019 09:34:13 -0700 (PDT)
Date:   Thu, 23 May 2019 09:34:12 -0700 (PDT)
Message-Id: <20190523.093412.1633409896386509148.davem@davemloft.net>
To:     esben@geanix.com
Cc:     netdev@vger.kernel.org, michal.simek@xilinx.com, andrew@lunn.ch,
        yuehaibing@huawei.com, dan.carpenter@oracle.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] net: ll_temac: Fix and enable multicast support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523120222.3807-1-esben@geanix.com>
References: <20190523120222.3807-1-esben@geanix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:34:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>
Date: Thu, 23 May 2019 14:02:18 +0200

> This patch series makes the necessary fixes to ll_temac driver to make
> multicast work, and enables support for it.so that multicast support can
> 
> The main change is the change from mutex to spinlock of the lock used to
> synchronize access to the shared indirect register access.

Applied, thanks.
