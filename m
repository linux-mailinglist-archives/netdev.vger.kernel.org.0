Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FBE198A60
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgCaDK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:10:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbgCaDK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 23:10:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A297415D1723D;
        Mon, 30 Mar 2020 20:10:55 -0700 (PDT)
Date:   Mon, 30 Mar 2020 20:10:54 -0700 (PDT)
Message-Id: <20200330.201054.2227389545951274669.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, alexandre.torgue@st.com,
        boon.leong.ong@intel.com
Subject: Re: [net-next,v2, 0/3] Add additional EHL PCI info and PCI ID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330170512.22240-1-weifeng.voon@intel.com>
References: <20200330170512.22240-1-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 20:10:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Tue, 31 Mar 2020 01:05:09 +0800

> Thanks Jose Miguel Abreu for the feedback. Summary of v2 patches:
> 
> 1/3: As suggested to keep the stmmac_pci.c file simple. So created a new
>      file dwmac-intel.c and moved all the Intel specific PCI device out
>      of stmmac_pci.c.
> 
> 2/3: Added Intel(R) Programmable Services Engine (Intel(R) PSE) MAC PCI ID
>      and PCI info
> 
> 3/3: Added EHL 2.5Gbps PCI ID and info
> 
> Changes from v1:
> -Added a patch to move all Intel specific PCI device from stmmac_pci.c to
>  a new file named dwmac-intel.c.
> -Combine v1 patch 1/3 and 2/3 into single patch.

Series applied, thanks.
