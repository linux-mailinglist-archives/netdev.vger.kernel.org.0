Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4F524C8A3
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgHTXg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgHTXg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:36:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1087C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:36:26 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B188B12879A23;
        Thu, 20 Aug 2020 16:19:39 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:36:24 -0700 (PDT)
Message-Id: <20200820.163624.450318031364304724.davem@davemloft.net>
To:     ljp@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next v2 0/4] refactoring of ibmvnic code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819225226.10152-1-ljp@linux.ibm.com>
References: <20200819225226.10152-1-ljp@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 16:19:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>
Date: Wed, 19 Aug 2020 17:52:22 -0500

> This patch series refactor reset_init and init functions,
> and make some other cosmetic changes to make the code
> easier to read and debug. v2 removes __func__ and v1's 1/5.

Series applied, thank you.
