Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04CA6AFE49
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfIKOGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:06:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfIKOGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:06:06 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6971015002441;
        Wed, 11 Sep 2019 07:06:05 -0700 (PDT)
Date:   Wed, 11 Sep 2019 16:06:03 +0200 (CEST)
Message-Id: <20190911.160603.1137498967365145823.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net] net/rds: An rds_sock is added too early to the
 hash table
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568195885-6285-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1568195885-6285-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 07:06:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Wed, 11 Sep 2019 02:58:05 -0700

> In rds_bind(), an rds_sock is added to the RDS bind hash table before
> rs_transport is set.  This means that the socket can be found by the
> receive code path when rs_transport is NULL.  And the receive code
> path de-references rs_transport for congestion update check.  This can
> cause a panic.  An rds_sock should not be added to the bind hash table
> before all the needed fields are set.
> 
> Reported-by: syzbot+4b4f8163c2e246df3c4c@syzkaller.appspotmail.com
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

Applied.
