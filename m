Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547C5180BF2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCJW6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:58:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgCJW6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:58:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3C0214CCC984;
        Tue, 10 Mar 2020 15:58:21 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:58:21 -0700 (PDT)
Message-Id: <20200310.155821.931371329682717281.davem@davemloft.net>
To:     julietk@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        tlfalcon@linux.vnet.ibm.com
Subject: Re: [PATCH net v2] ibmvnic: Do not process device remove during
 device reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310142358.61392-1-julietk@linux.vnet.ibm.com>
References: <20200310142358.61392-1-julietk@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 15:58:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliet Kim <julietk@linux.vnet.ibm.com>
Date: Tue, 10 Mar 2020 09:23:58 -0500

> The ibmvnic driver does not check the device state when the device
> is removed. If the device is removed while a device reset is being
> processed, the remove may free structures needed by the reset,
> causing an oops.
> 
> Fix this by checking the device state before processing device remove.
> 
> Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>

Applied, thank you.
