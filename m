Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CA42AFD35
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgKLBcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgKKXbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 18:31:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E7020665;
        Wed, 11 Nov 2020 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605137506;
        bh=rqg/PHQSJpuuqUka3qMvUg2LXl0OmvMC0JXLntpGS1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bKeLn72gAvng9+wBwPWyzMmNzo/j2/+fo/MWSYrpvFHUNMGbXNDyyZnuPAxtTbe5s
         HO1jqv17H8O9rwxwwcQFZRotYAwA5mZkJHsAS0VLFO2DGzJkN4bjE/HzxAVtdKXrFm
         b91l/gx+bzA9DIwOXL15ZHNFNs/CM65kV7ThVRAk=
Date:   Wed, 11 Nov 2020 15:31:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cjhuang@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] net: qrtr: Add distant node support
Message-ID: <20201111153144.3b426cae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110094427.5ffb1d1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
        <20201107162640.357a2b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi-5Qp7jOHDZLZoWKJ4zwU6Sa9ULAts0eY6ObCu91Awx+w@mail.gmail.com>
        <20201109103946.4598e667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi88N8WjA7ZEU0X_dhX_t-kXkAjhnhjzK7TY7HCurrLSqA@mail.gmail.com>
        <20201110094427.5ffb1d1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 09:44:27 -0800 Jakub Kicinski wrote:
> Thanks! Sounds like net-next will work just fine, but won't you need
> these changes in mhi-next, then? In which case you should send a pull
> request based on Linus' tree so that both Mani and netdev can pull it
> in.
> 
> Mani, WDYT?

Applied to net-next.
