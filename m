Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E304E583B
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 05:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfJZDUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 23:20:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfJZDUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 23:20:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45D6B14B7BF9A;
        Fri, 25 Oct 2019 20:20:06 -0700 (PDT)
Date:   Fri, 25 Oct 2019 20:20:05 -0700 (PDT)
Message-Id: <20191025.202005.1641623026019420756.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2019-10-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023165133.GA98720@amcewan-mobl1.ger.corp.intel.com>
References: <20191023165133.GA98720@amcewan-mobl1.ger.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 20:20:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Wed, 23 Oct 2019 19:51:33 +0300

> Here's the main bluetooth-next pull request for the 5.5 kernel:
> 
>  - Multiple fixes to hci_qca driver
>  - Fix for HCI_USER_CHANNEL initialization
>  - btwlink: drop superseded driver
>  - Add support for Intel FW download error recovery
>  - Various other smaller fixes & improvements
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled into net-next, thanks Johan.
