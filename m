Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E98C2760C4
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgIWTIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWTIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:08:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0C7C0613CE;
        Wed, 23 Sep 2020 12:08:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE54E140C2772;
        Wed, 23 Sep 2020 11:51:25 -0700 (PDT)
Date:   Wed, 23 Sep 2020 12:08:12 -0700 (PDT)
Message-Id: <20200923.120812.1709996847344700602.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net-next 0/9] s390/qeth: updates 2020-09-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 11:51:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed, 23 Sep 2020 10:36:51 +0200

> please apply the following patch series for qeth to netdev's net-next tree.
> 
> This brings all sorts of cleanups. Highlights are more code sharing in
> the init/teardown paths, and more fine-grained rollback on errors during
> initialization (instead of a full-blown teardown).

Series applied, thank you.
