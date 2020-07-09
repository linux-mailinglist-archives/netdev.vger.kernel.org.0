Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672B321A847
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgGIT7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgGIT7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:59:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7752C08C5DC
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:59:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 43C10120ED499;
        Thu,  9 Jul 2020 12:59:43 -0700 (PDT)
Date:   Thu, 09 Jul 2020 12:59:42 -0700 (PDT)
Message-Id: <20200709.125942.1978983820858170955.davem@davemloft.net>
To:     cforno12@linux.ibm.com
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH, v2] ibmvnic: store RX and TX subCRQ handle array in
 ibmvnic_adapter struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200709193756.37374-1-cforno12@linux.ibm.com>
References: <20200709193756.37374-1-cforno12@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 12:59:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristobal Forno <cforno12@linux.ibm.com>
Date: Thu,  9 Jul 2020 14:37:56 -0500

> Currently the driver reads RX and TX subCRQ handle array directly from
> a DMA-mapped buffer address when it needs to make a H_SEND_SUBCRQ
> hcall. This patch stores that information in the ibmvnic_sub_crq_queue
> structure instead of reading from the buffer received at login.
> 
> Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>

Why?  Please explain why you want to do this.

Also, this is a cleanup or a refactoring, not a bug fix.  So you should
target this at the 'net-next' tree and explicitly indicate this in
your Subject line inside the [] brackets.
