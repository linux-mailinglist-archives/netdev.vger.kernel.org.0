Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE0B1E3692
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgE0Dbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0Dbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:31:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B7FC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:31:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D346512796431;
        Tue, 26 May 2020 20:31:42 -0700 (PDT)
Date:   Tue, 26 May 2020 20:31:42 -0700 (PDT)
Message-Id: <20200526.203142.1877841855626818157.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] bnxt_en: Bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
References: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:31:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Mon, 25 May 2020 17:41:16 -0400

> 3 bnxt_en driver fixes, covering a bug in preserving the counters during
> some resets, proper error code when flashing NVRAM fails, and an
> endian bug when extracting the firmware response message length.

Series applied.

> Please also queue these for -stable.  Thanks.

Queued up.

Thanks.
