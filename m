Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB27324A97E
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHSWin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSWin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:38:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F909C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:38:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8DAF111E4576A;
        Wed, 19 Aug 2020 15:21:55 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:38:41 -0700 (PDT)
Message-Id: <20200819.153841.119397707962960845.davem@davemloft.net>
To:     cforno12@linux.ibm.com
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com
Subject: Re: [PATCH, net-next, v3] ibmvnic: store RX and TX subCRQ handle
 array in ibmvnic_adapter struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819181623.57821-1-cforno12@linux.ibm.com>
References: <20200819181623.57821-1-cforno12@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 15:21:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristobal Forno <cforno12@linux.ibm.com>
Date: Wed, 19 Aug 2020 13:16:23 -0500

> Currently the driver reads RX and TX subCRQ handle array directly from
> a DMA-mapped buffer address when it needs to make a H_SEND_SUBCRQ
> hcall. This patch stores that information in the ibmvnic_sub_crq_queue
> structure instead of reading from the buffer received at login. The
> overall goal of this patch is to parse relevant information from the
> login response buffer and store it in the driver's private data
> structures so that we don't need to read directly from the buffer and
> can then free up that memory.
> 
> Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>

Applied, thanks everyone.
