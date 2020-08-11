Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D151A241F50
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgHKRfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 13:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbgHKRfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 13:35:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEEDC06174A;
        Tue, 11 Aug 2020 10:35:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40CE012880E8A;
        Tue, 11 Aug 2020 10:18:20 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:35:05 -0700 (PDT)
Message-Id: <20200811.103505.851098966663693876.davem@davemloft.net>
To:     ieatmuttonchuan@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/nfc/rawsock.c: add CAP_NET_RAW check.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200810015100.GA11939@oppo>
References: <20200810015100.GA11939@oppo>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 10:18:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qingyu Li <ieatmuttonchuan@gmail.com>
Date: Mon, 10 Aug 2020 09:51:00 +0800

> When creating a raw AF_NFC socket, CAP_NET_RAW needs to be checked first.
> 
> Signed-off-by: Qingyu Li <ieatmuttonchuan@gmail.com>

Applied and queued up for -stable, thank you.
