Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9153F184E91
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCMSZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:25:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgCMSZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:25:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 207BC159D338F;
        Fri, 13 Mar 2020 11:25:25 -0700 (PDT)
Date:   Fri, 13 Mar 2020 11:25:24 -0700 (PDT)
Message-Id: <20200313.112524.278974546399568453.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: ipa: build IPA when COMPILE_TEST is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313121126.7825-1-elder@linaro.org>
References: <20200313121126.7825-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 11:25:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Fri, 13 Mar 2020 07:11:26 -0500

> Make CONFIG_QCOM_IPA optionally dependent on CONFIG_COMPILE_TEST.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> 
> David, this implements a suggestion made by Jakub Kicinski.  I tested
> it with GCC 9.2.1 for x86 and found no errors or warnings in the IPA
> code.  It is the last IPA change I plan to make for v5.7.
> 
> Once reviewed and found acceptable, it should go through net-next.

When I try to use this I end up with the following Kconfig warnings:

WARNING: unmet direct dependencies detected for QCOM_SCM
  Depends on [n]: ARM || ARM64
  Selected by [m]:
  - QCOM_MDT_LOADER [=m]

So this needs more work.

