Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5555C26AF26
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgIOVGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbgIOUgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:36:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D1020771;
        Tue, 15 Sep 2020 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600202158;
        bh=W26wuZvq0OQ8YeopJ1sUn7SBj52lJp5Mg660nie5vW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h0M8aWuDDXQfGydej/HJTlBKH4cAvPX4gBXiOUkoZtLDyn6KXo3CYqqW4ZUhlT7UD
         ZcFVoPg1FzRjl+2rr111hTTWGMuwdAOv/jvmVOdQcCwnRlUXjMKUZ7zIyJ230QkyHP
         ULahrvXccRe7+2IlN/nTAKQNqLBQqptsKb4pct0Y=
Date:   Tue, 15 Sep 2020 13:35:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 20:10:08 +0300 Oded Gabbay wrote:
> Hello,
> 
> This is the second version of the patch-set to upstream the GAUDI NIC code
> into the habanalabs driver.
> 
> The only modification from v2 is in the ethtool patch (patch 12). Details
> are in that patch's commit message.

You keep reposting this, yet this SDK shim^W^W driver is still living in
drivers/misc. If you want to make it look like a NIC, the code belongs
where NIC drivers are.

Then again, is it a NIC? Why do you have those custom IOCTLs? That's far
from normal.

Please make sure to CC linux-rdma. You clearly stated that the device
does RDMA-like transfers.
