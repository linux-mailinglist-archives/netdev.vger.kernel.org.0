Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102481876F8
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733152AbgCQAib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:38:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50258 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbgCQAia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:38:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB55315796815;
        Mon, 16 Mar 2020 17:38:28 -0700 (PDT)
Date:   Mon, 16 Mar 2020 17:38:28 -0700 (PDT)
Message-Id: <20200316.173828.1870893600981787445.davem@davemloft.net>
To:     elder@linaro.org
Cc:     ohad@wizery.com, bjorn.andersson@linaro.org,
        linux-remoteproc@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] remoteproc: clean up notification config
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316225121.29905-1-elder@linaro.org>
References: <20200316225121.29905-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 17:38:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon, 16 Mar 2020 17:51:21 -0500

> Rearrange the config files for remoteproc and IPA to fix their
> interdependencies.
> 
> First, have CONFIG_QCOM_Q6V5_MSS select QCOM_Q6V5_IPA_NOTIFY so the
> notification code is built regardless of whether IPA needs it.
> 
> Next, represent QCOM_IPA as being dependent on QCOM_Q6V5_MSS rather
> than setting its value to match QCOM_Q6V5_COMMON (which is selected
> by QCOM_Q6V5_MSS).
> 
> Drop all dependencies from QCOM_Q6V5_IPA_NOTIFY.  The notification
> code will be built whenever QCOM_Q6V5_MSS is set, and it has no other
> dependencies.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: - Fix subject line
>     - Incorporate a change I thought I had already squashed

Applied to net-next, thanks.
