Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876A0222F56
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGPXpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbgGPXpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:45:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1883020890;
        Thu, 16 Jul 2020 22:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594938508;
        bh=iBa2BCZZPIujoIYTuEdFC8XphREKZFuoLY2qC2/G0gk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lUFHZkVkK85c5s0RSzYBE+TxH26HZBotbrrgaNTm+IUGAHp6yLA1mlU78yXvBppSJ
         KGorRKvNF03xF/bHJBS5B94VcrJLRdMRD/k8SNDs72uf683zQKfy8Qi9ZfUDp8sMcv
         NZsND7j1DEEC8MPhnCcDZYAez038N5zfm4VbTdJM=
Date:   Thu, 16 Jul 2020 15:28:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 0/3] Fully describe the waveform for PTP
 periodic output
Message-ID: <20200716152826.379c0f37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716212032.1024188-1-olteanv@gmail.com>
References: <20200716212032.1024188-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 00:20:29 +0300 Vladimir Oltean wrote:
> While using the ancillary pin functionality of PTP hardware clocks to
> synchronize multiple DSA switches on a board, a need arised to be able
> to configure the duty cycle of the master of this PPS hierarchy.
> 
> Also, the PPS master is not able to emit PPS starting from arbitrary
> absolute times, so a new flag is introduced to support such hardware
> without making guesses.
> 
> With these patches, struct ptp_perout_request now basically describes a
> general-purpose square wave.

error: patch failed: drivers/net/ethernet/mscc/ocelot_ptp.c:236
error: drivers/net/ethernet/mscc/ocelot_ptp.c: patch does not apply
hint: Use 'git am --show-current-patch' to see the failed patch
Applying: ptp: add ability to configure duty cycle for periodic output
Applying: ptp: introduce a phase offset in the periodic output request
Applying: net: mscc: ocelot: add support for PTP waveform configuration
Patch failed at 0003 net: mscc: ocelot: add support for PTP waveform configuration
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
