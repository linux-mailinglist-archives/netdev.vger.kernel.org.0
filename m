Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C042C4B0C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgKYWtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgKYWtt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 17:49:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4810E206B5;
        Wed, 25 Nov 2020 22:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606344588;
        bh=pSwzmADV8n/fwPAEtTEdljijLDkC5AaVd7b5eRJz7kw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NVshRww8RSmR53fWQHr9nVGFR0OAiFQZf5nE7c/qOfh0unY+61ulBL4XPvB9eTfVq
         juSktOR7bVyLXi8g5ePrYXUt09kPQ04eCiM4kTkeOS2P3fY9FSrWwy1UOHwcqlpt2v
         Jr4LHrf3jdiBrNVTk0dXagfe6W3QH4Uj07lpsz68=
Date:   Wed, 25 Nov 2020 14:49:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@ieee.org>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] soc: qcom: ipa: Constify static qmi
 structs
Message-ID: <20201125144947.685a0f14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ee9dfc18-092e-6a5c-d310-d4ce52db6042@ieee.org>
References: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
        <20201122234031.33432-2-rikard.falkeborn@gmail.com>
        <ee9dfc18-092e-6a5c-d310-d4ce52db6042@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 15:45:05 -0600 Alex Elder wrote:
> On 11/22/20 5:40 PM, Rikard Falkeborn wrote:
> > These are only used as input arguments to qmi_handle_init() which
> > accepts const pointers to both qmi_ops and qmi_msg_handler. Make them
> > const to allow the compiler to put them in read-only memory.
> > 
> > Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>  
> 
> Acked-by: Alex Elder <elder@linaro.org>

Applied to net-next, thanks!
