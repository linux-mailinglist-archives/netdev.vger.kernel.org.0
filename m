Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4336912B9
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfHQTiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:38:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55546 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfHQTiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 15:38:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 61C7714DB6E0E;
        Sat, 17 Aug 2019 12:38:24 -0700 (PDT)
Date:   Sat, 17 Aug 2019 12:38:23 -0700 (PDT)
Message-Id: <20190817.123823.1974759125906714403.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth 2019-08-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190817114451.GA10661@abukhnin-mobl1.ccr.corp.intel.com>
References: <20190817114451.GA10661@abukhnin-mobl1.ccr.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 17 Aug 2019 12:38:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Sat, 17 Aug 2019 14:44:51 +0300

> Here's a set of Bluetooth fixes for the 5.3-rc series:
> 
>  - Multiple fixes for Qualcomm (btqca & hci_qca) drivers
>  - Minimum encryption key size debugfs setting (this is required for
>    Bluetooth Qualification)
>  - Fix hidp_send_message() to have a meaningful return value

Pulled, thanks.
