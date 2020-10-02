Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B54280B8C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 02:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733298AbgJBAJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 20:09:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:25712 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733085AbgJBAJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 20:09:54 -0400
IronPort-SDR: uj1mqgGHVCYH7vdSYaruMn9pVeTxnCWOFAxfR6+N81H/iKzUfteU40zGq8S8Q3AQnspEKwp547
 ZVDygV4McJ8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="150661745"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="150661745"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 17:09:53 -0700
IronPort-SDR: VeSzCLeyUvbecGZ3uyMh2Vx1dlowJMxbbQcBamEqfsaEvj66dkm0RcW3HbWoD2aFOoyVqsbXQl
 oYvgWtwS5VUA==
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="346263997"
Received: from vuongn2x-mobl.amr.corp.intel.com ([10.255.228.170])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 17:09:52 -0700
Date:   Thu, 1 Oct 2020 17:09:52 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@vuongn2x-mobl.amr.corp.intel.com
To:     Stephen Rothwell <sfr@canb.auug.org.au>
cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geliang Tang <geliangtang@gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net
 tree
In-Reply-To: <20201001135237.6ec2468a@canb.auug.org.au>
Message-ID: <alpine.OSX.2.23.453.2010011707510.40522@vuongn2x-mobl.amr.corp.intel.com>
References: <20201001135237.6ec2468a@canb.auug.org.au>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 1 Oct 2020, Stephen Rothwell wrote:

> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>  net/mptcp/protocol.h
>
> between commit:
>
>  1a49b2c2a501 ("mptcp: Handle incoming 32-bit DATA_FIN values")
>
> from the net tree and commit:
>
>  5c8c1640956e ("mptcp: add mptcp_destroy_common helper")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> -- 
> Cheers,
> Stephen Rothwell
>
> diff --cc net/mptcp/protocol.h
> index 20f04ac85409,7cfe52aeb2b8..000000000000
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@@ -387,7 -407,8 +407,8 @@@ void mptcp_data_ready(struct sock *sk,
>  bool mptcp_finish_join(struct sock *sk);
>  void mptcp_data_acked(struct sock *sk);
>  void mptcp_subflow_eof(struct sock *sk);
> -bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq);
> +bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
> + void mptcp_destroy_common(struct mptcp_sock *msk);
>

Yes, this is the appropriate conflict resolution. Thanks!


--
Mat Martineau
Intel
