Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAF31A38D2
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgDIRWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:22:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33414 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgDIRWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:22:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 196D1128D7979;
        Thu,  9 Apr 2020 10:22:18 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:22:17 -0700 (PDT)
Message-Id: <20200409.102217.217208935333876580.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com, sironhide0null@gmail.com
Subject: Re: [PATCH v2 net 1/2] net/rds: Replace struct rds_mr's r_refcount
 with struct kref
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
References: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:22:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Wed,  8 Apr 2020 03:21:01 -0700

> And removed rds_mr_put().
> 
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

Applied.
