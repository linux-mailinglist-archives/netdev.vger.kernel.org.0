Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B553C1DD992
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgEUVit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:38:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E96DC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:38:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02351120ED484;
        Thu, 21 May 2020 14:38:48 -0700 (PDT)
Date:   Thu, 21 May 2020 14:38:48 -0700 (PDT)
Message-Id: <20200521.143848.1063957068392321248.davem@davemloft.net>
To:     vinay.yadav@chelsio.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next] net/tls: fix race condition causing kernel
 panic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bbcfb6c7-8e98-63a1-4ff6-d185bdcf4708@chelsio.com>
References: <0a5d0864-2830-6bc8-05e8-232d10c0f333@chelsio.com>
        <20200521115623.134eeb83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bbcfb6c7-8e98-63a1-4ff6-d185bdcf4708@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 14:38:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Date: Fri, 22 May 2020 01:54:25 +0530

> I am explaining that your scenario is covered in this fix.

Please change your commit message to be more readable in this way,
thank you.
