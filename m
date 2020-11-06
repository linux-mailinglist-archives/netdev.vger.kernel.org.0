Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213672A999F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgKFQjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:39:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgKFQjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 11:39:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B54E2151B;
        Fri,  6 Nov 2020 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604680760;
        bh=jwPlFovuOrkaW0Z29UuTSioneIhsZji3BtWS11yzRoo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Symxgd1W9QtB1ePiIhHq32Izj6x6aF3rd9+OUoS/v8OkHE5+2f+dnHGSwscwixQuH
         kdsT6h8n/NyEu7OM+yY60rDZs2WTOgcNFjx3wqSHivNEETJ3GDt79RvYueWNjVoe8w
         UAzUC58RD0QbnT7IlEE6y46OoEhVkLZMhMeNjEBU=
Date:   Fri, 6 Nov 2020 08:39:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bbhatt@codeaurora.org, willemdebruijn.kernel@gmail.com,
        jhugo@codeaurora.org, hemantk@codeaurora.org
Subject: Re: [PATCH v10 1/2] bus: mhi: Add mhi_queue_is_full function
Message-ID: <20201106083918.5ea0674b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <B9A7A95E-BD2F-49C0-A28C-56A8E6D903AC@linaro.org>
References: <1604424234-24446-1-git-send-email-loic.poulain@linaro.org>
        <20201105165708.31d24782@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201106051353.GA3473@work>
        <20201106080445.00588690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <B9A7A95E-BD2F-49C0-A28C-56A8E6D903AC@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 06 Nov 2020 21:58:12 +0530 Manivannan Sadhasivam wrote:
>>> Since you've applied now, what would you propose?  
>>
>> Do you need mhi_queue_is_full() in other branches, or are you just
>> concerned about the conflicts?
> 
> Yes, I need this patch in mhi-next.
> 
>> I'm assuming the concern is just about the mhi/core patch, or would 
>> you need to refactor something in the net driver as well?  
> 
> Just the mhi_queue_is_full() patch. 

Okay, I think you can just apply that patch to your tree again and git
should figure out it's a duplicate. Not optimal, because the change will
have two hashes, but the function is trivial, shouldn't be an issue
even if conflict happens.

Will you need it in wireless (ath11k), or only in other trees?

If it ends up in the wireless tree Dave or I will do the resolution when
we pull from Kalle so it won't even appear to Linus (but then it should
go into wireless through an immutable branch).
