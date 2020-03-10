Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8101802EA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCJQPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:15:17 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:47060 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJQPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:15:16 -0400
Received: by mail-yw1-f68.google.com with SMTP id x5so13273631ywb.13
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Zd7vwukQvaf2Hr5bfQdGP2vSp7bvHEm9dRFoNTfjrY=;
        b=c0mv2QM2Lg9jeKEJy/dLYETDiUYHtzPX8FF7NT0GHvhfFgXwUS8NJzEq4a0q/7KzCn
         sHOwzJABkO4r+66NYrq4K9R3PLGWgXkeM1SIO1NR5k5p8nxl2nnrSBmk1u410Ggs5R2Y
         3+19KyzrmTmRakPVCIwRIsZNlrs4WwVNnGRP+5qCP8CgJpd0CrLt7rOkI7Gw6w6UKet2
         gEpGfo5EjHwhxgik/3SMh1U0UjoomeQM+xPhcrUHJuHNgJFTLtNjXzIt2+BOhPEo4cL2
         WhsxH2+HajlPBi7VfqDFnTT7tIgCdD2Hn6b0fpanMUqfyn4I6Rq8xkZ9EPk276bLebu2
         RH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Zd7vwukQvaf2Hr5bfQdGP2vSp7bvHEm9dRFoNTfjrY=;
        b=TCSBnV23W3sjlOwPtd9pJcdacR4qKrEttW9XWQ2csiHlXbKX9bHrOjpHTDHC2VlAYl
         8fsiXJ3ZUxfONz2SMSQWc+DK8p+HfolIWo1ZTJ94Wv4z9+enx/exyxv+HDxetYD5GSRT
         PVzVvni7ixJxcNVgueQUjfgL1cyFrKmbQJ0XiMhdMUPHqhbawl63W8sUCBGbVmY4IDId
         FbvGFMUWKW4zO6qrXZbM4v0yQGil8Si16vVUDrMPjACGGBVhDcQVvc/TSJOZODwAunIC
         D7FKzuzUb11Ez8Docp3JwXVDeazyoqI25p6rC8jx24Y400lx9XlvP04RUbUfVVqV/U7e
         mcdQ==
X-Gm-Message-State: ANhLgQ2cKq4o0O1g8118i4NbpPUbWOMA2Ba68v66eODafrADYI6+Me/Y
        rgvN8/h3G2+kufVm3YawRZxbd82T
X-Google-Smtp-Source: ADFU+vuLnTX8gJexXMDy96NsQe/E+Srpba+qLg23a8522Y1/7A+pasi/+BJmMtXSrVTvYCTW8eHv7Q==
X-Received: by 2002:a81:4c8b:: with SMTP id z133mr22922114ywa.344.1583856913451;
        Tue, 10 Mar 2020 09:15:13 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id u81sm8375842ywu.6.2020.03.10.09.15.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 09:15:12 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id j186so14192151ywe.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:15:12 -0700 (PDT)
X-Received: by 2002:a25:c687:: with SMTP id k129mr24109950ybf.441.1583856911517;
 Tue, 10 Mar 2020 09:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200310023528-mutt-send-email-mst@kernel.org> <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
 <20200310085437-mutt-send-email-mst@kernel.org> <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
 <20200310104024-mutt-send-email-mst@kernel.org> <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
In-Reply-To: <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 10 Mar 2020 12:14:34 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfqctjnMw2pg5s10MW-7fQJx_rkhrtZ2YgBr1ywq1CtLw@mail.gmail.com>
Message-ID: <CA+FuTSfqctjnMw2pg5s10MW-7fQJx_rkhrtZ2YgBr1ywq1CtLw@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 11:38 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Mar 10, 2020 at 10:44 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 10:16:56AM -0400, Willem de Bruijn wrote:
> > > On Tue, Mar 10, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> > > > > On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > > > > > From: Willem de Bruijn <willemb@google.com>
> > > > > > >
> > > > > > > In one error case, tpacket_rcv drops packets after incrementing the
> > > > > > > ring producer index.
> > > > > > >
> > > > > > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > > > > > thus the reader is stalled for an iteration of the ring, causing out
> > > > > > > of order arrival.
> > > > > > >
> > > > > > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > > > > > to encountering an unknown GSO type.
> > > > > > >
> > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > >
> > > > > > > ---
> > > > > > >
> > > > > > > I wonder whether it should drop packets with unknown GSO types at all.
> > > > > > > This consistently blinds the reader to certain packets, including
> > > > > > > recent UDP and SCTP GSO types.
> > > > > >
> > > > > > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > > > > > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > > > > > thing to do here is actually to split these packets up, not drop them.
> > > > >
> > > > > In the main virtio users, virtio_net/tun/tap, the packets will always
> > > > > arrive segmented, due to these devices not advertising hardware
> > > > > segmentation for these protocols.
> > > >
> > > > Oh right. That's good then, sorry about the noise.
> > >
> > > Not at all. Thanks for taking a look!
> > >
> > > > > So the issue is limited to users of tpacket_rcv, which is relatively
> > > > > new. There too it is limited on egress to devices that do advertise
> > > > > h/w offload. And on r/x to GRO.
> > > > >
> > > > > The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> > > > > goes back to my (argh!) introduction of the feature on the egress
> > > > > path.
> > > > >
> > > > > >
> > > > > > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > > > > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > > > > > let the peer at least be aware of failure.
> > > > > > >
> > > > > > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> > > > > >
> > > > > > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > > > > > we'll need more flags to know whether it's safe to pass
> > > > > > these types to userspace.
> > > > >
> > > > > Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> > > > > -EINVAL on unknown GSO types and its callers just drop these packets,
> > > > > it looks to me that the infra is future proof wrt adding new GSO
> > > > > types.
> > > >
> > > > Oh I mean if we do want to add new types and want to pass them to
> > > > users, then virtio_net_hdr_from_skb will need to flag so it
> > > > knows whether that will or won't confuse userspace.
> > >
> > > I'm not sure how that would work. Ignoring other tun/tap/virtio for
> > > now, just looking at tpacket, a new variant of socket option for
> > > PACKET_VNET_HDR, for every new GSO type?
> >
> > Maybe a single one with a bitmap of legal types?
> >
> > > In practice the userspace I'm aware of, and any sane implementation,
> > > will be future proof to drop and account packets whose type it cannot
> > > process. So I think we can just add new types.
> >
> > Well if packets are just dropped then userspace breaks right?
>
> It is an improvement over the current silent discard in the kernel.
>
> If it can count these packets, userspace becomes notified that it
> should perhaps upgrade or use ethtool to stop the kernel from
> generating certain packets.
>
> Specifically for packet sockets, it wants to receive packets as they
> appear "on the wire". It does not have to drop these today even, but
> can easily parse the headers.
>
> For packet sockets at least, I don't think that we want transparent
> segmentation.

Or more succinct:

For packet sockets I think we should pass everything up to userspace
as it is. Then virtio_net_hdr_from_skb never has to fail. And this
patch is unnecessary.

But we would need at least one new VIRTIO_NET_HDR_GSO_UNKNOWN type.
And only use that on packet sockets, keeping existing EINVAL in the
(indeed unexpected) case such packets make it to virtio_net or tun/tap
ndo_start_xmit.
