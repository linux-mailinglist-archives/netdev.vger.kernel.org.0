Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF931C9C30
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgEGUVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728531AbgEGUVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:21:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33D9C05BD43;
        Thu,  7 May 2020 13:21:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DABA611950516;
        Thu,  7 May 2020 13:21:36 -0700 (PDT)
Date:   Thu, 07 May 2020 13:21:36 -0700 (PDT)
Message-Id: <20200507.132136.2063178280963548327.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clew@codeaurora.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Add QRTR MHI client driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507125306.32157-1-manivannan.sadhasivam@linaro.org>
References: <20200507125306.32157-1-manivannan.sadhasivam@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:21:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Thu,  7 May 2020 18:23:04 +0530

> Here is the series adding MHI client driver support to Qualcomm IPC router
> protocol. MHI is a newly added bus to kernel which is used to communicate to
> external modems over a physical interface like PCI-E. This driver is used to
> transfer the QMI messages between the host processor and external modems over
> the "IPCR" channel.
> 
> For QRTR, this driver is just another driver acting as a transport layer like
> SMD.
> 
> Currently this driver is needed to control the QCA6390 WLAN device from ath11k.
> The ath11k MHI controller driver will take care of booting up QCA6390 and
> bringing it to operating state. Later, this driver will be used to transfer QMI
> messages over the MHI-IPCR channel.
> 
> The second patch of this series removes the ARCH_QCOM dependency for QRTR. This
> is needed because the QRTR driver will be used with x86 machines as well to talk
> to devices like QCA6390.

Series applied to net-next, thanks.
