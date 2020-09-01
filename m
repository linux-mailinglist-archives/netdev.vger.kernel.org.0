Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF00259FAB
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgIAUMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgIAUMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:12:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AA2C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 13:12:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3DE0E1364C885;
        Tue,  1 Sep 2020 12:55:45 -0700 (PDT)
Date:   Tue, 01 Sep 2020 13:12:31 -0700 (PDT)
Message-Id: <20200901.131231.1278149582483928992.davem@davemloft.net>
To:     echaudro@redhat.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next] net: openvswitch: fixes crash if
 nf_conncount_init() fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159886787741.29248.5272329110875821435.stgit@ebuild>
References: <159886787741.29248.5272329110875821435.stgit@ebuild>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 12:55:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>
Date: Mon, 31 Aug 2020 11:57:57 +0200

> If nf_conncount_init fails currently the dispatched work is not canceled,
> causing problems when the timer fires. This change fixes this by not
> scheduling the work until all initialization is successful.
> 
> Fixes: a65878d6f00b ("net: openvswitch: fixes potential deadlock in dp cleanup code")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Applied, thank you.
