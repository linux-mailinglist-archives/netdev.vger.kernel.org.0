Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254B32B83E7
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgKRSc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgKRSc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:32:26 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5812620897;
        Wed, 18 Nov 2020 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605724345;
        bh=Ej8MJDl/vqmk5M7g0NPSig9dOpcFlVgmeFMvvIpsWag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KSRw3nXfmqnOQaTZIaHaoIS9rx6VyaOBnD2WT/jvvBpH4hFTSUURTTRmx4G2NzaVQ
         QCLQL987/H8DqiezKDMSoWtC3UJ1GZDefQCc+TWumx91gyYKTGoGK6K/qrcqdQh1sp
         d8pjURvXsYyf2OLAOZYv1VRWZiTXFu6DQVQ8X2c8=
Date:   Wed, 18 Nov 2020 10:32:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>
Subject: Re: [net-next v3 1/2] devlink: move request_firmware out of driver
Message-ID: <20201118103224.4662565f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <505ed03a-6e71-5abc-dd18-c3c737c6ade8@intel.com>
References: <20201117200820.854115-1-jacob.e.keller@intel.com>
        <20201117200820.854115-2-jacob.e.keller@intel.com>
        <505ed03a-6e71-5abc-dd18-c3c737c6ade8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 12:10:49 -0800 Jacob Keller wrote:
> Oof, forgot to metion that the only change since v2 is to fix the typo
> in the commit message pointed out by Shannon. Otherwise, this patch is
> identical and just comes in series with the other change.

Fine by me, although I thought Shannon asked for some changes to debug
prints in ionic?
