Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC20CA9AAE
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 08:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbfIEGco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 02:32:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42234 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731393AbfIEGco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 02:32:44 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DBE21537E16E;
        Wed,  4 Sep 2019 23:32:42 -0700 (PDT)
Date:   Wed, 04 Sep 2019 23:32:41 -0700 (PDT)
Message-Id: <20190904.233241.1475555883789110602.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth 2019-09-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905061444.GA47480@blobacz-mobl.ger.corp.intel.com>
References: <20190905061444.GA47480@blobacz-mobl.ger.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 23:32:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Thu, 5 Sep 2019 09:14:44 +0300

> Here are a few more Bluetooth fixes for 5.3. I hope they can still make
> it. There's one USB ID addition for btusb, two reverts due to discovered
> regressions, and two other important fixes.
> 
> Please let me know if there any issues pulling. Thanks.

Pulled, thanks.
