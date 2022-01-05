Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEC0484C50
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 03:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbiAECJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 21:09:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiAECJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 21:09:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D695961476
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 02:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170D8C36AE0;
        Wed,  5 Jan 2022 02:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641348550;
        bh=bo7+W3INu3pVboGxQBAxH69H8hvSx6g7GmPrMf/xB5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SoX+dfFhLfFdGNNdaDOrxezbzIzQ6HCSeaSPpXe757zW+FLNnfIpRFPLPh8KfjoeH
         /OCoQVnL7Wv4o4Yuw2vPO7KR2SwgoP0MfRjwFEEOKPBKVbBzAnlFy60sYsjnPShsHD
         JrmCfmvpm3bdpw+B026YMms9m779AtJpTnFY1A9QEmfTO3W/6eiNvZBc7ANZ9/DCBZ
         i5RVIsZtCLbbxyFV2W6DF4+Nx5nF1f1+4XCgmn3LmCXK+IwrNWv/gesIOJ3oloNkex
         rXS3BmIGUe3LVthaDI3SEIgTNRtpAd3nY3LGeEMJo/Ly1H1egh44xejh6sTavQMEzF
         FL4VVF3jr0jYQ==
Date:   Tue, 4 Jan 2022 18:09:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v4 1/8] PCI: add Fungible vendor ID to
 pci_ids.h
Message-ID: <20220104180909.486fde68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220104064657.2095041-2-dmichail@fungible.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
        <20220104064657.2095041-2-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Jan 2022 22:46:50 -0800 Dimitris Michailidis wrote:
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>

Please CC Bjorn and linux-pci on the next rev on this one patch.
