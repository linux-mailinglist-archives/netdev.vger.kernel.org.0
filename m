Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF5664BE11
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiLMUmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 15:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbiLMUms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 15:42:48 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A16E5F9A
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 12:42:47 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id l10so1085643plb.8
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 12:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z7E57QgbIGLbt35zoNvm7umahgzws3R7SXrVu/3PejA=;
        b=CSXvmZwclIlrUnD1uIa7XaRodthjGBEKmZ0UBAL7aZixsWhbmarYiPV1gocmAAjUCD
         B7TAoJ8u4Gy7bdiKzs3x8vORrhQeMcu1NvKetGBu9vT+ceA+Z7Xl9lvHWUaAoIH7ydOX
         yJ8Aq3BumtJR663oUT63qxdNSlOIy/EVKnRr54t8/tbZyMQ78/8iJVMi7bFRimy9GytN
         W/kWnJhqr7w0E6dBi1wAxgg6QQ1fzMfgyhiqC/yVXNgcV0Og2VmwwXQC1oQrXoMwSUtO
         vqcQDAG2rO1uTH1oovvdL/4EYiurNUMGXcvpPt/L6MIxdvAOJS202sj4qs4YPissMDzq
         ylwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z7E57QgbIGLbt35zoNvm7umahgzws3R7SXrVu/3PejA=;
        b=z2qE/Q4s6CEFi8i+H79kgS8hrtQDaHwNjjM8jNZK1y8CxyNgpJzcGHmZT9WAlKSeUG
         1QdH0ndvscnADabyBxVxE+o4kqOCA550ljLnuhahBMGC8u0aRR669qKkyuuE+uPzBc0V
         sa19XELr/LClDmd9X9iZHiBGbjFgjRim3ETd5ZJiCU91n+LIomk6H3n6qZw2T62MdJ1c
         K/0ijxFe4Wm5q3vGSdzbI+meraypP7BGG5guzkzYq8UFFtcTmOGhb3igTAvUK/BDns1H
         8EMd0iK/4MFtGaFgbv6KMsq9q/4Y77OUwrSkmdO0aBsWm0N1pIjPehfsRzeo52S454xW
         nZ9w==
X-Gm-Message-State: AFqh2kq7AR3igAcnRWxMFuPW7C0SjA8kMPphtxyzT6BSDnr2wWj006uW
        pA9Em3219g4APreVSA0D3cn+tYuGdF31Oa8dYy+jNg==
X-Google-Smtp-Source: AMrXdXv6W9AELkRn6+d2X1cIOlM4Q3Glk4S4BYHHcL+EsfYHvc6/gg5V8QATrt6FqK4F0FzN9BIE8VhMlqyvnhXh1FI=
X-Received: by 2002:a17:90a:1f82:b0:21e:df53:9183 with SMTP id
 x2-20020a17090a1f8200b0021edf539183mr8214pja.66.1670964166532; Tue, 13 Dec
 2022 12:42:46 -0800 (PST)
MIME-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com> <20221213023605.737383-2-sdf@google.com>
 <Y5iqTKnhtX2yaSAq@maniforge.lan>
In-Reply-To: <Y5iqTKnhtX2yaSAq@maniforge.lan>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 13 Dec 2022 12:42:35 -0800
Message-ID: <CAKH8qBvjwMXvTg3ij=6wk2yu+=oWcRizmKf_YtW_yp5+W2F_=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 01/15] bpf: Document XDP RX metadata
To:     David Vernet <void@manifault.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 8:37 AM David Vernet <void@manifault.com> wrote:
>
> On Mon, Dec 12, 2022 at 06:35:51PM -0800, Stanislav Fomichev wrote:
> > Document all current use-cases and assumptions.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  Documentation/bpf/xdp-rx-metadata.rst | 90 +++++++++++++++++++++++++++
> >  1 file changed, 90 insertions(+)
> >  create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
> >
> > diff --git a/Documentation/bpf/xdp-rx-metadata.rst b/Documentation/bpf/xdp-rx-metadata.rst
> > new file mode 100644
> > index 000000000000..498eae718275
> > --- /dev/null
> > +++ b/Documentation/bpf/xdp-rx-metadata.rst
>
> I think you need to add this to Documentation/bpf/index.rst. Or even
> better, maybe it's time to add an xdp/ subdirectory and put all docs
> there? Don't want to block your patchset from bikeshedding on this
> point, so for now it's fine to just put it in
> Documentation/bpf/index.rst until we figure that out.

Maybe let's put it under Documentation/networking/xdp-rx-metadata.rst
and reference form Documentation/networking/index.rst? Since it's more
relevant to networking than the core bpf?

> > @@ -0,0 +1,90 @@
> > +===============
> > +XDP RX Metadata
> > +===============
> > +
> > +XDP programs support creating and passing custom metadata via
> > +``bpf_xdp_adjust_meta``. This metadata can be consumed by the following
> > +entities:
>
> Can you add a couple of sentences to this intro section that explains
> what metadata is at a high level?

I'm gonna copy-paste here what I'm adding, feel free to reply back if
still unclear. (so we don't have to wait another week to discuss the
changes)

XDP programs support creating and passing custom metadata via
``bpf_xdp_adjust_meta``. The metadata can contain some extra information
about the packet: timestamps, hash, vlan and tunneling information, etc.
This metadata can be consumed by the following entities:

> > +
> > +1. ``AF_XDP`` consumer.
> > +2. Kernel core stack via ``XDP_PASS``.
> > +3. Another device via ``bpf_redirect_map``.
> > +4. Other BPF programs via ``bpf_tail_call``.
> > +
> > +General Design
> > +==============
> > +
> > +XDP has access to a set of kfuncs to manipulate the metadata. Every
>
> "...to manipulate the metadata in an XDP frame." ?

SG!

> > +device driver implements these kfuncs. The set of kfuncs is
>
> "Every device driver implements these kfuncs" can you be a bit more
> specific about which types of device drivers will implement these?

How about the following?
Every device driver that wishes to expose additional packet metadata
can implement these kfuncs.

> > +declared in ``include/net/xdp.h`` via ``XDP_METADATA_KFUNC_xxx``.
>
> Why is it suffixed with _xxx?

I'm following the precedent of BTF_SOCK_TYPE_xxx and
BTF_TRACING_TYPE_xxx. LMK if you prefer a better name here.

> > +
> > +Currently, the following kfuncs are supported. In the future, as more
> > +metadata is supported, this set will grow:
> > +
> > +- ``bpf_xdp_metadata_rx_timestamp_supported`` returns true/false to
> > +  indicate whether the device supports RX timestamps
> > +- ``bpf_xdp_metadata_rx_timestamp`` returns packet RX timestamp
>
> s/returns packet/returns a packet's

ty!

> > +- ``bpf_xdp_metadata_rx_hash_supported`` returns true/false to
> > +  indicate whether the device supports RX hash
>
> I don't see bpf_xdp_metadata_rx_timestamp_supported() or
> bpf_xdp_metadata_rx_hash_supported() being added in your patch set. Can
> you remove these entries until they're actually implemented?

Ooh, good catch, I've removed them for this round. Will remove from
the doc as well.

> > +- ``bpf_xdp_metadata_rx_hash`` returns packet RX hash
>
> We should probably also add a note that these kfuncs currently just
> return -EOPNOTSUPP.

The default ones return EOPNOTSUPP. Maybe I can clarify with the following?

Not all kfuncs have to be implemented by the device driver; when not
implemented, the default ones that return ``-EOPNOTSUPP`` will be
used.

> Finally, should we add either some example code showing how to use these
> kfuncs, or at the very least some links to their selftests so readers
> have example code they can refer to?

Good idea, will reference
tools/testing/selftests/bpf/progs/xdp_metadata.c and
tools/testing/selftests/bpf/prog_tests/xdp_metadata.c.

Example
=======
See ``tools/testing/selftests/bpf/progs/xdp_metadata.c`` and
``tools/testing/selftests/bpf/prog_tests/xdp_metadata.c`` for an example of
BPF program that handles XDP metadata.

> > +
> > +Within the XDP frame, the metadata layout is as follows::
> > +
> > +  +----------+-----------------+------+
> > +  | headroom | custom metadata | data |
> > +  +----------+-----------------+------+
> > +             ^                 ^
> > +             |                 |
> > +   xdp_buff->data_meta   xdp_buff->data
> > +
> > +AF_XDP
> > +======
> > +
> > +``AF_XDP`` use-case implies that there is a contract between the BPF program
> > +that redirects XDP frames into the ``XSK`` and the final consumer.
>
> Can you fully spell out what XSK stands for the first time it's used?
> Something like "...that redirects XDP frames into the ``AF_XDP`` socket
> (``XSK``) and the final consumer." Applies anywhere else you think
> appropriate as well.

SG!

> > +Thus the BPF program manually allocates a fixed number of
> > +bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
> > +of kfuncs to populate it. User-space ``XSK`` consumer, looks
>
> s/User-space/The user-space
>
> Also, it feels like it might read better without the comma, and by
> doing something like s/looks at/computes. Wdyt?

Ageed.

> > +at ``xsk_umem__get_data() - METADATA_SIZE`` to locate its metadata.
> > +
> > +Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::
> > +
> > +  +----------+-----------------+------+
> > +  | headroom | custom metadata | data |
> > +  +----------+-----------------+------+
> > +                               ^
> > +                               |
> > +                        rx_desc->address
> > +
> > +XDP_PASS
> > +========
> > +
> > +This is the path where the packets processed by the XDP program are passed
> > +into the kernel. The kernel creates ``skb`` out of the ``xdp_buff`` contents.
>
> s/creates ``skb``/creates the ``skb``

Ack.

> > +Currently, every driver has a custom kernel code to parse the descriptors and
> > +populate ``skb`` metadata when doing this ``xdp_buff->skb`` conversion.
> > +In the future, we'd like to support a case where XDP program can override
>
> s/where XDP program/where an XDP program

Same here, will fix, thanks!

> > +some of that metadata.
> > +
> > +The plan of record is to make this path similar to ``bpf_redirect_map``
> > +so the program can control which metadata is passed to the skb layer.
> > +
> > +bpf_redirect_map
> > +================
> > +
> > +``bpf_redirect_map`` can redirect the frame to a different device.
> > +In this case we don't know ahead of time whether that final consumer
> > +will further redirect to an ``XSK`` or pass it to the kernel via ``XDP_PASS``.
> > +Additionally, the final consumer doesn't have access to the original
> > +hardware descriptor and can't access any of the original metadata.
> > +
> > +For this use-case, only custom metadata is currently supported. If
> > +the frame is eventually passed to the kernel, the skb created from such
> > +a frame won't have any skb metadata. The ``XSK`` consumer will only
> > +have access to the custom metadata.
> > +
> > +bpf_tail_call
> > +=============
> > +
> > +No special handling here. Tail-called program operates on the same context
>
> s/Tail-called program/A tail-called program

Ty!


> > +as the original one.
> > --
> > 2.39.0.rc1.256.g54fd8350bd-goog
> >
