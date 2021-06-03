Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D56E39AD7B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFCWNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCWNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 18:13:52 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F058C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 15:12:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 9AEF250ABBD6C;
        Thu,  3 Jun 2021 15:12:04 -0700 (PDT)
Date:   Thu, 03 Jun 2021 15:12:01 -0700 (PDT)
Message-Id: <20210603.151201.788489816982757759.davem@davemloft.net>
To:     zhudi21@huawei.com
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, rose.chen@huawei.com
Subject: Re: [PATCH] bonding: 3ad: fix a crash in agg_device_up()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210602124448.49828-1-zhudi21@huawei.com>
References: <20210602124448.49828-1-zhudi21@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 03 Jun 2021 15:12:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please prep[ost with an appropriate Fixes: tag, thanks.
