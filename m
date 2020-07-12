Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28DB21CBDD
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgGLW36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGLW35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:29:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1942C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:29:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76F241284BE86;
        Sun, 12 Jul 2020 15:29:57 -0700 (PDT)
Date:   Sun, 12 Jul 2020 15:29:56 -0700 (PDT)
Message-Id: <20200712.152956.50548795372607752.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net 0/3] bnxt_en: 3 bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
References: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Jul 2020 15:29:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sat, 11 Jul 2020 20:48:22 -0400

> 2 Fixes related to PHY/link settings.  The last one fixes the sizing of
> the completion ring.
> 
> Please also queue for -stable.  Thanks.

Series applied and queued up for -stable, thanks.
