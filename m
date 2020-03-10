Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E059180209
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCJPi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:38:59 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33498 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:38:59 -0400
Received: by mail-yw1-f65.google.com with SMTP id j186so14066779ywe.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mvFxrbDWOIF1QkpBca/I1v9wjK4kmw3zuNmuqOLdp+Q=;
        b=aQ/Swj5ryBJVds+QhGlanI8SWwKNx5hMwHEZV6l14h0jWzvcznnrtQ0B1tFkl88aZ6
         mnKuuAPoDEqx3fxphYzHtXIULCPSU1OVtkV253WtPYiG1JfHY7BT3nsAgvsrJXjxcEy+
         SdD9d9bSSh8nOPFz2iGFZUtbqA0qX33pPpn237u131fVk8fM7Pp1dM8lFaZ6YNkQX6iA
         5BpiYhSbnmmSJhXxzSNOzP6u3bi55wEAJTc8REtrjLxfKwV/vpYtG/dTRAIB75ilRUGn
         tZswGwqwKz9Oqi4eXJCi5ncABcdsDvPIZSYcDhohO75TP8w6h9Ui/KkiAXFw+REKj8qQ
         /6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvFxrbDWOIF1QkpBca/I1v9wjK4kmw3zuNmuqOLdp+Q=;
        b=hRHrBNed9t1cXmw9Dc5uf1CdRa1JifeA2HKQviRGF60lX02YqFU4PlI9oY/XgaZZ40
         7cwMlOHONa8jJKHfw5joUcWCv7LyBr3sr2RuvjaHuQsGuVEpuB9ML0mp+rVRKpg1KaQW
         xZj6Hae11viFsM7OmrrmjMBNMNf1aXuY3gGkyqWw6yl47ZyzbhMrvAOa24miQeHMPBOx
         zG4Az3VztSwgOu7F0QH1TGb470EBuT0IT1kkh+tKLtEI/B8vpmbaq8RzqWO7Cs2wpm6W
         O+DLyyqfLaqjCjxwSUEF5fbIoMfUU2wvnh5lbuDnfNO91HBE1ntrhpDQu0+463ePhTU/
         MWeQ==
X-Gm-Message-State: ANhLgQ1+JcfYYj8e4WOKKdKIW/J9UdmkdruHj0sYEaQ+dAHEWLQcaWDy
        AMuPUy69wOSdEpcRLc10DrZogcB1
X-Google-Smtp-Source: ADFU+vtnd9I9UUWn14RUBR0XcMyOUqrSlzml4J70UwKqiNN9FFIdqYxJdqvkZ5PYYPq+LOFKyfRt+Q==
X-Received: by 2002:a81:55d8:: with SMTP id j207mr19408223ywb.77.1583854735818;
        Tue, 10 Mar 2020 08:38:55 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id u127sm19035040ywb.68.2020.03.10.08.38.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 08:38:54 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id t141so13986913ywc.11
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:38:54 -0700 (PDT)
X-Received: by 2002:a81:f10a:: with SMTP id h10mr22571037ywm.109.1583854733745;
 Tue, 10 Mar 2020 08:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200310023528-mutt-send-email-mst@kernel.org> <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
 <20200310085437-mutt-send-email-mst@kernel.org> <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
 <20200310104024-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200310104024-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 10 Mar 2020 11:38:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
Message-ID: <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 10:44 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Mar 10, 2020 at 10:16:56AM -0400, Willem de Bruijn wrote:
> > On Tue, Mar 10, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> > > > On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > > > > From: Willem de Bruijn <willemb@google.com>
> > > > > >
> > > > > > In one error case, tpacket_rcv drops packets after incrementing the
> > > > > > ring producer index.
> > > > > >
> > > > > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > > > > thus the reader is stalled for an iteration of the ring, causing out
> > > > > > of order arrival.
> > > > > >
> > > > > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > > > > to encountering an unknown GSO type.
> > > > > >
> > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > >
> > > > > > ---
> > > > > >
> > > > > > I wonder whether it should drop packets with unknown GSO types at all.
> > > > > > This consistently blinds the reader to certain packets, including
> > > > > > recent UDP and SCTP GSO types.
> > > > >
> > > > > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > > > > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > > > > thing to do here is actually to split these packets up, not drop them.
> > > >
> > > > In the main virtio users, virtio_net/tun/tap, the packets will always
> > > > arrive segmented, due to these devices not advertising hardware
> > > > segmentation for these protocols.
> > >
> > > Oh right. That's good then, sorry about the noise.
> >
> > Not at all. Thanks for taking a look!
> >
> > > > So the issue is limited to users of tpacket_rcv, which is relatively
> > > > new. There too it is limited on egress to devices that do advertise
> > > > h/w offload. And on r/x to GRO.
> > > >
> > > > The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> > > > goes back to my (argh!) introduction of the feature on the egress
> > > > path.
> > > >
> > > > >
> > > > > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > > > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > > > > let the peer at least be aware of failure.
> > > > > >
> > > > > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> > > > >
> > > > > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > > > > we'll need more flags to know whether it's safe to pass
> > > > > these types to userspace.
> > > >
> > > > Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> > > > -EINVAL on unknown GSO types and its callers just drop these packets,
> > > > it looks to me that the infra is future proof wrt adding new GSO
> > > > types.
> > >
> > > Oh I mean if we do want to add new types and want to pass them to
> > > users, then virtio_net_hdr_from_skb will need to flag so it
> > > knows whether that will or won't confuse userspace.
> >
> > I'm not sure how that would work. Ignoring other tun/tap/virtio for
> > now, just looking at tpacket, a new variant of socket option for
> > PACKET_VNET_HDR, for every new GSO type?
>
> Maybe a single one with a bitmap of legal types?
>
> > In practice the userspace I'm aware of, and any sane implementation,
> > will be future proof to drop and account packets whose type it cannot
> > process. So I think we can just add new types.
>
> Well if packets are just dropped then userspace breaks right?

It is an improvement over the current silent discard in the kernel.

If it can count these packets, userspace becomes notified that it
should perhaps upgrade or use ethtool to stop the kernel from
generating certain packets.

Specifically for packet sockets, it wants to receive packets as they
appear "on the wire". It does not have to drop these today even, but
can easily parse the headers.

For packet sockets at least, I don't think that we want transparent
segmentation.


> So we'll really need to split up packets when this happens.
