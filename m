Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBC3183CC5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgCLWsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:48:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36106 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgCLWsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:48:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9891315842613;
        Thu, 12 Mar 2020 15:48:53 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:48:52 -0700 (PDT)
Message-Id: <20200312.154852.115271760293062652.davem@davemloft.net>
To:     elder@linaro.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] net: fix net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312164428.18132-1-elder@linaro.org>
References: <20200312164428.18132-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:48:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Thu, 12 Mar 2020 11:44:26 -0500

> David:	These patches resolve two issues caused by the IPA driver
> 	being incorporated into net-next.  I hope you will merge
> 	them as soon as you can.
> 
> The IPA driver was merged into net-next last week, but two problems
> arise as a result, affecting net-next and linux-next:
>   - The patch that defines field_max() was not incorporated into
>     net-next, but is required by the IPA code
>   - A patch that updates "sdm845.dtsi" *was* incorporated into
>     net-next, but other changes to that file in the Qualcomm
>     for-next branch lead to errors
> 
> Bjorn has agreed to incorporate the DTS file change into the
> Qualcomm tree after it is reverted from net-next.

Series applied, thanks Alex.
