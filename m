Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D2445DDC
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 03:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhKECTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 22:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhKECTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 22:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A24C26108F;
        Fri,  5 Nov 2021 02:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636078603;
        bh=L6LP6CUsxPIHiMGth/pcO4FGTULp779vN4eIy/L+DBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VEJ4eshd3K/xA9Savw4ZtvOOHeRUfNfiyYcYOV0sHN1z/ZggA7Ozd/rbkm6O/sYr7
         /8cIJ5PWZ+IPsQGoZMDQ1oSVETAmeYRGsp7cyGxM5Z4QpD8EIXHaK87P45yltVBKum
         ak4sHQklWuP6mEFzCB470KO1OBFsKDVtvWp/aTPbbgXB6/wgNHR56Ko5qiZzVVzKkN
         ih2M5y3hzsO2KdPomYelCGPp8pJUaNJIKdBhh3XvEicrP6OMZahv9SD1ahZwJyB4us
         EIluyHaU4tmUXYoX1UozGrgHTAmqwrvSzz9rvlcrLLPxTXPN1MnSYGAbJcTqaKJLCX
         6QfozD5+eCxPA==
Date:   Thu, 4 Nov 2021 19:16:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <20211104191641.3bc9d873@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
        <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 18:35:32 +0100 Lorenzo Bianconi wrote:
> +static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	int i, n_frags_free = 0, len_free = 0, tlen_free = 0;

clang says tlen_free set but not used.
