Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A179025B5B9
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIBVO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBVO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:14:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6250FC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 14:14:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6400A156A472F;
        Wed,  2 Sep 2020 13:58:06 -0700 (PDT)
Date:   Wed, 02 Sep 2020 14:14:49 -0700 (PDT)
Message-Id: <20200902.141449.1995923435946574076.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     mptcp@lists.01.org, netdev@vger.kernel.org,
        matthieu.baerts@tessares.net
Subject: Re: [PATCH net-next] selftests: mptcp: fix typo in mptcp_connect
 usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6c43e5404c41f91ed9324e20c35a4e4fdb0ed1de.1599046871.git.dcaratti@redhat.com>
References: <6c43e5404c41f91ed9324e20c35a4e4fdb0ed1de.1599046871.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 13:58:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Wed,  2 Sep 2020 13:44:24 +0200

> in mptcp_connect, 's' selects IPPROTO_MPTCP / IPPROTO_TCP as the value of
> 'protocol' in socket(), and 'm' switches between different send / receive
> modes. Fix die_usage(): swap 'm' and 's' and add missing 'sendfile' mode.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, thank you.
