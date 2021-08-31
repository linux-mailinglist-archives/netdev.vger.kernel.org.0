Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF893FCC15
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 19:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239889AbhHaRLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 13:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhHaRLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 13:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF8D6610E7;
        Tue, 31 Aug 2021 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630429825;
        bh=SGthlE0tQcMKpKjS99fGoaAVfKC/MRfiSGJ7XgdTMp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DksdIv0u7iVWQU3Sh6CAnRCqvOP7QkB8EwwOP5Iuz3SKfuiVKhfigCLHsUnQAG8/9
         bYk6ccn7Z0MCrZWMRt4+emPh3jk4fxXIrZoCFt4RDbx8RJIpQgffqc3pKzXsoolTEN
         khMMXeHXkVNctplMAEeV5B7sL90HcrPMwcKzXp3oCGsFKrn1MhQ8VZxGwK1BJjlsVN
         aj4R8AfmvPCIjUrhsKAQ0oyNlComIaogc1VT66walKdelkBGjvugJEXR/jUHRr3tFB
         i1Rd/pktp+Qfpq8HOzJApj9wf5+SK4I4dXF0RzFV2PLDG7BhU8KUOYMrtRHQ+wcYqS
         g0H+PLXVcYXfg==
Date:   Tue, 31 Aug 2021 10:10:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhaoxiao <zhaoxiao@uniontech.com>
Cc:     davem@davemloft.net, mcoquelin.stm32@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [PATCH v3] stmmac: dwmac-loongson: change the pr_info() to
 dev_err() in loongson_dwmac_probe()
Message-ID: <20210831101023.53c3f67b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210831012523.2691-1-zhaoxiao@uniontech.com>
References: <20210831012523.2691-1-zhaoxiao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 09:25:23 +0800 zhaoxiao wrote:
> Change the pr_info to dev_err.
> 
> Signed-off-by: zhaoxiao <zhaoxiao@uniontech.com>

Your patches seem to not show up on the netdev mailing list.
They do make it to lkml and linux-arm tho, strangely.

Are you seeing any errors when sending them?

Please repost this one and CC warthog9@kernel.org - let's see 
if it gets thru..
