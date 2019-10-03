Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C244C9593
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfJCAYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:24:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJCAYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:24:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EDBB155283C1;
        Wed,  2 Oct 2019 17:24:24 -0700 (PDT)
Date:   Wed, 02 Oct 2019 17:24:24 -0700 (PDT)
Message-Id: <20191002.172424.2266851696540625754.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     joabreu@synopsys.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, f.fainelli@gmail.com, jonathanh@nvidia.com,
        bbiswas@nvidia.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/2] net: stmmac: Enhanced addressing mode
 for DWMAC 4.10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002145258.178745-1-thierry.reding@gmail.com>
References: <20191002145258.178745-1-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 17:24:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Wed,  2 Oct 2019 16:52:56 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> The DWMAC 4.10 supports the same enhanced addressing mode as later
> generations. Parse this capability from the hardware feature registers
> and set the EAME (Enhanced Addressing Mode Enable) bit when necessary.

Series applied.
