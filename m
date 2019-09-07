Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D4CAC789
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 18:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394890AbfIGQI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 12:08:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394881AbfIGQIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 12:08:25 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 253F7152F1ADF;
        Sat,  7 Sep 2019 09:08:23 -0700 (PDT)
Date:   Sat, 07 Sep 2019 18:08:22 +0200 (CEST)
Message-Id: <20190907.180822.371453099451603652.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2019-09-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906172339.GA74057@jmoran1-mobl1.ger.corp.intel.com>
References: <20190906172339.GA74057@jmoran1-mobl1.ger.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 09:08:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Fri, 6 Sep 2019 20:23:39 +0300

> Here's the main bluetooth-next pull request for the 5.4 kernel.
> 
>  - Cleanups & fixes to btrtl driver
>  - Fixes for Realtek devices in btusb, e.g. for suspend handling
>  - Firmware loading support for BCM4345C5
>  - hidp_send_message() return value handling fixes
>  - Added support for utilizing Fast Advertising Interval
>  - Various other minor cleanups & fixes
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thanks.
