Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF56E78E7
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbfJ1TEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:04:15 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:36969 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729515AbfJ1TEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:04:14 -0400
Received: by mail-il1-f193.google.com with SMTP id v2so9144054ilq.4;
        Mon, 28 Oct 2019 12:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Fgj0+cmuyw3kpGGJgOiwsQKRP0sLXClz7tOy5zx6qWM=;
        b=bF9cCkJfjPN3d63nHG29IaD+E5Y5RqjT1ehDIsR3hgBIT6s9QC9sTufz0OhJ7GaUdw
         dlzVRzOReGi8vurHNoT/0Le5No8PyliwLiBeq5rbZB7astEhwtuA/TKaPPjuaZ30vQn9
         LXGVsKkjlwOkq6s7ip0Xv9Mo4BX957uEkhK/rPyRewGbgm4QNNdckIQBVuqn2BAYu0QS
         wMvPVffZ1XSH7UmdJrxhCWmz7A/GP9bPvBrWrEpvAE+JxEM3g7zlLSWK5J9UNAWvHmyy
         cbgDAUk+GDGA2v0Wt6zM8yn87hy2XNKxGeQxd2C1vcJBUc/rN/SeurEnNTGLO1ccPLxL
         4/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Fgj0+cmuyw3kpGGJgOiwsQKRP0sLXClz7tOy5zx6qWM=;
        b=ceaZX2lto6vrWXotOoTKMwNNyi3d3Y/9yxsUo5pOM6vo3YlO1FV+Jmdpk/ng8PlLSb
         6+PMn6Q6tCsgdBdszEsXzhw2fuG5Z//296EYAbqFM+cR+Huw414grkrhZq8/jK/qWVsv
         STHOA/ZllYRKM52HH42lkZGIdL/R+/9VqaUahl4SGVdPCE0l30W629tfY1+FFe2TD7RF
         sF5Z52Ay8RqdDDej6hE3tDXnaplxqgkjWu+JveSrOGt3B9O1xTZSot5wlXk8hQw+0HQV
         o29yXARw45CbBf6nAWFNrKeWdXbzSO/BEvPQ7XZ+eDJc0XBDofQgdICDvnSE4r1KgSjZ
         Ue1Q==
X-Gm-Message-State: APjAAAV9dC6RKTm1AOG/G3nu7Fu49F0Q179Sb/me0MgWeasPqnwJ5tPp
        77oam4YlFBVZBIMRcMpPdZc=
X-Google-Smtp-Source: APXvYqzXda+emE2pMMZUWBaL3wivJLIcPbgOqBLeWbjn3sL+VKIyf3JYfzM5x/mf+JnixLig7BObeg==
X-Received: by 2002:a92:9cce:: with SMTP id x75mr22449382ill.31.1572289453604;
        Mon, 28 Oct 2019 12:04:13 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t5sm1116609ilo.32.2019.10.28.12.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:04:13 -0700 (PDT)
Date:   Mon, 28 Oct 2019 12:04:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, Martin Lau <kafai@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Message-ID: <5db73ba5afec7_54d42af0819565b855@john-XPS-13-9370.notmuch>
In-Reply-To: <875zk9oxo1.fsf@cloudflare.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
 <20191028055247.bh5bctgxfvmr3zjh@kafai-mbp.dhcp.thefacebook.com>
 <875zk9oxo1.fsf@cloudflare.com>
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Mon, Oct 28, 2019 at 06:52 AM CET, Martin Lau wrote:
> > On Tue, Oct 22, 2019 at 01:37:25PM +0200, Jakub Sitnicki wrote:
> >> This patch set is a follow up on a suggestion from LPC '19 discussions to
> >> make SOCKMAP (or a new map type derived from it) a generic type for storing
> >> established as well as listening sockets.
> >>
> >> We found ourselves in need of a map type that keeps references to listening
> >> sockets when working on making the socket lookup programmable, aka BPF
> >> inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but found it
> >> problematic to extend due to being tightly coupled with reuseport
> >> logic (see slides [2]).
> >> So we've turned our attention to SOCKMAP instead.
> >>
> >> As it turns out the changes needed to make SOCKMAP suitable for storing
> >> listening sockets are self-contained and have use outside of programming
> >> the socket lookup. Hence this patch set.
> >>
> >> With these patches SOCKMAP can be used in SK_REUSEPORT BPF programs as a
> >> drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hopefully
> >> lead to code consolidation between the two map types in the future.
> > What is the plan for UDP support in sockmap?
> 
> It's on our road-map because without SOCKMAP support for UDP we won't be
> able to move away from TPROXY [1] and custom SO_BINDTOPREFIX extension
> [2] for steering new UDP flows to receiving sockets. Also we would like
> to look into using SOCKMAP for connected UDP socket splicing in the
> future [3].
> 
> I was planning to split work as follows:
> 
> 1. SOCKMAP support for listening sockets (this series)
> 2. programmable socket lookup for TCP (cut-down version of [4])
> 3. SOCKMAP support for UDP (work not started)
> 4. programmable socket lookup for UDP (rest of [4])
> 
> I'm open to suggestions on how to organize it.

Looks good to me. I've had UDP support on my todo list for awhile now
but it hasn't got to the top yet so glad to see this.

Also perhaps not necessary for your work but I have some patches on my
stack I'll try to get out soon to get ktls + receive hooks working.

> 
> >> Having said that, the main intention here is to lay groundwork for using
> >> SOCKMAP in the next iteration of programmable socket lookup patches.
> > What may be the minimal to get only lookup work for UDP sockmap?
> > .close() and .unhash()?
> 
> John would know better. I haven't tried doing it yet.

Right, I don't think its too complicated we just need the hooks and then
to be sure the socket state checks are OK. Having listening support should
help with the UDP case.

> 
> From just reading the code - override the two proto ops you mentioned,
> close and unhash, and adapt the socket checks in SOCKMAP.

+1.

> 
> -Jakub
> 
> [1] https://blog.cloudflare.com/how-we-built-spectrum/
> [2] https://lore.kernel.org/netdev/1458699966-3752-1-git-send-email-gilberto.bertin@gmail.com/
> [3] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
> [4] https://blog.cloudflare.com/sockmap-tcp-splicing-of-the-future/


