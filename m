Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E72233C41
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbgG3Xpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730810AbgG3Xps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:45:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794F4C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:45:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F24AF126C0517;
        Thu, 30 Jul 2020 16:29:02 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:45:47 -0700 (PDT)
Message-Id: <20200730.164547.2032615389990777256.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH 0/6] l2tp: tidy up l2tp core API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728172033.19532-1-tparkin@katalix.com>
References: <20200728172033.19532-1-tparkin@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:29:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Parkin <tparkin@katalix.com>
Date: Tue, 28 Jul 2020 18:20:27 +0100

> This short series makes some minor tidyup changes to the L2TP core API.

Series applied, thank you.
