Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10C03093D5
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhA3J7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231963AbhA3J7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 04:59:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 408B964E0F;
        Sat, 30 Jan 2021 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611988675;
        bh=q6ryADOwHTSJsq5HWICB8Ym6DPR+/qhHnSe9FGX39Hs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KNTA8q5nXLUFqJ4upNXAoyCCA8rsZ3bW9XWJ+PHZbj0BGclg+MKe9bu9fywBI5p0X
         QRs1PXd+0zbLaHYG6SMjKtzPikHGHul2XPWksD0fRgH9EWVcIcjFzr5iYyOQmGqruY
         CQyV/d8/MZYhwrD3yzUc4BoXKcSCxZFhkcUlIscjM8ftHdie1YJ69M3vupRZ75CyyQ
         3BFfD/nmOpjA/61tc4y/Vl5jAgCbX3IQP4Lag2+r5uzf7brGbcd1Rzp+X7C96A9YUq
         bTzOT2hrimhvklmy1uQcL8Bh0rBY3i9mtpqndJwX8nqTb0mOu3Fzd7F77GrmgHjo6y
         M9ify/dk4o3DQ==
Date:   Fri, 29 Jan 2021 22:37:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 10/15] ice: display some stored NVM versions
 via devlink info
Message-ID: <20210129223754.0376285e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129004332.3004826-11-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
        <20210129004332.3004826-11-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 16:43:27 -0800 Tony Nguyen wrote:
> When reporting the versions via devlink info, first read the device
> capabilities. If there is a pending flash update, use this new function
> to extract the inactive flash versions. Add the stored fields to the
> flash version map structure so that they will be displayed when
> available.

Why only report them when there is an update pending?

The expectation was that you'd always report what you can and user 
can tell the update is pending by comparing the fields.
