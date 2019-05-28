Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CFF2C59B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfE1LmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:42:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59732 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfE1LmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:42:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4275460A50; Tue, 28 May 2019 11:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559043726;
        bh=MHkc4Q+Ua/ipwQsrGjiqtzVzC/Fa0jKvnftGnfpruS4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nj8Y8SnPzLatGKnAwSYd7f0EePv9DTETXIU6WU9xXJzWhF2+emWDwRNceydtDhqXt
         6igeX9sz7Sz6WSVYAW6AjnVd+zfGIzI+yGOFwHlvfJw6+XRfFW658D5tqmDp6KH5zn
         ovJMLHOi8T9cEyvLA8BPdcaKzKMotNRddoRfwgbg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1ACD160DA8;
        Tue, 28 May 2019 11:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559043725;
        bh=MHkc4Q+Ua/ipwQsrGjiqtzVzC/Fa0jKvnftGnfpruS4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XBEEU4W3ilj2YzOEF6z3Tkk7zWxbXEOBFzGBbw3YNYo+Dc69+Kdbl6tJ+DSLoBQtu
         wn6JFsOAhkOTT2eDY+sDIputj7T1rBn9K3i3fpQtPMG8tOAivrNGzRkQoafIASZAyx
         CQDfUHCMZefcbbO4opswt5/Zp1xv6yw66slaiY7M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1ACD160DA8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: Make some symbols static
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190504103224.27524-1-yuehaibing@huawei.com>
References: <20190504103224.27524-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <yhchuang@realtek.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528114206.4275460A50@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 11:42:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fix sparse warnings:
> 
> drivers/net/wireless/realtek/rtw88/phy.c:851:4: warning: symbol 'rtw_cck_size' was not declared. Should it be static?
> drivers/net/wireless/realtek/rtw88/phy.c:852:4: warning: symbol 'rtw_ofdm_size' was not declared. Should it be static?
> drivers/net/wireless/realtek/rtw88/phy.c:853:4: warning: symbol 'rtw_ht_1s_size' was not declared. Should it be static?
> drivers/net/wireless/realtek/rtw88/phy.c:854:4: warning: symbol 'rtw_ht_2s_size' was not declared. Should it be static?
> drivers/net/wireless/realtek/rtw88/phy.c:855:4: warning: symbol 'rtw_vht_1s_size' was not declared. Should it be static?
> drivers/net/wireless/realtek/rtw88/phy.c:856:4: warning: symbol 'rtw_vht_2s_size' was not declared. Should it be static?
> drivers/net/wireless/realtek/rtw88/fw.c:11:6: warning: symbol 'rtw_fw_c2h_cmd_handle_ext' was not declared. Should it be static?
> drivers/net/wireless/realtek/rtw88/fw.c:50:6: warning: symbol 'rtw_fw_send_h2c_command' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers.git, thanks.

6aca09771db4 rtw88: Make some symbols static

-- 
https://patchwork.kernel.org/patch/10929669/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

