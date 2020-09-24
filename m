Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70B827652F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgIXAfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIXAft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:35:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F4EC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 17:35:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F300911FFD34E;
        Wed, 23 Sep 2020 17:19:01 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:35:48 -0700 (PDT)
Message-Id: <20200923.173548.718160539138134389.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, sgoutham@marvell.com,
        jiri@resnulli.us, sbhatta@marvell.com
Subject: Re: [net-next v3 PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600743425-7851-1-git-send-email-sundeep.lkml@gmail.com>
References: <1600743425-7851-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:19:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sundeep.lkml@gmail.com
Date: Tue, 22 Sep 2020 08:27:03 +0530

> This patchset adds tracepoints support for mailbox.
 ...

Series applied, thank you.
