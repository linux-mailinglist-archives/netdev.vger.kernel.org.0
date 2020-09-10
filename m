Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA3F265023
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgIJUEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726850AbgIJUCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 16:02:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58E3B221E3;
        Thu, 10 Sep 2020 20:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599768100;
        bh=tJ4sd/VZfLWmjoZSSwM+i7rHTfqbfd+pQzgpQ4ABmoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V05l0SfAekpDpY/F1VRC4TWT5yf5tcb0+JtNbkhmGCJvA1CZRE3VgMU8z/H2Jirtt
         0hFY3SwgmlQ6yPILtn60/D47wzVc3la9F/k+0Vy4quhjPOJcBQFF+U0768Ty8K2gUN
         jOWPotBumfeaFRL3AmTVWzEn0pQmdcMJEnHzblHU=
Date:   Thu, 10 Sep 2020 13:01:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, Omer Shpigelman <oshpigelman@habana.ai>
Subject: Re: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
Message-ID: <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910161126.30948-13-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
        <20200910161126.30948-13-oded.gabbay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 19:11:23 +0300 Oded Gabbay wrote:
> From: Omer Shpigelman <oshpigelman@habana.ai>
> 
> Add several debugfs entries to help us debug the NIC engines and ports and
> also the communication layer of the DL training application that use them.
> 
> There are eight new entries. Detailed description is in the documentation
> file but here is a summary:
> 
> - nic_mac_loopback: enable mac loopback mode per port
> - nic_ports_status: print physical connection status per port
> - nic_pcs_fail_time_frame: configure windows size for measuring pcs
>                            failures
> - nic_pcs_fail_threshold: configure pcs failures threshold for
>                           reconfiguring the link
> - nic_pam4_tx_taps: configure PAM4 TX taps
> - nic_polarity: configure polarity for NIC port lanes
> - nic_check_link: configure whether to check the PCS link periodically
> - nic_phy_auto_neg_lpbk: enable PHY auto-negotiation loopback
> 
> Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
> Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
> Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>

debugfs configuration interfaces are not acceptable in netdev.
