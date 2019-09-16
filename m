Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2F9B3652
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfIPISr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 04:18:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:44834 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfIPISr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 04:18:47 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i9mDc-0000qx-Em; Mon, 16 Sep 2019 10:18:44 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i9mDc-000Jar-6t; Mon, 16 Sep 2019 10:18:44 +0200
Subject: Re: [PATCH bpf-next v2 0/3] AF_XDP fixes for i40e, ixgbe and xdpsock
To:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org,
        ast@kernel.org, bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, kevin.laatz@intel.com
References: <20190913103948.32053-1-ciara.loftus@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <880c7613-542f-27e6-b02b-73dbe17afbc6@iogearbox.net>
Date:   Mon, 16 Sep 2019 10:18:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190913103948.32053-1-ciara.loftus@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25573/Sun Sep 15 10:22:02 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/19 12:39 PM, Ciara Loftus wrote:
> This patch set contains some fixes for AF_XDP zero copy in the i40e and
> ixgbe drivers as well as a fix for the 'xdpsock' sample application when
> running in unaligned mode.
> 
> Patches 1 and 2 fix a regression for the i40e and ixgbe drivers which
> caused the umem headroom to be added to the xdp handle twice, resulting in
> an incorrect value being received by the user for the case where the umem
> headroom is non-zero.
> 
> Patch 3 fixes an issue with the xdpsock sample application whereby the
> start of the tx packet data (offset) was not being set correctly when the
> application was being run in unaligned mode.
> 
> This patch set has been applied against commit a2c11b034142 ("kcm: use
> BPF_PROG_RUN")
> 
> ---
> v2:
> - Rearranged local variable order in i40e_run_xdp_zc and ixgbe_run_xdp_zc
> to comply with coding standards.
> 
> Ciara Loftus (3):
>    i40e: fix xdp handle calculations
>    ixgbe: fix xdp handle calculations
>    samples/bpf: fix xdpsock l2fwd tx for unaligned mode
> 
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 4 ++--
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 4 ++--
>   samples/bpf/xdpsock_user.c                   | 2 +-
>   3 files changed, 5 insertions(+), 5 deletions(-)
> 

Applied, thanks!
