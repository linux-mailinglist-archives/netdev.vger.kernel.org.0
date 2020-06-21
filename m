Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262D9202798
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgFUA24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgFUA2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:28:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B9AC061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 17:28:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00BC9120ED49C;
        Sat, 20 Jun 2020 17:28:54 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:28:53 -0700 (PDT)
Message-Id: <20200620.172853.1111095592646261177.davem@davemloft.net>
To:     drt@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        tlfalcon@linux.ibm.com
Subject: Re: [PATCH net] ibmvnic: continue to init in CRQ reset returns
 H_CLOSED
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618192413.853441-1-drt@linux.ibm.com>
References: <20200618192413.853441-1-drt@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:28:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>
Date: Thu, 18 Jun 2020 15:24:13 -0400

> Continue the reset path when partner adapter is not ready or H_CLOSED is
> returned from reset crq. This patch allows the CRQ init to proceed to
> establish a valid CRQ for traffic to flow after reset.
> 
> Signed-off-by: Dany Madden <drt@linux.ibm.com>

Applied, thanks.
