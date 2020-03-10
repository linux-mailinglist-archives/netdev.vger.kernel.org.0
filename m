Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E468180A96
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgCJVgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:36:38 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42785 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgCJVgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 17:36:38 -0400
Received: by mail-yw1-f65.google.com with SMTP id v138so4585ywa.9
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 14:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UwAZ6MWeOOg83hHixSHvw3Opzj/vsfMy5lzi9+KmKJI=;
        b=ZUaWjJblD8shHWgfrp1Cd6KayaP6GupdMo5rwZLwz6/uiNHQ8fKBcZP34nYcT3yl4e
         o/dKgibZshmT4mOUcpV59m1C/YRd+csYqZMRucs4DjGTEEaJ2x+tX1DNELkZjkycQqiI
         1KlfgCDsdZ7FThRwDZWbXxFkK9nfNjFTs6iSoRzJvY8g3+Qpm//Fp2fCAP3co7loNGyL
         scf6AL6WbewJc36L/8YYY2gZ44vPhdZnIfhx5W/0n+6i+BsNsapc97z5YV3Ca85zWn5D
         XA/j+fyNx73lNhfY4H760ZnxzwGYl2RljL8mVCMPKQmzxAH4MM3OF+mapsHdgwey6fis
         JvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UwAZ6MWeOOg83hHixSHvw3Opzj/vsfMy5lzi9+KmKJI=;
        b=rEiToj4qSCm7lNA52z+o+dNv15VfrB0OFKgr08kn/zZ9h18Ma1XbthVCKI6myUGeKV
         wHg1VXr4DaTfron8Mw6KjqIh5eG67Vhxtc0baeQGmlmf8Apq6VZNDavhnMrwlPb5MwsO
         dPWlZP58Ek2R+J5Zxp5WM4qujxruXegl7Q5+1C2JMnQvCYboh0WIQidt5Nn7WWStYoQW
         KZiYu9NhfPRU1pXE2MYF+yHT32gLQVkagPqYfv7y89CsOUyT79QGbj/2jKMjdcMQQIhI
         deFYZXnxzFbvfFLOoV5mxgXMXeAQ5KkMoFxTIQD2gzT3wpYJ5kWQ4+g9euzXi8LSU3dd
         X9SQ==
X-Gm-Message-State: ANhLgQ3HEXM7qM4bGvjlEOLUY35RFRhjPVT3InGmyYB3KwGtP+FgywhN
        HS2j2nMDcMQWvtYpfktqqezmddEs
X-Google-Smtp-Source: ADFU+vvlsMECEgeyRT2ArSfOwNezZULPcleu4vnl5dgsZFwPUD3kQ98T3i+ozqov42ESorg8dCAD2A==
X-Received: by 2002:a81:85c1:: with SMTP id v184mr21665951ywf.53.1583876195331;
        Tue, 10 Mar 2020 14:36:35 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id l20sm4178107ywc.36.2020.03.10.14.36.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 14:36:34 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id j186so55760ywe.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 14:36:34 -0700 (PDT)
X-Received: by 2002:a5b:7ce:: with SMTP id t14mr25764327ybq.492.1583876193982;
 Tue, 10 Mar 2020 14:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200310023528-mutt-send-email-mst@kernel.org> <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
 <20200310085437-mutt-send-email-mst@kernel.org> <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
 <20200310104024-mutt-send-email-mst@kernel.org> <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
 <20200310172833-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200310172833-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 10 Mar 2020 17:35:55 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfrjThis9UchhiKE2ibMKVgCvfTdbeB0Q33XiTDLBEX8w@mail.gmail.com>
Message-ID: <CA+FuTSfrjThis9UchhiKE2ibMKVgCvfTdbeB0Q33XiTDLBEX8w@mail.gmail.com>
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

On Tue, Mar 10, 2020 at 5:30 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Mar 10, 2020 at 11:38:16AM -0400, Willem de Bruijn wrote:
> > On Tue, Mar 10, 2020 at 10:44 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Mar 10, 2020 at 10:16:56AM -0400, Willem de Bruijn wrote:
> > > > On Tue, Mar 10, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> > > > > > On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > > > > > > From: Willem de Bruijn <willemb@google.com>
> > > > > > > >
> > > > > > > > In one error case, tpacket_rcv drops packets after incrementing the
> > > > > > > > ring producer index.
> > > > > > > >
> > > > > > > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > > > > > > thus the reader is stalled for an iteration of the ring, causing out
> > > > > > > > of order arrival.
> > > > > > > >
> > > > > > > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > > > > > > to encountering an unknown GSO type.
> > > > > > > >
> > > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > > >
> > > > > > > > ---
> > > > > > > >
> > > > > > > > I wonder whether it should drop packets with unknown GSO types at all.
> > > > > > > > This consistently blinds the reader to certain packets, including
> > > > > > > > recent UDP and SCTP GSO types.
> > > > > > >
> > > > > > > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > > > > > > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > > > > > > thing to do here is actually to split these packets up, not drop them.
> > > > > >
> > > > > > In the main virtio users, virtio_net/tun/tap, the packets will always
> > > > > > arrive segmented, due to these devices not advertising hardware
> > > > > > segmentation for these protocols.
> > > > >
> > > > > Oh right. That's good then, sorry about the noise.
> > > >
> > > > Not at all. Thanks for taking a look!
> > > >
> > > > > > So the issue is limited to users of tpacket_rcv, which is relatively
> > > > > > new. There too it is limited on egress to devices that do advertise
> > > > > > h/w offload. And on r/x to GRO.
> > > > > >
> > > > > > The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> > > > > > goes back to my (argh!) introduction of the feature on the egress
> > > > > > path.
> > > > > >
> > > > > > >
> > > > > > > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > > > > > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > > > > > > let the peer at least be aware of failure.
> > > > > > > >
> > > > > > > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> > > > > > >
> > > > > > > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > > > > > > we'll need more flags to know whether it's safe to pass
> > > > > > > these types to userspace.
> > > > > >
> > > > > > Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> > > > > > -EINVAL on unknown GSO types and its callers just drop these packets,
> > > > > > it looks to me that the infra is future proof wrt adding new GSO
> > > > > > types.
> > > > >
> > > > > Oh I mean if we do want to add new types and want to pass them to
> > > > > users, then virtio_net_hdr_from_skb will need to flag so it
> > > > > knows whether that will or won't confuse userspace.
> > > >
> > > > I'm not sure how that would work. Ignoring other tun/tap/virtio for
> > > > now, just looking at tpacket, a new variant of socket option for
> > > > PACKET_VNET_HDR, for every new GSO type?
> > >
> > > Maybe a single one with a bitmap of legal types?
> > >
> > > > In practice the userspace I'm aware of, and any sane implementation,
> > > > will be future proof to drop and account packets whose type it cannot
> > > > process. So I think we can just add new types.
> > >
> > > Well if packets are just dropped then userspace breaks right?
> >
> > It is an improvement over the current silent discard in the kernel.
> >
> > If it can count these packets, userspace becomes notified that it
> > should perhaps upgrade or use ethtool to stop the kernel from
> > generating certain packets.
> >
> > Specifically for packet sockets, it wants to receive packets as they
> > appear "on the wire". It does not have to drop these today even, but
> > can easily parse the headers.
> >
> > For packet sockets at least, I don't think that we want transparent
> > segmentation.
>
> Well it's GSO is in the way then it's no longer "on the wire", right?
> Whether we split these back to individual skbs or we don't
> it's individual packets that are on the wire. GSO just allows
> passing them to the application in a more efficient way.

Not entirely. With TSO enabled, packet sockets will show the TCP TSO
packets, not the individual segment on the wire.
