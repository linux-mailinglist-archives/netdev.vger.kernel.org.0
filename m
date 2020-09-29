Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7959827D53C
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgI2R4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbgI2R4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:56:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E5320702;
        Tue, 29 Sep 2020 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601402213;
        bh=VjFWlgotHxndgT+HlYaX5ZSuHK2ROFCx0rl/xus1Ay0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q34jEpl1mxcSYhrk+PCC6qx0FQ9nDGtfwHmSqcBM4Q40lidNLMDmDacSM7UyyOEKG
         Z4IVSUy5IQoBA8B3MVm3ezTcg29KRbnA7j2UuOLQZhzP0rvDcy3VUt+APDe9LQ0QS/
         WTRUfQwfQDjQJPthi+npqGuhgZUBHUfdy+rJ0qiM=
Date:   Tue, 29 Sep 2020 10:56:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislaw Kardach <skardach@marvell.com>
Cc:     <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>, <kda@semihalf.com>
Subject: Re: [PATCH net-next 0/7] octeontx2-af: cleanup and extend parser
 config
Message-ID: <20200929105651.71d61db8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929092820.22487-1-skardach@marvell.com>
References: <20200929092820.22487-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 11:28:13 +0200 Stanislaw Kardach wrote:
> Current KPU configuration data is spread over multiple files which makes
> it hard to read. Clean this up by gathering all configuration data in a
> single structure and also in a single file (npc_profile.h). This should
> increase the readability of KPU handling code (since it always
> references same structure), simplify updates to the CAM key extraction
> code and allow abstracting out the configuration source.
> Additionally extend and fix the parser config to support additional DSA
> types, NAT-T-ESP and IPv6 fields.

Acked-by: Jakub Kicinski <kuba@kernel.org>
