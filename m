Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921791A8C05
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 22:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgDNUNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 16:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2632760AbgDNUMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 16:12:17 -0400
X-Greylist: delayed 85120 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Apr 2020 13:12:17 PDT
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D74C03C1A7
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 13:12:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A1A4127FD184;
        Tue, 14 Apr 2020 13:12:14 -0700 (PDT)
Date:   Tue, 14 Apr 2020 13:12:09 -0700 (PDT)
Message-Id: <20200414.131209.1108253082504989993.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-04-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414153500.E59C9C432C2@smtp.codeaurora.org>
References: <20200414153500.E59C9C432C2@smtp.codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 13:12:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 14 Apr 2020 15:35:00 +0000 (UTC)

> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.

Pulled, thanks Kalle.
