Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241A42AE554
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbgKKBKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731746AbgKKBKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:10:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7F821D7F;
        Wed, 11 Nov 2020 01:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605057015;
        bh=SCJwc6M/YlwFgIGsMdjbALifbJv8RCAzxo4V57Ddvro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VGicqCwn0jStrPs9IRET/S20mpCoEHGHmhEK2mZNRWRijlWFkEggPNJYKhaT7uBI2
         /yNqCvRcy/+mF+6PmHQRhcTnHgIAM97hmXVChqc1tHFMBSS3ZhKhaZ47bxNlix/Tno
         PDi8qzOZfhJ6pR9qWSUDle12kqtvhAzHI7GOoWRA=
Date:   Tue, 10 Nov 2020 17:10:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Qing <wangqing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net] net/ethernet: Fix error return when ptp_clock is
 ERROR
Message-ID: <20201110171013.11e5373b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604888277-20400-1-git-send-email-wangqing@vivo.com>
References: <1604888277-20400-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 10:17:52 +0800 Wang Qing wrote:
> We always have to update the value of ret, otherwise the error value
>  may be the previous one. And ptp_clock_register() never return NULL
>  when PTP_1588_CLOCK enable.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

Please add a Fixes tag as I requested in a reply to v2.

Please CC Richard on the next version, since he gave you feedback, 
and he's the PTP maintainer.
