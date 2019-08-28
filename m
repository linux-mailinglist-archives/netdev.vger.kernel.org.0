Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB16A0E21
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfH1XRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:17:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38656 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfH1XRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:17:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5FE10153B3159;
        Wed, 28 Aug 2019 16:17:38 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:17:35 -0700 (PDT)
Message-Id: <20190828.161735.1528060932193718727.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 0/2] r8152: fix side effect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-323-Taiwan-albertk@realtek.com>
References: <1394712342-15778-314-Taiwan-albertk@realtek.com>
        <1394712342-15778-323-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 16:17:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 28 Aug 2019 20:56:11 +0800

> v4:
> Add Fixes tag for both patch #1 and #2.

I applied v3, sorry.

I think it is OK as I will backport things to v5.2 -stable anyways.
