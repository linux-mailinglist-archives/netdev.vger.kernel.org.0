Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15B227B798
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgI1XNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B035EC05BD41
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E27421274F437;
        Mon, 28 Sep 2020 15:47:21 -0700 (PDT)
Date:   Mon, 28 Sep 2020 16:04:08 -0700 (PDT)
Message-Id: <20200928.160408.1850669697500260631.davem@davemloft.net>
To:     ljp@linux.ibm.com
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net] ibmvnic: set up 200GBPS speed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928000625.79280-1-ljp@linux.ibm.com>
References: <20200928000625.79280-1-ljp@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:47:22 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>
Date: Sun, 27 Sep 2020 19:06:25 -0500

> Set up the speed according to crq->query_phys_parms.rsp.speed.
> Fix IBMVNIC_10GBPS typo.
> 
> Fixes: f8d6ae0d27ec ("ibmvnic: Report actual backing device speed and duplex values")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

Applied to net-next.
