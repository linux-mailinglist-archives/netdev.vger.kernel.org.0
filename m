Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2541D228CA0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbgGUXTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:19:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA85EC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:19:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 803E311E45904;
        Tue, 21 Jul 2020 16:02:33 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:19:17 -0700 (PDT)
Message-Id: <20200721.161917.1352752521032182959.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/29] l2tp: cleanup checkpatch.pl warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 16:02:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch set is way too large to be reasonably reviewed by other
developers.

Please either find a way to combine some of the patches, or submit
this in stages of about 10 or so patches at a time.

I am not applying this submission as submitted.

Thank you.
