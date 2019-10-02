Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B32C94CE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfJBX0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:26:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbfJBX0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:26:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55F001551F283;
        Wed,  2 Oct 2019 16:26:02 -0700 (PDT)
Date:   Wed, 02 Oct 2019 16:26:01 -0700 (PDT)
Message-Id: <20191002.162601.14990891485293274.davem@davemloft.net>
To:     sudhakar.dindukurti@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next v2] net/rds: Log vendor error if send/recv
 Work requests fail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569972794-47390-1-git-send-email-sudhakar.dindukurti@oracle.com>
References: <1569972794-47390-1-git-send-email-sudhakar.dindukurti@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 16:26:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
Date: Tue,  1 Oct 2019 16:33:14 -0700

> Log vendor error if work requests fail. Vendor error provides
> more information that is used for debugging the issue.
> 
> Signed-off-by: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Applied, thanks.
