Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75EE18297B
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388012AbgCLHGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:06:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56520 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387959AbgCLHGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 03:06:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6E2314E2AFDC;
        Thu, 12 Mar 2020 00:05:59 -0700 (PDT)
Date:   Thu, 12 Mar 2020 00:05:59 -0700 (PDT)
Message-Id: <20200312.000559.707225825210372525.davem@davemloft.net>
To:     elder@linaro.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        bjorn.andersson@linaro.org, agross@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: soc: qcom: fix IPA binding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311214700.700-1-elder@linaro.org>
References: <20200311214700.700-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 00:06:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Wed, 11 Mar 2020 16:47:00 -0500

> The definitions for the "qcom,smem-states" and "qcom,smem-state-names"
> properties need to list their "$ref" under an "allOf" keyword.
> 
> In addition, fix two problems in the example at the end:
>   - Use #include for header files that define needed symbolic values
>   - Terminate the line that includes the "ipa-shared" register space
>     name with a comma rather than a semicolon
> 
> Finally, update some white space in the example for better alignment.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied to net-next, thanks Alex.
