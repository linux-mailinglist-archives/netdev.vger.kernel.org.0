Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F11F40A14D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 01:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349194AbhIMXJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 19:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343996AbhIMXFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 19:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6741560F6F;
        Mon, 13 Sep 2021 23:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631574243;
        bh=tZzW99n3IebBJHhwzKpyQwH+eF18P5zPD0qL5h2MDP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bfYIb0C8+3tVfzAIvFvgztObpuNG6yTEyL18Is29vGMiaYimZHItKlbMb+faoy0Ne
         +Ih+G0UvMjtdSijuSelxnPBMe5CnPeidvKCZ6+Z5GUmvW/HRo8RI+mrtoyllYLPpBX
         zkKdp3CUGCND9s6FVpui2yiNg505YnDAG0/vKidEkeuURVxhINQVS5Otz6gyXMxN8i
         /5jfZv2+SflqHEJFg/7pC5dAth2pGHBioyqMkAelrIU/b1jGB9pIheCo5BEUhci7eN
         JMncs8gSTqa5+6j8m5rOpmONDniPxlIADJkULqLGV3g+vgYYvfJJ/Buft+6IpK7jsG
         8zplXtbIWm4iA==
Date:   Mon, 13 Sep 2021 16:04:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Asmaa Mnebhi" <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v1] mlxbf_gige: clear valid_polarity upon open
Message-ID: <20210913160402.28af887b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210913155711.8732-1-davthompson@nvidia.com>
References: <20210913155711.8732-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Sep 2021 11:57:11 -0400 David Thompson wrote:
> This patch ensures that the driver's valid_polarity
> is cleared during the open() method so that it always
> matches the receive polarity used by hardware.
> 
> Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
> Signed-off-by: David Thompson <davthompson@nvidia.com>

This looks like a fix, it should have a Fixes tag and target the
net tree instead of net-next.
