Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0150C22D292
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgGYABJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGYABJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:01:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D4FC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:01:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3F3A12756FEB;
        Fri, 24 Jul 2020 16:44:23 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:01:08 -0700 (PDT)
Message-Id: <20200724.170108.362782113011946610.davem@davemloft.net>
To:     ayush.sawal@chelsio.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        secdev@chelsio.com, lkp@intel.com
Subject: Re: [PATCH net V2] Crypto/chcr: Registering cxgb4 to xfrmdev_ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724084124.21651-1-ayush.sawal@chelsio.com>
References: <20200724084124.21651-1-ayush.sawal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:44:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please start submitting chcr patches to the crypto subsystem, where it
belongs, instead of the networking GIT trees.

This has been going on for far too long.

Thank you.
