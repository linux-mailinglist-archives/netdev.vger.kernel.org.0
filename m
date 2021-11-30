Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE19C463F70
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 21:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343737AbhK3UmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 15:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbhK3UmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 15:42:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F43C061574;
        Tue, 30 Nov 2021 12:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DFCFB8187B;
        Tue, 30 Nov 2021 20:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A247DC53FCC;
        Tue, 30 Nov 2021 20:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638304721;
        bh=eaQPCBvXqOV2FzzkU4PZozvmX7nx0BFxyMUNtHESgV8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U3m3BAgkP8futBhU+Y9y8iaMkajhMNWj+UyCU3Tu1Ogi+KVi5PGguMq+NUMQ8Xvnv
         TuNncTj3kLYZzWhXIYLzlfHluafE4ymcAdGSssIZYBZ8rBy0fnqjAvge6xvgWt/nAX
         x+VCPYbliqOco/s222UcVSk6JDSrsy8+cOCupQV7cNPsT1bkIKtS6edrdtzHOGDLIg
         ljEGiIgDnZN9TL46OnsUcM7cisWcPTLbiiCd7UK7H9HQ/UYLVWPCoWNWO+B+rPJg21
         MrV26IPdZcuLl56MzE+xi+/6KckmPbMZ3gc0ayghaaSOMdAaax1CmV8JVjWBtgbVO8
         uiPWZf8JNhYMg==
Date:   Tue, 30 Nov 2021 12:38:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v19 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <20211130123839.08a19cbf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f29bf20c59ebecb3b49785b4eea36d5910146e5b.1638272239.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
        <f29bf20c59ebecb3b49785b4eea36d5910146e5b.1638272239.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 12:53:04 +0100 Lorenzo Bianconi wrote:
> Similar to skb_header_pointer, introduce bpf_xdp_pointer utility routine
> to return a pointer to a given position in the xdp_buff if the requested
> area (offset + len) is contained in a contiguous memory area otherwise it
> will be copied in a bounce buffer provided by the caller.
> Similar to the tc counterpart, introduce the two following xdp helpers:
> - bpf_xdp_load_bytes
> - bpf_xdp_store_bytes
> 
> Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
