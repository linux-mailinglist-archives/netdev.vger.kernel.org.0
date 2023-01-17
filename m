Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C790670B22
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjAQWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjAQWD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 17:03:59 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FE73A878
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:33:20 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9so34716250pll.9
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xlv20x7rc2LFeLXWCgfj7A8D+eK5VfQcM6xak5NBrHI=;
        b=A8HZXITwr1t8gOcv/TDVWtSCFBu7YyUKhYOkW6CnEb2M33k8a3Z2YMXnJBARTJ/qd9
         2bgRfw1DXbl8HO+VYQ+6JQEDXveXkTHjc54I9Y4ZfD3703hAhytKIvbgWx3rcJur3K+0
         GZp+Wn3orFuxgN6Ysw9OV6BkddjMcfdec6x32QpFSVej4ly0r0uHC9Pd0Y+p8TcCfRa1
         I+LzMAkxAl0yZkM4GwZ28C+hSbHWhxYShYDo/C3vxE0Nrb/BQxVVJXlbZUeOAOqyV30W
         4dVDTKfmhT06qr/yR2e1yqDZo1O6UlksagiShSQJKfgLcS8sy1fHSEQvgAqA54WWWEgj
         TQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xlv20x7rc2LFeLXWCgfj7A8D+eK5VfQcM6xak5NBrHI=;
        b=1+626+9do1Ao1+nxEAl0SUc7HT/rPI3TQx/JN1B5mDBGV9odlYiI7jyi0DE/cDsGw/
         m4mc6B5wIpf0vkdg7Euqu1Us/+5MY02jp9M7R0XINZjobr5cjZNfgozk6CJl7rDj2n+x
         RiK2LjmLZeDqL9d8eWcn/Y8ulDjOkckg0u/88LTn8MMSsS6CMi5EYKnvFdoWJ1p7OgYj
         oeXFtimb9t/F3gs/nsaECKrvu7ZFI9augGVrZXRmDx/c95Zv5MjQ1+pw6zSqvHEdhS90
         6oF4fuggbgv1BymfI++1URkuJY+X1vcyTKOry2k8M19WV3D3aBWv5hmuSzvRBHNA5fmV
         pNrA==
X-Gm-Message-State: AFqh2koshfgB3TLtoCEuqS0EAPulpFd+mjlqRCYtz5UPK8OZl9sQeGRf
        Mwslr+QiMVXlBm6ISXdOnklYS2/rxmPSCEr+LctjxA==
X-Google-Smtp-Source: AMrXdXs31p2u7HdHURCDmgZUyiEEHOQgVtrLzvGkLz9p2WGBfGTt92nBPq2q2xMgxfh0i8SA4nzOD1q+h8+gor/tVSU=
X-Received: by 2002:a17:902:c506:b0:194:b553:234d with SMTP id
 o6-20020a170902c50600b00194b553234dmr76045plx.62.1673987599489; Tue, 17 Jan
 2023 12:33:19 -0800 (PST)
MIME-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com> <20230112003230.3779451-2-sdf@google.com>
 <affeb1e3-69e6-9783-0012-6d917972ba30@redhat.com>
In-Reply-To: <affeb1e3-69e6-9783-0012-6d917972ba30@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 17 Jan 2023 12:33:07 -0800
Message-ID: <CAKH8qBuE5ipcncQ+=su_Ds1EHm5gUMG_od-+eqJHkuiV-Q6RhQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 01/17] bpf: Document XDP RX metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, David Vernet <void@manifault.com>
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

On Mon, Jan 16, 2023 at 5:09 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 12/01/2023 01.32, Stanislav Fomichev wrote:
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
> > Acked-by: David Vernet <void@manifault.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   Documentation/networking/index.rst           |   1 +
> >   Documentation/networking/xdp-rx-metadata.rst | 108 +++++++++++++++++++
> >   2 files changed, 109 insertions(+)
> >   create mode 100644 Documentation/networking/xdp-rx-metadata.rst
> >
> > diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> > index 4f2d1f682a18..4ddcae33c336 100644
> > --- a/Documentation/networking/index.rst
> > +++ b/Documentation/networking/index.rst
> > @@ -120,6 +120,7 @@ Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
> >      xfrm_proc
> >      xfrm_sync
> >      xfrm_sysctl
> > +   xdp-rx-metadata
> >
> >   .. only::  subproject and html
> >
> > diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
> > new file mode 100644
> > index 000000000000..b6c8c77937c4
> > --- /dev/null
> > +++ b/Documentation/networking/xdp-rx-metadata.rst
> > @@ -0,0 +1,108 @@
> > +===============
> > +XDP RX Metadata
> > +===============
> > +
> > +This document describes how an eXpress Data Path (XDP) program can access
> > +hardware metadata related to a packet using a set of helper functions,
> > +and how it can pass that metadata on to other consumers.
> > +
> > +General Design
> > +==============
> > +
> > +XDP has access to a set of kfuncs to manipulate the metadata in an XDP frame.
> > +Every device driver that wishes to expose additional packet metadata can
> > +implement these kfuncs. The set of kfuncs is declared in ``include/net/xdp.h``
> > +via ``XDP_METADATA_KFUNC_xxx``.
> > +
> > +Currently, the following kfuncs are supported. In the future, as more
> > +metadata is supported, this set will grow:
> > +
> > +.. kernel-doc:: net/core/xdp.c
> > +   :identifiers: bpf_xdp_metadata_rx_timestamp bpf_xdp_metadata_rx_hash
> > +
> > +An XDP program can use these kfuncs to read the metadata into stack
> > +variables for its own consumption. Or, to pass the metadata on to other
> > +consumers, an XDP program can store it into the metadata area carried
> > +ahead of the packet.
> > +
> > +Not all kfuncs have to be implemented by the device driver; when not
> > +implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
> > +
> > +Within an XDP frame, the metadata layout is as follows::
>
> Below diagram describes XDP buff (xdp_buff), but text says 'XDP frame'.
> So XDP frame isn't referring literally to xdp_frame, which I find
> slightly confusing.
> It is likely because I think too much about the code and the different
> objects, xdp_frame, xdp_buff, xdp_md (xdp ctx seen be bpf-prog).
>
> I tried to grep in the (recent added) bpf/xdp docs to see if there is a
> definition of a XDP "packet" or "frame".  Nothing popped up, except that
> Documentation/bpf/map_cpumap.rst talks about raw ``xdp_frame`` objects.
>
> Perhaps we can improve this doc by calling out xdp_buff here, like:
>
>   Within an XDP frame, the metadata layout (accessed via ``xdp_buff``)
> is as follows::

Sure, will amend!

> > +
> > +  +----------+-----------------+------+
> > +  | headroom | custom metadata | data |
> > +  +----------+-----------------+------+
> > +             ^                 ^
> > +             |                 |
> > +   xdp_buff->data_meta   xdp_buff->data
> > +
> > +An XDP program can store individual metadata items into this ``data_meta``
> > +area in whichever format it chooses. Later consumers of the metadata
> > +will have to agree on the format by some out of band contract (like for
> > +the AF_XDP use case, see below).
> > +
> > +AF_XDP
> > +======
> > +
> > +:doc:`af_xdp` use-case implies that there is a contract between the BPF
> > +program that redirects XDP frames into the ``AF_XDP`` socket (``XSK``) and
> > +the final consumer. Thus the BPF program manually allocates a fixed number of
> > +bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
> > +of kfuncs to populate it. The userspace ``XSK`` consumer computes
> > +``xsk_umem__get_data() - METADATA_SIZE`` to locate that metadata.
> > +Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
> > +``METADATA_SIZE`` is an application-specific constant.
>
> The main problem with AF_XDP and metadata is that, the AF_XDP descriptor
> doesn't contain any info about the length METADATA_SIZE.
>
> The text does says this, but in a very convoluted way.
> I think this challenge should be more clearly spelled out.
>
> (p.s. This was something that XDP-hints via BTF have a proposed solution
> for)

Any suggestions on how to clarify it better? I have two hints:
1. ``METADATA_SIZE`` is an application-specific constant
2. note missing ``data_meta`` pointer

Do you prefer I also add a sentence where I spell it out more
explicitly? Something like:

Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
``METADATA_SIZE`` is an application-specific constant (``AF_XDP``
receive descriptor does _not_ explicitly carry the size of the
metadata).

> > +
> > +Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::
>
> The "note" also hint to this issue.

This seems like an explicit design choice of the AF_XDP? In theory, I
don't see why we can't have a v2 receive descriptor format where we
return the size of the metadata?

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
> > +into the kernel. The kernel creates the ``skb`` out of the ``xdp_buff``
> > +contents. Currently, every driver has custom kernel code to parse
> > +the descriptors and populate ``skb`` metadata when doing this ``xdp_buff->skb``
> > +conversion, and the XDP metadata is not used by the kernel when building
> > +``skbs``. However, TC-BPF programs can access the XDP metadata area using
> > +the ``data_meta`` pointer.
> > +
> > +In the future, we'd like to support a case where an XDP program
> > +can override some of the metadata used for building ``skbs``.
>
> Happy this is mentioned as future work.

As mentioned in a separate email, if you prefer to focus on that, feel
free to drive it since I'm gonna look into the TX side first.

> > +
> > +bpf_redirect_map
> > +================
> > +
> > +``bpf_redirect_map`` can redirect the frame to a different device.
> > +Some devices (like virtual ethernet links) support running a second XDP
> > +program after the redirect. However, the final consumer doesn't have
> > +access to the original hardware descriptor and can't access any of
> > +the original metadata. The same applies to XDP programs installed
> > +into devmaps and cpumaps.
> > +
> > +This means that for redirected packets only custom metadata is
> > +currently supported, which has to be prepared by the initial XDP program
> > +before redirect. If the frame is eventually passed to the kernel, the
> > +``skb`` created from such a frame won't have any hardware metadata populated
> > +in its ``skb``. If such a packet is later redirected into an ``XSK``,
> > +that will also only have access to the custom metadata.
> > +
>
> Good that this is documented, but I hope we can fix/improve this as
> future work.

Definitely! Hopefully documenting it here acts as a sort-of TODO which
we can eventually address. Maybe even starting with a section here on
how it is supposed to work :-)


> > +bpf_tail_call
> > +=============
> > +
> > +Adding programs that access metadata kfuncs to the ``BPF_MAP_TYPE_PROG_ARRAY``
> > +is currently not supported.
> > +
> > +Example
> > +=======
> > +
> > +See ``tools/testing/selftests/bpf/progs/xdp_metadata.c`` and
> > +``tools/testing/selftests/bpf/prog_tests/xdp_metadata.c`` for an example of
> > +BPF program that handles XDP metadata.
>
>
> --Jesper
>
