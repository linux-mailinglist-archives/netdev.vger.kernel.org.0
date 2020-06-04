Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832C71EEE16
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 01:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgFDXDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 19:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgFDXDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 19:03:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E18C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 16:03:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F22BB11F5F8D1;
        Thu,  4 Jun 2020 16:03:32 -0700 (PDT)
Date:   Thu, 04 Jun 2020 16:03:32 -0700 (PDT)
Message-Id: <20200604.160332.1839771487590400798.davem@davemloft.net>
To:     pavel@ucw.cz
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] net/xdp: use shift instead of 64 bit division
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200604214259.GA10835@amd>
References: <20200604214259.GA10835@amd>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 16:03:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>
Date: Thu, 4 Jun 2020 23:42:59 +0200

> 64bit division is kind of expensive, and shift should do the job here.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

I'll take this, applied, thanks.
