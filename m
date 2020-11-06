Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0EE2A8BB6
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbgKFA5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:57:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730895AbgKFA5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 19:57:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6398A20759;
        Fri,  6 Nov 2020 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604624240;
        bh=SMBgvJgxq4Qd1nBk3f0m55W6BzphVMhaPyYEVQ5S49g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TkihM0rwqyJppLvF7PaRSpJMgHrUnmEcjFJe3vGYF09IR37/0Rr7C1TcgSzayfuRt
         eLMcXUYXgauhS9wYE5E7yWmhAkZbiHQKlZVe36+pJYdkcOdR1F3FEPZxSZO3C5gR2E
         QeNSJ/dZVMlBTNwhx53ta3Rmv/S3MWDlYEmyOWf4=
Date:   Thu, 5 Nov 2020 16:57:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bbhatt@codeaurora.org,
        willemdebruijn.kernel@gmail.com, jhugo@codeaurora.org,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org
Subject: Re: [PATCH v10 2/2] net: Add mhi-net driver
Message-ID: <20201105165718.3da67bf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604424234-24446-2-git-send-email-loic.poulain@linaro.org>
References: <1604424234-24446-1-git-send-email-loic.poulain@linaro.org>
        <1604424234-24446-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 18:23:54 +0100 Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Applied, thanks!
