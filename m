Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E81340A84
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhCRQs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhCRQsE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 12:48:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EB2164ED2;
        Thu, 18 Mar 2021 16:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616086084;
        bh=ZeJvzL0vT2IJ7cfLa2bAeVrS54Te1QFxeY7TwGEP5Bk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NRgj7evmowjVNux8MXfQR+ZSLAhkoMNtvxZqFUpStE5z5zXIIHNlJyyFDVB3C7Tl6
         xBaESROMXefYXfQoEnio1AuFp5EVES2ENroIXoqcWQ932lOdSEgj5SvTNQPM6WFzL5
         QX0kYh/GK+pi6DS6yCW0CHuOlYBAQQGMnKE2YEqBHkinS1yW7yQh1cIj/qaDEVc313
         hMvv93o7pa569C9YP+ZJorgFIPs+H+5wZU/CR58CVeVyXLlzVer7qY3HpLLV8S6mD6
         R2Fd6VxhxEmGfZ4WoIRRnI/wtEIuXMSgQczJRgxrqKTjawP7HsR4FIarN6hC6wgSLj
         YwV/UXMQcrXyA==
Date:   Thu, 18 Mar 2021 22:18:00 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andy Gross <agross@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] qcom: wcnss: Allow overriding firmware form DT
Message-ID: <YFOEQDZ5G6HOS3O9@vkoul-mobl.Dlink>
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11-03-21, 16:33, Bjorn Andersson wrote:
> The wireless subsystem found in Qualcomm MSM8974 and MSM8916 among others needs
> platform-, and perhaps even board-, specific firmware. Add support for
> providing this in devicetree.

Reviewed-by: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
