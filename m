Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1245F2581A7
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgHaTUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgHaTUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:20:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CEEC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:20:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A701F1287951F;
        Mon, 31 Aug 2020 12:03:46 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:20:32 -0700 (PDT)
Message-Id: <20200831.122032.1065993579056448667.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ionic: fix txrx work accounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827234422.47351-1-snelson@pensando.io>
References: <20200827234422.47351-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:03:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 27 Aug 2020 16:44:22 -0700

> Take the tx accounting out of the work_done calculation to
> prevent a possible duplicate napi_schedule call when under
> high Tx stress but low Rx traffic.
> 
> Fixes: b14e4e95f9ec ("ionic: tx separate servicing")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thank you.
