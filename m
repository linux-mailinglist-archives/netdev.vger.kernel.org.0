Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B4C2F6EC2
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbhANXAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:00:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730794AbhANXAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CA2E23A6C;
        Thu, 14 Jan 2021 22:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610665174;
        bh=NO3uBXxBHXjqq9XWB38oasf4fPzlFUfHGvI2jkiaFwc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OXDdgD0Bj78gR3J/ta31RAPUPBW0J5ORAajOF6IdWLcID2dKbGZCLN7IKR4nV7wUa
         vCPsLpENYam/USFEPo+MkL3nOSYZQZeFRoTlWPry6B/L9opWOMlttfry/PDv1DyNG0
         Th5Wg9SghAxRsAmRxdQpkPEm2zg1sNv7t7eCuYOydcGB9XjS9Pitg5bKi6B/Ejjo1g
         sqb+d+CXkGIA0scbXC0ZCC9iitfVVIIUT9w4/dyioW2U0joBt7aQg9SG5/Q6S5Tn4u
         KimH255QISM7MbceanUu1F5DKyg3A+PnBBwEjWFf2HoopWpq26Qvo/loKvUytpILCw
         H98de2rPenGFA==
Message-ID: <68e347348c3f71a92a43a51fb71bce90aec56451.camel@kernel.org>
Subject: Re: [PATCH net-next 0/4] i40e: small improvements on XDP path
From:   Saeed Mahameed <saeed@kernel.org>
To:     Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, edwin.verplanke@intel.com
Date:   Thu, 14 Jan 2021 14:59:32 -0800
In-Reply-To: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
References: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-14 at 14:33 +0000, Cristian Dumitrescu wrote:
> This patchset introduces some small and straightforward improvements
> to the Intel i40e driver XDP path. Each improvement is fully
> described
> in its associated patch.
> 
> Cristian Dumitrescu (4):
>   i40e: remove unnecessary memory writes of the next to clean pointer
>   i40e: remove unnecessary cleaned_count updates
>   i40e: remove the redundant buffer info updates
>   i40: consolidate handling of XDP program actions
> 
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 149 +++++++++++------
> ----
>  1 file changed, 79 insertions(+), 70 deletions(-)
> 
FWIW,
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

