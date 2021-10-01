Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B9041F7F9
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhJAXDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhJAXDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 19:03:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38F0961353;
        Fri,  1 Oct 2021 23:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633129294;
        bh=QRsAAsTiVZvjBkzeMGn2n8QolTEbMYKcDHNz8v2WHG0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=efdWktmoxTwaf4hdPljpu15M0O7Ts3Rcagkq6izxCCNUaREmP2c2EKmiB0SD1VBd8
         wIQyjk7bnUMIQkXHR5e3waFFhkwQgCp1WLlJQ4G+DbHpPbFZIGSxcyvPBGH1t/8ELM
         Jx3mfi9SVA0XgQw4U8OeykG/kaun0CRFF5wWETV6Ej3yzgtSYoeqFY8SsjW74DyZw0
         YGt+hngC74arHQ4bT9FM5l2aQ9ELiH0wxmMBOmKqU2d73hL3Mj1qtYWl5QGSVhNg2F
         ODyJXbrVOl49k39Imw1ucrfcKdLwBxJZjWd/VBwY8oDKsuCpsUgpDXaBMCwtAPNwfV
         ph81Iq+S5hWsw==
Date:   Fri, 1 Oct 2021 16:01:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     Joanne Koong <joannekoong@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 1/3] bpf/xdp: Add bpf_load_hdr_opt support
 for xdp
Message-ID: <20211001160133.50c5d143@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAPhsuW4KVXE0UYVee2F7OR_A6C8pNOvPbXM1wDPFNwiUDeOMGg@mail.gmail.com>
References: <20211001215858.1132715-1-joannekoong@fb.com>
        <20211001215858.1132715-2-joannekoong@fb.com>
        <CAPhsuW4KVXE0UYVee2F7OR_A6C8pNOvPbXM1wDPFNwiUDeOMGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021 15:47:55 -0700 Song Liu wrote:
> > +       if (flags & 0xffffffffffff)  
> 
> Maybe use (1ULL << BPF_LOAD_HDR_OPT_TCP_OFFSET_SHIFT) - 1

Or GENMASK_ULL(47, 0) ?
