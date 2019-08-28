Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE21A0DB8
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfH1WqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:46:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1WqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:46:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A3E8153ACD7F;
        Wed, 28 Aug 2019 15:46:07 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:46:00 -0700 (PDT)
Message-Id: <20190828.154600.1302004323162882858.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net] ibmvnic: Do not process reset during or after
 device removal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566922204-8770-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1566922204-8770-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 15:46:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Tue, 27 Aug 2019 11:10:04 -0500

> Currently, the ibmvnic driver will not schedule device resets
> if the device is being removed, but does not check the device
> state before the reset is actually processed. This leads to a race
> where a reset is scheduled with a valid device state but is
> processed after the driver has been removed, resulting in an oops.
> 
> Fix this by checking the device state before processing a queued
> reset event.
> 
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied.
