Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB3230C89B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbhBBR4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237263AbhBBRyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 12:54:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1BE64F91;
        Tue,  2 Feb 2021 17:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612288420;
        bh=1bParSro0d9sBut/n8xHUjsNKJ8U20G/b3JZUg1/tH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WcuT8kogns9XSrg8DGNtwtRzjrxmrBCdHPUIl2EOG8k3GKdo6UJSCiXvSClq+0DsU
         kuwZzfz8h9x6tvUfmAC3Fx7bShyjUVCGnkJlt2K+BPDRnSLX5qyTS+xIxHjenrPV+K
         +j3n5SucdPPkf9gsL4fv6Va429xfeHqTyUFReK3zMWodOSA01iSktgIpY+Gj/2fyu4
         EKrz/WTGLKbeePGDMgYWYxA2vNnRgKBqaTmKFCPoaKo090yNew5XXNj/olFO9X/ytI
         IiotjkWrQoNeTFi8k2WVKcrhy2qyjzctU2Q34ym4tbQgPbahu3/gKJUtPA4yA0kIAm
         iksQbdXcJRkeQ==
Date:   Tue, 2 Feb 2021 09:53:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgoutham@marvell.com, davem@davemloft.net, sbhatta@marvell.com,
        hkelam@marvell.com, jerinj@marvell.com, lcherian@marvell.com
Subject: Re: [net-next v2 00/14] Add Marvell CN10K support
Message-ID: <20210202095339.5062265c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612244528-26356-1-git-send-email-gakula@marvell.com>
References: <1612244528-26356-1-git-send-email-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 11:12:08 +0530 Geetha sowjanya wrote:
> The current admin function (AF) driver and the netdev driver supports
> OcteonTx2 silicon variants. The same OcteonTx2's
> Resource Virtualization Unit (RVU) is carried forward to the next-gen
> silicon ie OcteonTx3, with some changes and feature enhancements.
> 
> This patch set adds support for OcteonTx3 (CN10K) silicon and gets
> the drivers to the same level as OcteonTx2. No new OcteonTx3 specific
> features are added.

Please repost as a thread. Patchwork split your submission into two
series.
