Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5C52581BE
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgHaT1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgHaT1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:27:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DC2C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:27:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 279DB1288BB0D;
        Mon, 31 Aug 2020 12:11:01 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:27:46 -0700 (PDT)
Message-Id: <20200831.122746.488426915962041502.davem@davemloft.net>
To:     bharat@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix thermal zone device registration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200828154440.14231-1-bharat@chelsio.com>
References: <20200828154440.14231-1-bharat@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:11:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>
Date: Fri, 28 Aug 2020 21:14:40 +0530

> When multiple adapters are present in the system, pci hot-removing second
> adapter leads to the following warning as both the adapters registered
> thermal zone device with same thermal zone name/type.
> Therefore, use unique thermal zone name during thermal zone device
> initialization. Also mark thermal zone dev NULL once unregistered.
 ...
> Fixes: b18719157762 ("cxgb4: Add thermal zone support")
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>

Applied, thanks.
