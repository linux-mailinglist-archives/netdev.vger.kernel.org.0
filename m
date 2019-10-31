Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE0EB7FD
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfJaTdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:33:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbfJaTdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:33:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D88C414FD0BF1;
        Thu, 31 Oct 2019 12:33:30 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:33:30 -0700 (PDT)
Message-Id: <20191031.123330.290389323537118897.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/8] s390/qeth: updates 2019-10-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031124221.34028-1-jwi@linux.ibm.com>
References: <20191031124221.34028-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 12:33:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 31 Oct 2019 13:42:13 +0100

> please apply the following series of spooky qeth updates for net-next.

I hear that if you hack on S390, every day is like Halloween.

> The first two patches add support for an enhanced TX doorbell, which
> enables us to do more xmit_more-based bulking.
> Note that this requires one patch for the s390/qdio base layer, which
> has been graciously acked by Heiko to go through your tree.
> 
> The remaining patches are just the usual minor cleanups/improvements.

Series applied to net-next, thank you.
