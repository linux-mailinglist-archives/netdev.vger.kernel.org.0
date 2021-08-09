Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5133E4E2D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhHIUzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhHIUzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 16:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A2561019;
        Mon,  9 Aug 2021 20:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628542497;
        bh=OtefdCSZIvmHhVrzmgv2TAsBD5y3mG5YUCqrPRJO/Cg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mO9bSUQUAd3FiiCZ/KIEK3SjebiwUOOCorMcAHbfb2UERa48G5cRMVEsuWF7RMNSv
         tkNrnx4FdnfJDN9p6lr6dHP/LDg0/cku9b8YC6srUU0RAaLMI9LbH9RSB1/v8cm8iZ
         HnkSwvpPeYIrd1e4qogBjYIc0iOaZQGYjx41tlUXCSvPaL5KI/7ZNSEJBQ2eZEGcMW
         AGpapmhwMLaVzGPXRVdnn2IO+vsRNMg16TwRannSqiBEhrt6FDUfuoNcDQmIwqg8U4
         yCWJrkV6eBtsD2DtH3jp1AS70ppVEzuQbAr/vsq1nGsuV5d7rE+ty6gKFpnP0N/hIR
         uK9QfiRhv/m0g==
Date:   Mon, 9 Aug 2021 13:54:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>
Subject: Re: [PATCH net-next 4/4] net: hns3: add support ethtool extended
 link state
Message-ID: <20210809135456.397129f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1628520642-30839-5-git-send-email-huangguangbin2@huawei.com>
References: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
        <1628520642-30839-5-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Aug 2021 22:50:42 +0800 Guangbin Huang wrote:
> +	if (!h->ae_algo->ops->get_link_diagnosis_info)
> +		return -EOPNOTSUP;

Missing a P at the end here, this patch does not build.
