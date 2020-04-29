Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51201BE72A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgD2TRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2TRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:17:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83001C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 12:17:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06CC3120ED55C;
        Wed, 29 Apr 2020 12:17:34 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:17:34 -0700 (PDT)
Message-Id: <20200429.121734.1396585536089011163.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-stm32@st-md-mailman.stormreply.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/6] stmmac: intel: Fix clock handling on error and
 remove paths
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429145233.81943-1-andriy.shevchenko@linux.intel.com>
References: <20200429145233.81943-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:17:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please re-post this patch series with a proper cover letter.

Thank you.
