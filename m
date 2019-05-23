Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC9C283E2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbfEWQg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:36:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbfEWQg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:36:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EECB21509CAF8;
        Thu, 23 May 2019 09:36:26 -0700 (PDT)
Date:   Thu, 23 May 2019 09:36:26 -0700 (PDT)
Message-Id: <20190523.093626.1602668467328215134.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: use firmware API for validating filter
 spec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523135121.16045-1-rajur@chelsio.com>
References: <20190523135121.16045-1-rajur@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:36:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>
Date: Thu, 23 May 2019 19:21:21 +0530

> Adds support for validating hardware filter spec configured in firmware
> before offloading exact match flows.
> 
> Use the new fw api FW_PARAM_DEV_FILTER_MODE_MASK to read the filter mode
> and mask from firmware. If the api isn't supported, then fall-back to
> older way of reading just the mode from indirect register.
> 
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>

Applied.
