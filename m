Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E31259FCE
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgIAUQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729516AbgIAUP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:15:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5840AC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 13:15:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CEB761364C899;
        Tue,  1 Sep 2020 12:59:10 -0700 (PDT)
Date:   Tue, 01 Sep 2020 13:15:55 -0700 (PDT)
Message-Id: <20200901.131555.825703470553661959.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Harden device Command Response Queue
 handshake
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598893197-14450-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1598893197-14450-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 12:59:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Mon, 31 Aug 2020 11:59:57 -0500

> In some cases, the device or firmware may be busy when the
> driver attempts to perform the CRQ initialization handshake.
> If the partner is busy, the hypervisor will return the H_CLOSED
> return code. The aim of this patch is that, if the device is not
> ready, to query the device a number of times, with a small wait
> time in between queries. If all initialization requests fail,
> the driver will remain in a dormant state, awaiting a signal
> from the device that it is ready for operation.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied to net-next, thank you.
