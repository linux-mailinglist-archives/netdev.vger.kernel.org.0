Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACCB2650F4
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgIJUgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgIJUbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:31:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6683DC0613ED;
        Thu, 10 Sep 2020 13:31:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97A0C134A573D;
        Thu, 10 Sep 2020 13:14:47 -0700 (PDT)
Date:   Thu, 10 Sep 2020 13:31:33 -0700 (PDT)
Message-Id: <20200910.133133.1446679823351648711.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net] s390/qeth: delay draining the TX buffers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910090518.71420-1-jwi@linux.ibm.com>
References: <20200910090518.71420-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 13:14:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 10 Sep 2020 11:05:18 +0200

> Wait until the QDIO data connection is severed. Otherwise the device
> might still be processing the buffers, and end up accessing skb data
> that we already freed.
> 
> Fixes: 8b5026bc1693 ("s390/qeth: fix qdio teardown after early init error")
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied.
