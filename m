Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A136F228CB0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgGUX0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGUX0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:26:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20550C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:26:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5C6811E45901;
        Tue, 21 Jul 2020 16:09:21 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:26:05 -0700 (PDT)
Message-Id: <20200721.162605.836612752207947766.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     tparkin@katalix.com, netdev@vger.kernel.org
Subject: Re: [PATCH 05/29] l2tp: cleanup difficult-to-read line breaks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721135938.46203a0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
        <20200721173221.4681-6-tparkin@katalix.com>
        <20200721135938.46203a0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 16:09:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 21 Jul 2020 13:59:38 -0700

> Please split this submission into series of at most 15 patches at a
> time, to make sure reviewers don't get overloaded.

+1

