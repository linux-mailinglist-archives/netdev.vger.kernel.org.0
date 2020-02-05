Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B288153153
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgBEM5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:57:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbgBEM5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 07:57:33 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CFED3158E2101;
        Wed,  5 Feb 2020 04:57:32 -0800 (PST)
Date:   Wed, 05 Feb 2020 13:57:31 +0100 (CET)
Message-Id: <20200205.135731.2024737227568866903.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v1] net: dsa: b53: Platform data shan't include kernel.h
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204161439.28385-1-andriy.shevchenko@linux.intel.com>
References: <20200204161439.28385-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 04:57:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue,  4 Feb 2020 18:14:39 +0200

> Replace with appropriate types.h.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied, thank you.
