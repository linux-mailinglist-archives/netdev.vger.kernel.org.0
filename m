Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E292571C8
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 04:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgHaCSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 22:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgHaCSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 22:18:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAFBC061573;
        Sun, 30 Aug 2020 19:18:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C76EF1365302E;
        Sun, 30 Aug 2020 19:01:34 -0700 (PDT)
Date:   Sun, 30 Aug 2020 19:18:20 -0700 (PDT)
Message-Id: <20200830.191820.830855123656127012.davem@davemloft.net>
To:     deesin@codeaurora.org
Cc:     bjorn.andersson@linaro.org, clew@codeaurora.org,
        mathieu.poirier@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, manivannan.sadhasivam@linaro.org,
        cjhuang@codeaurora.org, necip@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH V1 1/4] net: qrtr: Do not send packets before hello
 negotiation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598798292-5971-2-git-send-email-deesin@codeaurora.org>
References: <1598798292-5971-1-git-send-email-deesin@codeaurora.org>
        <1598798292-5971-2-git-send-email-deesin@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 30 Aug 2020 19:01:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


A proper patch series must provide a header "[PATCH 0/N ..." posting which
explains what the patch series does, at a high level, how it does it, and
why it does it that way.

You must also explicitly state the target GIT tree your changes are for
in the subject line, f.e. "[PATCH net-next M/N] ..."

I'm sorry I have to be strict about this but it is very important for
reviewers, and anyone looking at these changes in the future, to have
this summary information.

Thank you.
