Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11A11E1898
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388266AbgEZAzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388013AbgEZAze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 20:55:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D88C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 17:55:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 743F31279A98A;
        Mon, 25 May 2020 17:55:34 -0700 (PDT)
Date:   Mon, 25 May 2020 17:55:33 -0700 (PDT)
Message-Id: <20200525.175533.893027168996530485.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, mlichvar@redhat.com,
        john.stultz@linaro.org, vincent.cheng.xh@renesas.com
Subject: Re: [PATCH net-next V2] Let the ADJ_OFFSET interface respect the
 ADJ_NANO flag for PHC devices.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200524182710.576-1-richardcochran@gmail.com>
References: <20200524182710.576-1-richardcochran@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 17:55:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Sun, 24 May 2020 11:27:10 -0700

> In commit 184ecc9eb260d5a3bcdddc5bebd18f285ac004e9 ("ptp: Add adjphase
> function to support phase offset control.") the PTP Hardware Clock
> interface expanded to support the ADJ_OFFSET offset mode.  However,
> the implementation did not respect the traditional yet pedantic
> distinction between units of microseconds and nanoseconds signaled by
> the ADJ_NANO flag.  This patch fixes the issue by adding logic to
> handle that flag.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Applied, thanks Richard.
