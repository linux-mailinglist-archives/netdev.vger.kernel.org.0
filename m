Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77D41B1A15
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDTXZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDTXZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 19:25:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBF1C061A0E
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 16:25:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E2431278B309;
        Mon, 20 Apr 2020 16:25:10 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:25:09 -0700 (PDT)
Message-Id: <20200420.162509.1724784326946148100.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     opendmb@gmail.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        jeremy.linton@arm.com
Subject: Re: [PATCH v2 0/5] net: bcmgenet: Clean up after ACPI enablement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
References: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 16:25:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 21 Apr 2020 00:51:16 +0300

> ACPI enablement series had missed some clean ups that would have been done
> at the same time. Here are these bits.
> 
> In v2:
> - return dev_dbg() calls to avoid spamming logs when probe is deferred (Florian)
> - added Ack (Florian)
> - combined two, earlier sent, series together
> - added couple more patches

Series applied to net-next, thanks.
