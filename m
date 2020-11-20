Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFCF2BAF34
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgKTPoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:44:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgKTPoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 10:44:46 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB11A22252;
        Fri, 20 Nov 2020 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605887085;
        bh=sp7MQRrcnzIk7JiBCxm/j4/NwDTlMMp0aYn+xU0l/Xg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BEAc9G8RizVryxLp3t3FRWijmk5sCJ9ExdtpWVnnLsdAhtWFZxqWOgqGXohLF+/TE
         1oBpKnsbIP3fOz7Ncnv0gmOye/qilK1k7bOtHttYRZlM5NatyAcYJ+6ydYhci4IiHh
         hbRtzyVaI83z9Va1FEu9cnZlgA08e3mqmQXsF7c0=
Date:   Fri, 20 Nov 2020 07:44:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>
Subject: Re: [RFC V2 net-next 1/2] ethtool: add support for controling the
 type of adaptive coalescing
Message-ID: <20201120074444.741b9aaa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1605853479-4483-2-git-send-email-tanhuazhong@huawei.com>
References: <1605853479-4483-1-git-send-email-tanhuazhong@huawei.com>
        <1605853479-4483-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 14:24:38 +0800 Huazhong Tan wrote:
> +  ``ETHTOOL_A_COALESCE_USE_DIM``               bool    using DIM adaptive

Sorry, I didn't get into the discussion on v1 in time.

I'd prefer this to be an enum (u8 or u32) the values can already be:
 - device (HW / FW)
 - driver specific
 - DIM
