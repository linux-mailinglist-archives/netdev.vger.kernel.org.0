Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371C43B8004
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 11:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbhF3Jeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 05:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhF3Jeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 05:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 842A061CAD;
        Wed, 30 Jun 2021 09:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625045528;
        bh=8YJYFKzB2AT2uOR9CHZEybHLUKDHBfO6khuujKOP3Vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rVcI3USRtpKoFJGyIvhv5nL5zicxzixTuxJHMnydaNTJnNmhAPtYZJxr0dVXNrOym
         /2nua1i4shHi0HXlvDHGzwjzfkGTnNEENedNl5yjRRQAFUxkDhFQAiVjtRv15hdoFF
         ZJmjrIEa171F+cyHzm0K5mxwZKhAm/DbvIoVaFhA=
Date:   Wed, 30 Jun 2021 11:32:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     mohammad.athari.ismail@intel.com
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: Terminate FPE workqueue in suspend
Message-ID: <YNw6Fm/bxum6Diiy@kroah.com>
References: <20210630091754.23423-1-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630091754.23423-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 05:17:54PM +0800, mohammad.athari.ismail@intel.com wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> Add stmmac_fpe_stop_wq() in stmmac_suspend() to terminate FPE workqueue
> during suspend. So, in suspend mode, there will be no FPE workqueue
> available. Without this fix, new additional FPE workqueue will be created
> in every suspend->resume cycle.
> 
> Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner hand-shaking procedure")
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
