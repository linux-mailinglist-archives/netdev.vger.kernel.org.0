Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7C42A8BBE
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 02:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbgKFBA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 20:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgKFBA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 20:00:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86FEA20782;
        Fri,  6 Nov 2020 01:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604624426;
        bh=Qh4FnoRV8X4BbV/hbtbCWzunfO90hTzfmBC2bEirE98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qkcsy+0xEeI6F3HLonUPz2IEYnsH4fRrzUAxzw275JmjKrotiJ6SPEg2AhTBv2Sav
         +WxPIObH7JafBnFDoYZX2Xvs89OOLeRS9tdFFWT/ZNVD6HlpqqSyZX9wniJK5C2e1M
         56c6hcuirFMf1LkA6InWXSo9s4G1w72oHWsE0DNU=
Date:   Thu, 5 Nov 2020 17:00:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <oliver@neukum.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next v2 RESEND] net/usb/r8153_ecm: support ECM mode
 for RTL8153
Message-ID: <20201105170025.5dc759bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1394712342-15778-392-Taiwan-albertk@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
        <1394712342-15778-392-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 10:19:22 +0800 Hayes Wang wrote:
> Support ECM mode based on cdc_ether with relative mii functions,
> when CONFIG_USB_RTL8152 is not set, or the device is not supported
> by r8152 driver.
> 
> Both r8152 and r8153_ecm would check the return value of
> rtl8152_get_version() in porbe(). If rtl8152_get_version()
> return none zero value, the r8152 is used for the device
> with vendor mode. Otherwise, the r8153_ecm is used for the
> device with ECM mode.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks!
