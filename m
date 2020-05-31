Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B7F1E94E1
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 03:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgEaBMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 21:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgEaBMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 21:12:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15FFC03E969;
        Sat, 30 May 2020 18:12:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AAE2C128E10C8;
        Sat, 30 May 2020 18:12:05 -0700 (PDT)
Date:   Sat, 30 May 2020 18:12:04 -0700 (PDT)
Message-Id: <20200530.181204.1805037250596208281.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next] net/smc: pre-fetch send buffer outside of
 send_lock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530144237.15883-1-kgraul@linux.ibm.com>
References: <20200530144237.15883-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 18:12:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Sat, 30 May 2020 16:42:37 +0200

> Pre-fetch send buffer for the CDC validation message before entering the
> send_lock. Without that the send call might fail with -EBUSY because
> there are no free buffers and waiting for buffers is not possible under
> send_lock.
> 
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>

Applied, thanks.
