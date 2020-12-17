Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100BB2DD905
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgLQTDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgLQTDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:03:15 -0500
Date:   Thu, 17 Dec 2020 11:02:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608231754;
        bh=TGBdk2PPbv7ruxBpQK/ogPoRxBzDFo1DxKjhtgORch4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pa35194tTiGwkAR+QAa2/igi1kHQFSZXjfWyOXjv8YdmiYbRjiyalfegzDRdPRIZR
         6n16WN6/Eqs8ZEWaAVquLfJGLYb9cveL223dcFF/wzZClS46yzdR5PSJZAVMQlclik
         jPG+dMWvNQMYklKddK28Ae88Dp03gO14lRJ7SpMo94XMLMx/h38rzIzwJManxBt9lF
         lIyIbLkLvKeyAfB9oTY8raNwbySPHxAOefqSgHoCvF+/K6rYR8D8SypzaO4N0NXDbK
         Q6BV8P/b4z2w+zk8PU0WMWWjBgLk6gNeGRzo+7Xw5yFy6X8syqt8B76r3P9+1MV3nr
         Do5sjXLAWIm+A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <gcherian@marvell.com>
Cc:     Colin King <colin.king@canonical.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] octeontx2-af: Fix undetected unmap PF error check
Message-ID: <20201217110231.4b798ecb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BYAPR18MB2679726F785B910EA9325ADCC5C40@BYAPR18MB2679.namprd18.prod.outlook.com>
References: <BYAPR18MB2679726F785B910EA9325ADCC5C40@BYAPR18MB2679.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 05:24:34 +0000 George Cherian wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Currently the check for an unmap PF error is always going to be false because
> > intr_val is a 32 bit int and is being bit-mask checked against 1ULL << 32.  Fix
> > this by making intr_val a u64 to match the type at it is copied from, namely
> > npa_event_context->npa_af_rvu_ge.
> > 
> > Addresses-Coverity: ("Operands don't affect result")
> > Fixes: f1168d1e207c ("octeontx2-af: Add devlink health reporters for NPA")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>  
> Acked-by: George Cherian <george.cherian@marvell.com>

For some reason patchwork did not register your ack automatically. 
I wonder what happened. I added it manually.

Applied, thanks!
