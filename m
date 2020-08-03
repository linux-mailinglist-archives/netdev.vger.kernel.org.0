Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A7023B0D5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgHCXSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729028AbgHCXSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:18:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA00AC06174A;
        Mon,  3 Aug 2020 16:18:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA6961277C97D;
        Mon,  3 Aug 2020 16:02:07 -0700 (PDT)
Date:   Mon, 03 Aug 2020 16:18:52 -0700 (PDT)
Message-Id: <20200803.161852.1328879920773355611.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2020-08-02
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200802190136.CB524C433CA@smtp.codeaurora.org>
References: <20200802190136.CB524C433CA@smtp.codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 16:02:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Sun,  2 Aug 2020 19:01:36 +0000 (UTC)

> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.

There are many several non-trivial mt76 conflicts, can you please sort
this out and send me another pull request?

Thank you.

