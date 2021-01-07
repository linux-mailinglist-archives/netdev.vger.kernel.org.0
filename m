Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D147B2EE8CB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbhAGWfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbhAGWfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 17:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F7E223600;
        Thu,  7 Jan 2021 22:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610058871;
        bh=uyLQrUW97a9xy0bqAqWiw/LWZHSlfGBQkcQvKhkvgM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sww3j12Zr/LA+4OicUdY46Enl4CmdPhU1SiDcQ61OJvus/WfRv88F34P+eiAGSIAp
         MSHH9mfvFtwPN6dFT018FFgh/6MbMFmyRfwePjuXWbq6ta0PT0StWJ5TOYPVb/Ha0i
         gcWggC5wkxHKdJ6cnBw3HYwOS87xB3g0ykM8BDhQDNZxsjB6v/BbB1NU3zFRqYMUNT
         0hWB+Qo31NNZ9uas0Q/w2HJSjiywKrssMFJ1KAlFqCMb0YnJ9UVkAulwSPOMqvLVvr
         6mwgm0Rjn37DP3kdwsoOK9GOzkaRTNbXCYyZliKbiNFJOo+djxAqyPBJmTxuZZoM6q
         3RRzHI+RykBjg==
Date:   Thu, 7 Jan 2021 14:34:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     alexander.duyck@gmail.com, jacob.e.keller@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        thomas.lendacky@amd.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, michael.chan@broadcom.com,
        rajur@chelsio.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, tariqt@nvidia.com, saeedm@nvidia.com,
        GR-Linux-NIC-Dev@marvell.com, ecree.xilinx@gmail.com,
        simon.horman@netronome.com
Subject: Re: [PATCH net-next 0/4] udp_tunnel_nic: post conversion cleanup
Message-ID: <20210107143429.308d3c9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106210637.1839662-1-kuba@kernel.org>
References: <20210106210637.1839662-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 13:06:33 -0800 Jakub Kicinski wrote:
> It has been two releases since we added the common infra for UDP
> tunnel port offload, and we have not heard of any major issues.
> Remove the old direct driver NDOs completely, and perform minor
> simplifications in the tunnel drivers.

Applied, thanks for the reviews!
