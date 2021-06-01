Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E75397BFA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 23:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhFAWAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234656AbhFAWAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5382960FDC;
        Tue,  1 Jun 2021 21:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622584718;
        bh=FtNaWpBLeJH7u6QzCHPHHXFFCwmnPujIFR0wi8zsayw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o4bSRJPX8SrRr01CDtuAoRHvFgXxKvKd5Qcf/eNNkQUGllsNnpfaXUjNvgdGwirw7
         wr6Wmekd3NDg6EJ04N/Wez888E+i/OZOd9IczIGVlHkRwzhqWW5EtZWS7wvNfb0y+l
         LKku/g7T96jsAqSiz29m5RUrW01d53FwAfLaAHdkObkW41FGj5pEphUQO5pt6mV2pZ
         cbPuQU1W0ABPlPBlMeW4EVBL/l5rQ5A99pOtSFkV5ykGxwY0g/wT8YHtJA5nhuq7VD
         nZcXpK6LVsuZk/d0hXGwud3rYNTtULAsKHZTM4wtl66C2SC37x8c1r8SB8C79908da
         aslrrALUp5mbw==
Date:   Tue, 1 Jun 2021 14:58:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>
Subject: Re: [PATCH net-next 1/2] net: hns3: add support for PTP
Message-ID: <20210601145837.7b457748@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622547265-48051-2-git-send-email-huangguangbin2@huawei.com>
References: <1622547265-48051-1-git-send-email-huangguangbin2@huawei.com>
        <1622547265-48051-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 19:34:24 +0800 Guangbin Huang wrote:
> From: Huazhong Tan <tanhuazhong@huawei.com>
> 
> Adds PTP support for HNS3 ethernet driver.

Please repost CCing Richard Cochran, the PTP maintainer.
