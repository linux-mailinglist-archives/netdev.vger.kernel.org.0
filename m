Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7538E37BE5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfFFSJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:09:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55180 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:09:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC4F514DE0A03;
        Thu,  6 Jun 2019 11:09:17 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:09:17 -0700 (PDT)
Message-Id: <20190606.110917.2216255283120651186.davem@davemloft.net>
To:     jiaolitao@raisecom.com
Cc:     petrm@mellanox.com, idosch@mellanox.com, roopa@cumulusnetworks.com,
        sd@queasysnail.net, sbrivio@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vxlan: Use FDB_HASH_SIZE hash_locks to reduce
 contention
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559815078-5901-1-git-send-email-jiaolitao@raisecom.com>
References: <1559815078-5901-1-git-send-email-jiaolitao@raisecom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:09:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Litao jiao <jiaolitao@raisecom.com>
Date: Thu,  6 Jun 2019 17:57:58 +0800

> The monolithic hash_lock could cause huge contention when
> inserting/deletiing vxlan_fdbs into the fdb_head.
> 
> Use FDB_HASH_SIZE hash_locks to protect insertions/deletions
> of vxlan_fdbs into the fdb_head hash table.
> 
> Suggested-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Litao jiao <jiaolitao@raisecom.com>

Applied, thanks.
