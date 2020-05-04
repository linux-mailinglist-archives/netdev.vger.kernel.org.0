Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A1F1C45B3
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbgEDSWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729958AbgEDSWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:22:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA24C061A0E;
        Mon,  4 May 2020 11:22:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DC83120ED540;
        Mon,  4 May 2020 11:22:04 -0700 (PDT)
Date:   Mon, 04 May 2020 11:22:03 -0700 (PDT)
Message-Id: <20200504.112203.513284964071545941.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net] s390/qeth: fix cancelling of TX timer on
 dev_close()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504173942.69298-1-jwi@linux.ibm.com>
References: <20200504173942.69298-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:22:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon,  4 May 2020 19:39:42 +0200

> With the introduction of TX coalescing, .ndo_start_xmit now potentially
> starts the TX completion timer. So only kill the timer _after_ TX has
> been disabled.
> 
> Fixes: ee1e52d1e4bb ("s390/qeth: add TX IRQ coalescing support for IQD devices")
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied, thanks Julian.
