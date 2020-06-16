Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED261FBF5C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 21:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731378AbgFPTrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 15:47:08 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:59205 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbgFPTrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 15:47:04 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f0c01c92;
        Tue, 16 Jun 2020 19:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=7vGnD2Fc5hFa6zE6l8I/6fYFWTE=; b=auHBa5
        AEe5pm5r80dgWM49RbxNg2b1wePIyReSMQ0Rz/3L8Yx5mFtqdklxmmgnU69XYlJN
        hUBaHFgVJALywQiz6/SIkttoZgX1tGyz+Zg+VQcgVldFachBs52tuPslyyMFQ0LX
        thiKjEu3HP7G7pjaS6Q85sWuiJrjwSZZouMci0xDSFLn39VuLeRw1x/kWL7uYtnC
        q9lJ9u4WEJkyqJPlHNMFgYZ8GQhbEM4aqhZNPWgxeSvHzabhX4d1A2W++bIgoNgb
        5POprpu6DVgEzddWZ80fiiLd2tnSpz4DTk3KcXvzj6IQwWQeVy1VhdN6Y6LpuXnz
        67qrTsLtz03/PXLw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id def91afe (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 16 Jun 2020 19:29:00 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id s18so3192212ioe.2;
        Tue, 16 Jun 2020 12:46:59 -0700 (PDT)
X-Gm-Message-State: AOAM532ICgqzUljjLdMiLJDrmaM6G2P2VuQ5E+2Wa9rsZgiZCLicoMk2
        6gPasqRds+Zf64jDUyn/ObteEMB32F2gp413H0M=
X-Google-Smtp-Source: ABdhPJxC2pRunaModJX8LCWHauaz4Ko5hXWZ58PHme1+4UYNCmQGIC+iarFUNAqn+rNJyw3DywT6LsxlwSFMRJ3z3pU=
X-Received: by 2002:a6b:6705:: with SMTP id b5mr4346341ioc.29.1592336817452;
 Tue, 16 Jun 2020 12:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200616015718.7812-1-longman@redhat.com> <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
In-Reply-To: <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 16 Jun 2020 13:46:46 -0600
X-Gmail-Original-Message-ID: <CAHmME9rCD1KJNguthAhZ+OAVZTpBwEvGRLRV0tvQjBaEYG1bHQ@mail.gmail.com>
Message-ID: <CAHmME9rCD1KJNguthAhZ+OAVZTpBwEvGRLRV0tvQjBaEYG1bHQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mm, treewide: Rename kzfree() to kfree_sensitive()
To:     Joe Perches <joe@perches.com>
Cc:     Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-pm@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>, linux-ppp@vger.kernel.org,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ecryptfs@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 12:54 PM Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2020-06-15 at 21:57 -0400, Waiman Long wrote:
> >  v4:
> >   - Break out the memzero_explicit() change as suggested by Dan Carpenter
> >     so that it can be backported to stable.
> >   - Drop the "crypto: Remove unnecessary memzero_explicit()" patch for
> >     now as there can be a bit more discussion on what is best. It will be
> >     introduced as a separate patch later on after this one is merged.
>
> To this larger audience and last week without reply:
> https://lore.kernel.org/lkml/573b3fbd5927c643920e1364230c296b23e7584d.camel@perches.com/
>
> Are there _any_ fastpath uses of kfree or vfree?

The networking stack has various places where there will be a quick
kmalloc followed by a kfree for an incoming or outgoing packet. One
place that comes to mind would be esp_alloc_tmp, which does a quick
allocation of some temporary kmalloc memory, processes some packet
things inside of that, and then frees it, sometimes in the same
function, and sometimes later in an async callback. I don't know how
"fastpath" you consider this, but usually packet processing is
something people want to do with minimal overhead, considering how
fast NICs are these days.
