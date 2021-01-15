Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F742F6FF8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 02:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731491AbhAOB1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 20:27:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAOB1Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 20:27:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E000423A56;
        Fri, 15 Jan 2021 01:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610673996;
        bh=G4xO44jQQNM8390Gi1ejtIukH5AXdbCKSxCrRj6Yt0o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IOojx826GmBhMq56mwDTE0MfNlHDkwbmk451/SoyjTnNRUIIu4h1IPThNqljpRodA
         eWkSEY5EJ7LkSEpYS64fn9q7GuMog4ms5YNQscHFgr+u83KGaGod4M/1QmntrQjL9g
         Vatlm4yYLVe6YWb+EEKKUkU+1h0s2vdr89zhNaJR2kWaGUr7KryJYJqdaAYS1yC1dv
         YQLyha8p1XmCl4/1+7zxkxZhWxalqdfPf0U9ORQCLOUhrl0IAP+QftJWKXg32HJqqh
         yYGHyh8ZM28EzX4861AMGYLwv75psq34dbOw9koDMBbiMo380C603oSPslPQa4tDUC
         a+ucuLPBKaxBw==
Date:   Thu, 14 Jan 2021 17:26:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can-next 2021-01-14
Message-ID: <20210114172635.06c00f4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114075617.1402597-1-mkl@pengutronix.de>
References: <20210114075617.1402597-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 08:56:00 +0100 Marc Kleine-Budde wrote:
> The first two patches update the MAINTAINERS file, Lukas Bulwahn's patch fixes
> the files entry for the tcan4x5x driver, which was broken by me in net-next.
> A patch by me adds the a missing header file to the CAN Networking Layer.
> 
> The next 5 patches are by me and split the the CAN driver related
> infrastructure code into more files in a separate subdir. The next two patches
> by me clean up the CAN length related code. This is followed by 6 patches by
> Vincent Mailhol and me, they add helper code for for CAN frame length
> calculation neede for BQL support.
> 
> A patch by Vincent Mailhol adds software TX timestamp support.
> 
> The last patch is by me, targets the tcan4x5x driver, and removes the unneeded
> __packed attribute from the struct tcan4x5x_map_buf.

Pulled, thanks1
