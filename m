Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685272699F3
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgINX4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINX4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:56:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1406CC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:56:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0291128D55F1;
        Mon, 14 Sep 2020 16:39:20 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:56:07 -0700 (PDT)
Message-Id: <20200914.165607.482732876476758678.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ionic: fix up debugfs after queue swap
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200913191654.42345-1-snelson@pensando.io>
References: <20200913191654.42345-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:39:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Sun, 13 Sep 2020 12:16:54 -0700

> Clean and rebuild the debugfs info for the queues being swapped.
> 
> Fixes: a34e25ab977c ("ionic: change the descriptor ring length without full reset")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied.
