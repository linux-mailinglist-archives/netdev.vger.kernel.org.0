Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C7A2A192C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgJaSJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgJaSJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:09:14 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E162068D;
        Sat, 31 Oct 2020 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604167754;
        bh=OPbbtvNukDMeVieISiK9KwqFjbsYqU7+sdOqWiR7DJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xVX0EwrR9FrHqGbWotK8h/y3EDIl7vDjzZz1Awb0lqtOx73WsU5MEJw62eq6lo2Fa
         ab3mUA/6i/qFUDP/6AMRN/jGh+PJsMtsNWkc3gMMaDhXL2R0q03C3HJv62TVyQzSjM
         nm88huRKr8waCWQ2wkpmqqWXr8p0rpDMWwDw0MmE=
Date:   Sat, 31 Oct 2020 11:09:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [PATCH v11 4/4] bus: mhi: Add userspace client interface driver
Message-ID: <20201031110912.7fbdc8e7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1604025946-28288-5-git-send-email-hemantk@codeaurora.org>
References: <1604025946-28288-1-git-send-email-hemantk@codeaurora.org>
        <1604025946-28288-5-git-send-email-hemantk@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 19:45:46 -0700 Hemant Kumar wrote:
> +/* .driver_data stores max mtu */
> +static const struct mhi_device_id mhi_uci_match_table[] = {
> +	{ .chan = "LOOPBACK", .driver_data = 0x1000},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(mhi, mhi_uci_match_table);

I forgot to follow up. If you're adding a testing interface to the
kernel there needs to be an open source test code that makes use of 
it. If the code is not large something in
tools/testing/selftests/drivers would be great, but link to an external
project in the documentation is good enough.
