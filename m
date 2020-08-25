Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030A6251933
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgHYNH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgHYNH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:07:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28987C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 06:07:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6505511E45763;
        Tue, 25 Aug 2020 05:51:10 -0700 (PDT)
Date:   Tue, 25 Aug 2020 06:07:56 -0700 (PDT)
Message-Id: <20200825.060756.925216680849949992.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: add error handlers to LE intr_handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825035546.18330-1-rajur@chelsio.com>
References: <20200825035546.18330-1-rajur@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 05:51:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>
Date: Tue, 25 Aug 2020 09:25:46 +0530

> cxgb4 does not look for HASHTBLMEMCRCERR and CMDTIDERR
> bits in LE_DB_INT_CAUSE register, but these are enabled
> in LE_DB_INT_ENABLE. So, add error handlers to LE
> interrupt handler to emit a warning or alert message
> for hash table mem crc and cmd tid errors
> 
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>

Applied, thanks.
