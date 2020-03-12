Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C541839C9
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCLTsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:48:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37417 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLTsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:48:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id a141so7757855wme.2;
        Thu, 12 Mar 2020 12:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=My5hy+eOd+BUGnLYjJSbZOd3nYUzutH2HG2GVn4YySU=;
        b=AiSzVoHTgqpa1qac7d9U8arGecyjIGMg3cTXGJ8wlp5G007Eidw4MQ8r10C+dZx7vU
         waJujvvQ3bbzCUvTunqQ7YHn/yXmeCwHKzYquSTivGPIZU/5BVFq27lEdMg2Pim1oIEL
         0v8QKp1y6Q4deCwbn9he07U2CRFUHo0ve8poxzPjPbf1ZeF3OgfahrX3tA3YGkXDHK6c
         r6uBPe53trUhQ+DJ13jQPSNIDUR1xKpxwFdp1ZC9/KV6BYeBRzjR+NSl4WMioL2GWSRE
         dXj/AegDov5wW/VZJVPPUanYQpO8FlPyHs1wpfKcESCue6oA+/q7NhgeDZCvtkI7VUTw
         /E9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=My5hy+eOd+BUGnLYjJSbZOd3nYUzutH2HG2GVn4YySU=;
        b=rwOCJh5ea123nmT6BHe57PqXc52fgA0W6EIOXFXs6uTeVwKPBjDNPHbX1X7Iz0/nSn
         me2BGOqtXX31OxyiVHjP/iBxOJ6Msm1JzcCccNCW9uPQEPZSX5ECh4vJV/J7Nn1vfXiY
         rM21mKknMDT5oAf9Ef28pnxEyiokSeo+B4ptUuWhTc6T0NKhnJh5+vHq7vwb4FeUPYAo
         smv+ZuycMtSSQFc/D0b72xlMcjkcvNpi4i51b774vA26fWAk8KQksFWreVXQk+/6TC20
         HQJn5W4OPdcr26oBxt1pG1/knJ54yJ1hXiNF3qBCY0e8lzPnNFb1JFrsYx5G99+1KCkG
         LbKQ==
X-Gm-Message-State: ANhLgQ2adtJOTKBi4WISSCSSknKEC1IVhDeKPgoeZwK5pSqGced6h61d
        8i09FvPpogQnVcxrJPIfjH4=
X-Google-Smtp-Source: ADFU+vseCaW0oo7VMWsRQmbcHcBu9RZW4zq46TUY4mhg/yDNTUBrocjwJC+h98nGd0cnHrPixEVGnA==
X-Received: by 2002:a1c:ac8a:: with SMTP id v132mr6092078wme.64.1584042493588;
        Thu, 12 Mar 2020 12:48:13 -0700 (PDT)
Received: from DEFRL0001.localdomain ([2a02:810d:1b40:644:cfdf:73ac:91bd:6a1d])
        by smtp.gmail.com with ESMTPSA id z6sm7271122wrp.95.2020.03.12.12.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 12:48:12 -0700 (PDT)
Date:   Thu, 12 Mar 2020 20:46:25 +0100
From:   Markus Fuchs <mklntf@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: platform: Fix misleading interrupt error msg
Message-ID: <20200312194625.GA6684@DEFRL0001.localdomain>
References: <20200306163848.5910-1-mklntf@gmail.com>
 <20200311.230402.1496009558967017193.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311.230402.1496009558967017193.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 11:04:02PM -0700, David Miller wrote:
> From: Markus Fuchs <mklntf@gmail.com>
> Date: Fri,  6 Mar 2020 17:38:48 +0100
> 
> > Not every stmmac based platform makes use of the eth_wake_irq or eth_lpi
> > interrupts. Use the platform_get_irq_byname_optional variant for these
> > interrupts, so no error message is displayed, if they can't be found.
> > Rather print an information to hint something might be wrong to assist
> > debugging on platforms which use these interrupts.
> > 
> > Signed-off-by: Markus Fuchs <mklntf@gmail.com>
> 
> What do you mean the error message is misleading right now?
> 
> It isn't printing anything out at the moment in this situation.

Commit 7723f4c5ecdb driver core: platform: Add an error message to 
    platform_get_irq*()

The above commit added a generic dev_err() output to the platform_get_irq_byname
function.

My patch uses the platform_get_irq_byname_optional function, which
doesn't print anything and adds the original dev_err output as dev_info output 
to the driver.
Otherwise there would be no output at all even for platforms in need of these 
irqs.
