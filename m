Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A905EFA91
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfD3Ngp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:36:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42374 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfD3Ngo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 09:36:44 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54E8413D2CDDB;
        Tue, 30 Apr 2019 06:36:43 -0700 (PDT)
Date:   Tue, 30 Apr 2019 09:36:41 -0400 (EDT)
Message-Id: <20190430.093641.235792028903530007.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: limit recursion depth in policy validation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e86c0165d9c6966eaa2f653674ab16485b20da47.camel@sipsolutions.net>
References: <20190426121346.11005-1-johannes@sipsolutions.net>
        <20190429.230803.275536802508174338.davem@davemloft.net>
        <e86c0165d9c6966eaa2f653674ab16485b20da47.camel@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 06:36:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 30 Apr 2019 08:58:10 +0200

> If you prefer to have the safeguard in net even if it shouldn't be
> needed now, let me know and I'll make a version that applies there, but
> note that will invariably cause conflicts with all the other changes in
> lib/nlattr.c.

No, that's not necessary.

Thanks for asking.
