Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565E486F27
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405296AbfHIBMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:12:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404550AbfHIBMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:12:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2412814254E0D;
        Thu,  8 Aug 2019 18:12:34 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:12:33 -0700 (PDT)
Message-Id: <20190808.181233.1012759145511078443.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cxgb4: smt: Add lock for atomic_dec_and_test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806025846.17022-1-hslester96@gmail.com>
References: <20190806025846.17022-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:12:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Tue,  6 Aug 2019 10:58:46 +0800

> The atomic_dec_and_test() is not safe because it is
> outside of locks.
> Move the locks of t4_smte_free() to its caller,
> cxgb4_smt_release() to protect the atomic decrement.
> 
> Fixes: 3bdb376e6944 ("cxgb4: introduce SMT ops to prepare for SMAC rewrite support")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied.
