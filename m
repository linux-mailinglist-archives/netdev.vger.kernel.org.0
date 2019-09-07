Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED98DAC747
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404242AbfIGPhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:37:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfIGPhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:37:17 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D524152EFC42;
        Sat,  7 Sep 2019 08:37:15 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:37:14 +0200 (CEST)
Message-Id: <20190907.173714.1400426487600521308.davem@davemloft.net>
To:     julietk@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] net/ibmvnic: free reset work of removed device from
 queue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905213001.19818-1-julietk@linux.vnet.ibm.com>
References: <20190905213001.19818-1-julietk@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:37:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliet Kim <julietk@linux.vnet.ibm.com>
Date: Thu,  5 Sep 2019 17:30:01 -0400

> Commit 36f1031c51a2 ("ibmvnic: Do not process reset during or after
>  device removal") made the change to exit reset if the driver has been
> removed, but does not free reset work items of the adapter from queue.
> 
> Ensure all reset work items are freed when breaking out of the loop early.
> 
> Fixes: 36f1031c51a2 ("ibmnvic: Do not process reset during or after
> device removal”)

Please do not break up Fixes: tags into mutliple lines, also please do
not put an empty line between the Fixes: tag and other tags like the
Signed-off-by:

> Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>

Applied, thanks.
