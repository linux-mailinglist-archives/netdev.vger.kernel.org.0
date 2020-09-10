Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02135265051
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgIJULV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgIJUJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:09:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3923EC061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:09:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C18312A3707D;
        Thu, 10 Sep 2020 12:52:19 -0700 (PDT)
Date:   Thu, 10 Sep 2020 13:09:04 -0700 (PDT)
Message-Id: <20200910.130904.152565664606570.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH net-next 0/3] netpoll: make sure napi_list is safe for
 RCU traversal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909173753.229124-1-kuba@kernel.org>
References: <20200909173753.229124-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:52:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed,  9 Sep 2020 10:37:50 -0700

> This series is a follow-up to the fix in commit 96e97bc07e90 ("net: 
> disable netpoll on fresh napis"). To avoid any latent race conditions
> convert dev->napi_list to a proper RCU list. We need minor restructuring
> because it looks like netif_napi_del() used to be idempotent, and
> it may be quite hard to track down everyone who depends on that.

Series applied, thanks Jakub.
