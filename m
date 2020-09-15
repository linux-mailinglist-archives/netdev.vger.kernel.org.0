Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5CD26AF3A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgIOVLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbgIOU1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:27:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08260C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 13:27:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8386F128B037F;
        Tue, 15 Sep 2020 13:10:53 -0700 (PDT)
Date:   Tue, 15 Sep 2020 13:27:39 -0700 (PDT)
Message-Id: <20200915.132739.126239582515493968.davem@davemloft.net>
To:     drt@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net] ibmvnic: update MAINTAINERS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915003535.819585-1-drt@linux.ibm.com>
References: <20200915003535.819585-1-drt@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 13:10:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>
Date: Mon, 14 Sep 2020 20:35:35 -0400

> Update supporters for IBM Power SRIOV Virtual NIC Device Driver. 
> Thomas Falcon is moving on to other works. Dany Madden, Lijun Pan 
> and Sukadev Bhattiprolu are the current supporters.
> 
> Signed-off-by: Dany Madden <drt@linux.ibm.com>

Applied.
