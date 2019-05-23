Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246F028DD8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbfEWXce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:32:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55056 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387693AbfEWXcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:32:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E5F4149CD336;
        Thu, 23 May 2019 16:32:32 -0700 (PDT)
Date:   Thu, 23 May 2019 16:32:29 -0700 (PDT)
Message-Id: <20190523.163229.1499181553844972278.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     chuck.lever@oracle.com, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, bfields@fieldses.org,
        jlayton@kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] xprtrdma: Use struct_size() in kzalloc()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <70ca0dea-6f1f-922c-7c5d-e79c6cf6ecb5@embeddedor.com>
References: <07CB966E-A946-4956-8480-C0FC13E13E4E@oracle.com>
        <ad9eccc7-afd2-3419-b886-6210eeabd5b5@embeddedor.com>
        <70ca0dea-6f1f-922c-7c5d-e79c6cf6ecb5@embeddedor.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 16:32:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Thu, 23 May 2019 17:36:00 -0500

> Hi Dave,
> 
> I wonder if you can take this patch.

The sunrpc/nfs maintainer should take this.  I never take patches in that
area.
