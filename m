Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458F62F04DC
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 04:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbhAJDRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 22:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:32982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbhAJDRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 22:17:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DA36224F4;
        Sun, 10 Jan 2021 03:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610248609;
        bh=5MHTAj04UqNZktwcmhXRoinMszPcFYRsB6CngY5RzQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QTkvPfcYn2hG3bTLzmk8eTxOVl5eq6hqljybPUU0LCYwtVAh1KB/gxbyRC7/FtFgu
         TIVLSxDiQJ7cYWZ6IlyFhsABvp2OEF0cjBljqq9aa5vEQNCjyNfCrkH9uymVV966Lw
         c/2+5M4FNYqFvHCu+du5vt5uS7NWSNZCqsORf1vPGEwUmqfsTa9ClJEHo/LPleYZLV
         UySfoqiqV3qWFLrw7ul84/mjGTtxKRRsOWwo6+liIsc420TZM+X9yVAG4ZDgIC3uJI
         o2vzsj6ASo9MCjTMLnCSdN+yv/zf1+YFCGnbdFq/IyDUN59pZxc8TVGyACoIAlrkrx
         az0nCfOCRIpgA==
Date:   Sat, 9 Jan 2021 19:16:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Sebastien Laveze (OSS)" <sebastien.laveze@oss.nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net] dt-bindings: net: dwmac: fix queue priority
 documentation
Message-ID: <20210109191648.25aa6150@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210105154747.1158827-1-sebastien.laveze@oss.nxp.com>
References: <20210105154747.1158827-1-sebastien.laveze@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jan 2021 16:47:48 +0100 Sebastien Laveze (OSS) wrote:
> From: Seb Laveze <sebastien.laveze@nxp.com>
> 
> The priority field is not the queue priority (queue priority is fixed)
> but a bitmask of priorities assigned to this queue.
> 
> In receive, priorities relate to tagged frames priorities.
> 
> In transmit, priorities relate to PFC frames.
> 
> Signed-off-by: Seb Laveze <sebastien.laveze@nxp.com>

Hi Sebastien, looks like this no longer applies to net could you rebase?
