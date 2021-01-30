Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD883091FC
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 06:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhA3FMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 00:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhA3FJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:09:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F93764DED;
        Sat, 30 Jan 2021 05:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611983343;
        bh=KrBnHhCv6L/Z/737pxkxpEHCIgmma3tV2kFZnfox+pU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SXQVs/KhvBVCTdZz3yT31Oda1q4LIhQpHAt8kXuD2wrzt+zOEzkzL8UIkKIOHnBcf
         pkc8yTJmuhH74iTenprSwSLCEx9kdJFAo5oEXAeRJHJZiL2suQjelqJ3XnrbUGXM5H
         sbUhoo8ojQ+6CumD9qVfQEx1wHfHT3rBh8UUNl1OpNCGEjH9ddQ+xB9DwXiqz1CP/B
         sS132kyac9dMQgFk/mz2Onp/Dt9VZHj4lWBDNgdNGSMRUNu2Qaw3SXNjZzhUiTxyYs
         V9e4p900u5ZtS2tSWD6FF30w8/Yzk0Ekm0q9bFHaGiKJiHfaR9NwjQrZjpgeLwEz8Z
         NiIgwcVzuXsIQ==
Date:   Fri, 29 Jan 2021 21:09:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 net-next] vmxnet3: Remove buf_info from device
 accessible structures
Message-ID: <20210129210902.254a8e83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128193835.1201-1-doshir@vmware.com>
References: <20210128193835.1201-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 11:38:34 -0800 Ronak Doshi wrote:
> buf_info structures in RX & TX queues are private driver data that
> do not need to be visible to the device.  Although there is physical
> address and length in the queue descriptor that points to these
> structures, their layout is not standardized, and device never looks
> at them.
> 
> So lets allocate these structures in non-DMA-able memory, and fill
> physical address as all-ones and length as zero in the queue
> descriptor.
> 
> That should alleviate worries brought by Martin Radev in
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210104/022829.html
> that malicious vmxnet3 device could subvert SVM/TDX guarantees.
> 
> Signed-off-by: Petr Vandrovec <petr@vmware.com>
> Signed-off-by: Ronak Doshi <doshir@vmware.com>

Applied, thanks!
