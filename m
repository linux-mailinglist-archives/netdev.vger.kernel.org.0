Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0775274D88
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgIVXvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgIVXvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 19:51:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C184FC061755;
        Tue, 22 Sep 2020 16:51:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0636E13BF8158;
        Tue, 22 Sep 2020 16:34:27 -0700 (PDT)
Date:   Tue, 22 Sep 2020 16:51:14 -0700 (PDT)
Message-Id: <20200922.165114.402110655616716896.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     jarod@redhat.com, linux-kernel@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, tadavis@lbl.gov, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] bonding: rename slave to link where
 possible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922232317.jlbgpsy74q6tbx3a@lion.mk-sys.cz>
References: <20200922133731.33478-1-jarod@redhat.com>
        <20200922133731.33478-3-jarod@redhat.com>
        <20200922232317.jlbgpsy74q6tbx3a@lion.mk-sys.cz>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 22 Sep 2020 16:34:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 23 Sep 2020 01:23:17 +0200

> Even if the module parameters are deprecated and extremely inconvenient
> as a mean of bonding configuration, I would say changing their names
> would still count as "breaking the userspace".

I totally agree.

Anything user facing has to be kept around for the deprecation period,
and that includes module parameters.
