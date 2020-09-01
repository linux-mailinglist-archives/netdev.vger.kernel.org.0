Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4706259FA3
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgIAULP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgIAULN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:11:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C770C061244;
        Tue,  1 Sep 2020 13:11:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD9431364B6FD;
        Tue,  1 Sep 2020 12:54:25 -0700 (PDT)
Date:   Tue, 01 Sep 2020 13:11:11 -0700 (PDT)
Message-Id: <20200901.131111.186993526997490086.davem@davemloft.net>
To:     trix@redhat.com
Cc:     pshelar@ovn.org, kuba@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: openvswitch: pass NULL for unused parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200830212630.32241-1-trix@redhat.com>
References: <20200830212630.32241-1-trix@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 12:54:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: trix@redhat.com
Date: Sun, 30 Aug 2020 14:26:30 -0700

> Passing unused parameters is a waste.

Poorly predicted branches are an even bigger waste.

I'm not a big fan of this change and others have asked for performance
analysis to be performed.

So I'm not applying this as-is, sorry.

It's also not great to see that CLANG can't make use of the caller's
__always_unused directive to guide these warnings.
