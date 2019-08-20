Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73CD969A0
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbfHTTmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:42:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730669AbfHTTmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:42:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE2C9146EADFF;
        Tue, 20 Aug 2019 12:42:50 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:42:50 -0700 (PDT)
Message-Id: <20190820.124250.137103175958708086.davem@davemloft.net>
To:     terry.s.duncan@linux.intel.com
Cc:     sam@mendozajonas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        wak@google.com, joel@jms.id.au
Subject: Re: [PATCH v2] net/ncsi: Ensure 32-bit boundary for data cksum
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820002402.39001-1-terry.s.duncan@linux.intel.com>
References: <20190820002402.39001-1-terry.s.duncan@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:42:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Terry S. Duncan" <terry.s.duncan@linux.intel.com>
Date: Mon, 19 Aug 2019 17:24:02 -0700

> The NCSI spec indicates that if the data does not end on a 32 bit
> boundary, one to three padding bytes equal to 0x00 shall be present to
> align the checksum field to a 32-bit boundary.
> 
> Signed-off-by: Terry S. Duncan <terry.s.duncan@linux.intel.com>

Applied.
