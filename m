Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346963B0B06
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhFVRFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhFVRFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:05:03 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6593C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:02:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 8736D4FE766CB;
        Tue, 22 Jun 2021 10:02:46 -0700 (PDT)
Date:   Tue, 22 Jun 2021 10:02:42 -0700 (PDT)
Message-Id: <20210622.100242.807992618453242367.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     lkp@intel.com, netdev@vger.kernel.org, kuba@kernel.org,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [PATCH net-next 06/14] sctp: do the basic send and recv for
 PLPMTUD probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CADvbK_dCgaqrr=pxZGfBmm=3m31+eKgcfkU7AowFbnZAcC92bQ@mail.gmail.com>
References: <66a73fb28cc8175ac80735f6301110b952f6e139.1624239422.git.lucien.xin@gmail.com>
        <202106211151.QDS54KHu-lkp@intel.com>
        <CADvbK_dCgaqrr=pxZGfBmm=3m31+eKgcfkU7AowFbnZAcC92bQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 22 Jun 2021 10:02:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 21 Jun 2021 21:13:59 -0400

> This is a "set but not used" warning, I can fix it after.

Please fix it now and respin, thank you.
