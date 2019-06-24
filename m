Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B0251E7C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfFXWnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:43:15 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35414 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfFXWnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:43:15 -0400
Received: by mail-qk1-f194.google.com with SMTP id l128so11088349qke.2
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=t0/6oE5A7EF6IPPUS2ghoyC9F+vNCsC4i4eofaA0u7M=;
        b=jH/iWQ25KNu/8Mda0omnjCCuVgVpwpmDD0swbDnwlkCPcrrYJ3oFqG9B8hwW1D9Wiu
         LiPJ7dRWe+3B0iS+6BmpSHMSEmK2DGGYexrIYprBGbq0vatPTOZ7qSmwg75rL+M7qKWl
         EgFyQgeh/34h8hR1e3sObr6WSnZUwB6eUpNwSckxDqBWSpfZCH3czACzih0cPS0vbN4h
         w7+4mXUEXOSYh3Hve0SZQRBf0Ys1NY7Ee2FoUYMw37Aw8zGNZkQe42gpTM5T1P/YkSOo
         d/H7HPY+0zex9yHJMkEelssRzmxTOzahSQLOvZyW/FhSyCUlCQzE97XIaqvbSUrub+rY
         sKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=t0/6oE5A7EF6IPPUS2ghoyC9F+vNCsC4i4eofaA0u7M=;
        b=gNkLz1m3lzHDQdO69Lu2/A3O3l6X+3DZ3OVsGSY5XwC8JBIFgonzw8gTbZ195qUuGY
         Y3RNVl0fmdT1woahY39Mi04mBEoDAKoxsBxBs7Upz3Pqgg6Z13WfEwMp0B2+pNl52HWr
         Zv/mjss8oLNwgUdbsfJ61vnJCPDMh0YotoIxt1jtU7VYjL2A/kPj0syIAPe0MtYQEhBY
         74IazWKxHhM6Uab0BpFg0M5P1QKWvN9WTI6pgNrj5paf+hCAlg26/y1hqw99kAa1UH4f
         nBcEI2RChqjEoBOryc8nTnVQDPKNjZQtoptfb81H/KJTxDVE0HQ+VB8wWU2wEXxoP9nw
         fMWQ==
X-Gm-Message-State: APjAAAXJU0WvaIFGTFWuJ4ikcZVWApp4AEbmqKIEuqOkV7iHDUrEFMR9
        rebzwM+0VrWVSEXH1295ntFBmw==
X-Google-Smtp-Source: APXvYqzRusbXNL3h1Vqw8qXYz1QsbWX3h69iMUiJ0+8xgHWj0pCICgidYl6A0Jbs0d+YNcERVFw8xw==
X-Received: by 2002:a37:a7d2:: with SMTP id q201mr18993979qke.403.1561416194452;
        Mon, 24 Jun 2019 15:43:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b203sm6264622qkg.29.2019.06.24.15.43.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 15:43:14 -0700 (PDT)
Date:   Mon, 24 Jun 2019 15:43:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Message-ID: <20190624154309.5ef3357b@cakuba.netronome.com>
In-Reply-To: <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
        <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
        <20190624145111.49176d8e@cakuba.netronome.com>
        <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 22:16:02 +0000, Andrey Ignatov wrote:
> Jakub Kicinski <jakub.kicinski@netronome.com> [Mon, 2019-06-24 14:51 -0700]:
> > This is a cgroup-specific flag, right?  It should be a parameter 
> > to cgroup show, not a global flag.  Can we please drop this patch 
> > from the tree?  
> 
> Hey Jakub,
> 
> I had same thought about cgroup-specific flag while reviewing the patch,
> but then found out that all flags in bpftool are now global, no mater if
> they're sub-command-specific or not.
> 
> For example, --mapcompat is used only in prog-subcommand, but the option
> is global; --bpffs is used in prog- and map-subcommands, but the option
> is global as well, etc (there are more examples).

I don't think these are equivalent.  BPF_F_QUERY_EFFECTIVE is a flag
for a syscall corresponding to a subcommand quite clearly.

> I agree that limiting the scope of an option is a good idea in the long
> term and it'd be great to rework all existing options to be available
> only for corresponding sub-commands, but I don't see how the new `-e`
> options is different from existing options and why it should be dropped.

Agreed, TBH, but we can't change existing options, people may be using
them.  Let's drop the patch and make sure we're not making this mistake
again :)

Thanks!
