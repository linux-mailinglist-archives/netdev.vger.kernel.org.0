Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBFF27BA81
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgI2BxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2BxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:53:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56D1C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:53:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EADEF127C6C37;
        Mon, 28 Sep 2020 18:36:20 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:53:07 -0700 (PDT)
Message-Id: <20200928.185307.2220865578088673746.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] genetlink: add missing kdoc for validation flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929005329.3638695-1-kuba@kernel.org>
References: <20200929005329.3638695-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:36:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 28 Sep 2020 17:53:29 -0700

> Validation flags are missing kdoc, add it.
> 
> Fixes: ef6243acb478 ("genetlink: optionally validate strictly/dumps")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied.
