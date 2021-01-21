Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07972FDF0E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391260AbhAUBuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 20:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729774AbhAUB1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 20:27:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9576823716;
        Thu, 21 Jan 2021 01:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611192406;
        bh=4eL8N5dvRrAeayCnGxz6XFCZIC6kgq3KA5G44fN+5ps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jRGf9nByd+awwtEpSrsNHs/u8wepelVitMbyoJPo6+0yHRYm7KAzeHEQ5i56IqlQC
         3iUTYXICddVpycHNjPfoi3bfesDKJx6w9+8dXgbxDIuCHmaZcuwR7GTuPlh2G0AhxP
         RstytMCAwr9F00zhd/MHzEimtE4MT+PMUbbby8e6zFoQ96jTuv2L7q/zMrKp5dfYo6
         y0+a44T5Wcz1RO4CeujctBch0L5BByl5t8sP4z7MzvUgtxqrpnmMqqku+V1u/ZFiRY
         LOmMtQ+OXvzUS3kHrwKEz8Eo1kXurAqOp5kBetn9jF4Ls1VOwUdJ8v9Mh/NXdlHbsa
         6s3wuHDC6NAWw==
Date:   Wed, 20 Jan 2021 17:26:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated
 guests
Message-ID: <20210120172644.746656b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119175841.22248-5-parri.andrea@gmail.com>
References: <20210119175841.22248-1-parri.andrea@gmail.com>
        <20210119175841.22248-5-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 18:58:41 +0100 Andrea Parri (Microsoft) wrote:
> Restrict the NVSP protocol version(s) that will be negotiated with the
> host to be NVSP_PROTOCOL_VERSION_61 or greater if the guest is running
> isolated.  Moreover, do not advertise the SR-IOV capability and ignore
> NVSP_MSG_4_TYPE_SEND_VF_ASSOCIATION messages in isolated guests, which
> are not supposed to support SR-IOV.  This reduces the footprint of the
> code that will be exercised by Confidential VMs and hence the exposure
> to bugs and vulnerabilities.
> 
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org

Nothing exciting here from networking perspective, so:

Acked-by: Jakub Kicinski <kuba@kernel.org>
