Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80B833DA2E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbhCPRDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 13:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238978AbhCPRCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 13:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62C3165111;
        Tue, 16 Mar 2021 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615914173;
        bh=Qb1m/E69RDV9XU0xBvmBWK4MHqIfN0kvYAxOecpMK/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iniBsUmeJ9bjRyBagWGq6LPk1l+y+NSuAag7Spm3DvmP9WMEXHjAqLzxe/LzklTAc
         5Vyj9BfaqjWgVIBjXsKJXaB6NrbtxmYTGzo+F5/DC8n7BZC0H7eh+FtscNe80B6BxR
         rsYsy1iuFHo+oBOWmXT2HFreHoEpNGACLwOm1wo3gxSuF/Jt7V+W3HPAktRzu8tbTx
         a9RzgrGAtf6jaG+L5iakmqGV825qv7zGdNVM+3FWzVhCqgw5e/IM/+cgm7kt2nNcYP
         Y20jhc5eeu6RqamiDoaJb7skFeynRm/dWmSDYHVYeXdD2m/RwPSSTeRML9nuPlO5EA
         uShtQQtjOewcQ==
Date:   Tue, 16 Mar 2021 10:02:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: Re: [net PATCH 1/9] octeontx2-pf: Do not modify number of rules
Message-ID: <20210316100252.75826dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615886833-71688-2-git-send-email-hkelam@marvell.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
        <1615886833-71688-2-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 14:57:05 +0530 Hariprasad Kelam wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> In the ETHTOOL_GRXCLSRLALL ioctl ethtool uses
> below structure to read number of rules from the driver.
> 
>     struct ethtool_rxnfc {
>             __u32                           cmd;
>             __u32                           flow_type;
>             __u64                           data;
>             struct ethtool_rx_flow_spec     fs;
>             union {
>                     __u32                   rule_cnt;
>                     __u32                   rss_context;
>             };
>             __u32                           rule_locs[0];
>     };
> 
> Driver must not modify rule_cnt member. But currently driver
> modifies it by modifying rss_context. Hence fix it by using a
> local variable.
> 
> Fixes: 81a43620("octeontx2-pf: Add RSS multi group support")

Fixes tag: Fixes: 81a43620("octeontx2-pf: Add RSS multi group support")
Has these problem(s):
	- missing space between the SHA1 and the subject
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").

Please fix the entire submission.
