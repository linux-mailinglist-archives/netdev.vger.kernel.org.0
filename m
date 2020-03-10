Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8123817FFFD
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 15:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgCJORi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 10:17:38 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38719 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgCJORi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 10:17:38 -0400
Received: by mail-yw1-f67.google.com with SMTP id 10so13743549ywv.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 07:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H0xK+cQLB44L8vtNb0p8dGjF64Se24hVcL6djYOD4zo=;
        b=M0eRY5JDjmCdQrBgyjEKijH+yAvz5LEcy71dxdlEre6pARYZNGWsVpAzvxoJUTNc6W
         /D6ppjaAYYUvHZDxqx/PjnlhTt3ZyHsydhWVGpcZhLYn7UhcPVV3/ImiL9teqXK2sYNm
         Oassy2XAEqvraYX0yO5rVyuM5mWeyjDIN4tGKyS2FhvqxhGC70mleSmBy7HbUGz2ObO+
         HjE73JNl5prAcNFa8izcapdnSSlvru3OlL+WVcN2DDpWHqLXvvdCFQnus091ksYHVsmx
         fPFdfSPGEz2DeVSpjBZuODU40HMsBBrwMvW4K75B8+PIJp0ICjgO3pkoZLXsGDwRrq2W
         ahwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H0xK+cQLB44L8vtNb0p8dGjF64Se24hVcL6djYOD4zo=;
        b=Sad6ikGTQUrxAPDMbmBeivx959jGUdUn4TbU4ryT1v5NXZD9yEJZxCC8E8MTghgkJu
         TWXlQqQbciVw5mTvvrZVncF8yzXgIHiakPWJtOp9ugcsUz4gVJyvtoMKTHqkI/rSG4a0
         a6JQpD1YpTkZK714PJsVVAn898EiKcPOFhw77TIIfQ0oqLfmg+DCKh7qokqqKa1R4YK/
         205t4LokZMsbJod7WT6luwxPd1XlnrnOuh/eO6qgxSopIOxuHuPjWo0Z89ahs4LuoZ2m
         9wO+8cgPPFVmaRalUwSR7+VW3TD2CYU5nT25SnxfQyaSiL2UD2Ib6U9/mTiaa/gyceJS
         LUug==
X-Gm-Message-State: ANhLgQ0psy5aqOmN/oq11qoNZPFmS4c/ZIC50cgUklHfOsn+8UKhrN7n
        r79ATR065jTTW6ufcArCbyYmDG8C
X-Google-Smtp-Source: ADFU+vtZTqD8WxXbF3MGhW9WU73D738N3WhegXfKxL1YYhjR9Y709tUVdkYBjJE9G5XPuILfVOwPmg==
X-Received: by 2002:a25:260a:: with SMTP id m10mr2035184ybm.514.1583849855065;
        Tue, 10 Mar 2020 07:17:35 -0700 (PDT)
Received: from mail-yw1-f45.google.com (mail-yw1-f45.google.com. [209.85.161.45])
        by smtp.gmail.com with ESMTPSA id u127sm18944248ywb.68.2020.03.10.07.17.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 07:17:34 -0700 (PDT)
Received: by mail-yw1-f45.google.com with SMTP id o186so13791004ywc.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 07:17:34 -0700 (PDT)
X-Received: by 2002:a5b:7ce:: with SMTP id t14mr23700611ybq.492.1583849853437;
 Tue, 10 Mar 2020 07:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
 <20200310023528-mutt-send-email-mst@kernel.org> <CA+FuTSd=oLQhtKet-n5r++3HHmHR+5rMkDqSMyjArOBfF4vsKw@mail.gmail.com>
 <20200310085437-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200310085437-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 10 Mar 2020 10:16:56 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
Message-ID: <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
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

On Tue, Mar 10, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Mar 10, 2020 at 08:49:23AM -0400, Willem de Bruijn wrote:
> > On Tue, Mar 10, 2020 at 2:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> > > > From: Willem de Bruijn <willemb@google.com>
> > > >
> > > > In one error case, tpacket_rcv drops packets after incrementing the
> > > > ring producer index.
> > > >
> > > > If this happens, it does not update tp_status to TP_STATUS_USER and
> > > > thus the reader is stalled for an iteration of the ring, causing out
> > > > of order arrival.
> > > >
> > > > The only such error path is when virtio_net_hdr_from_skb fails due
> > > > to encountering an unknown GSO type.
> > > >
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > >
> > > > ---
> > > >
> > > > I wonder whether it should drop packets with unknown GSO types at all.
> > > > This consistently blinds the reader to certain packets, including
> > > > recent UDP and SCTP GSO types.
> > >
> > > Ugh it looks like you have found a bug.  Consider a legacy userspace -
> > > it was actually broken by adding USD and SCTP GSO.  I suspect the right
> > > thing to do here is actually to split these packets up, not drop them.
> >
> > In the main virtio users, virtio_net/tun/tap, the packets will always
> > arrive segmented, due to these devices not advertising hardware
> > segmentation for these protocols.
>
> Oh right. That's good then, sorry about the noise.

Not at all. Thanks for taking a look!

> > So the issue is limited to users of tpacket_rcv, which is relatively
> > new. There too it is limited on egress to devices that do advertise
> > h/w offload. And on r/x to GRO.
> >
> > The UDP GSO issue precedes the fraglist GRO patch, by the way, and
> > goes back to my (argh!) introduction of the feature on the egress
> > path.
> >
> > >
> > > > The peer function virtio_net_hdr_to_skb already drops any packets with
> > > > unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> > > > let the peer at least be aware of failure.
> > > >
> > > > And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
> > >
> > > This last one is possible for sure, but for virtio_net_hdr_from_skb
> > > we'll need more flags to know whether it's safe to pass
> > > these types to userspace.
> >
> > Can you elaborate? Since virtio_net_hdr_to_skb users already returns
> > -EINVAL on unknown GSO types and its callers just drop these packets,
> > it looks to me that the infra is future proof wrt adding new GSO
> > types.
>
> Oh I mean if we do want to add new types and want to pass them to
> users, then virtio_net_hdr_from_skb will need to flag so it
> knows whether that will or won't confuse userspace.

I'm not sure how that would work. Ignoring other tun/tap/virtio for
now, just looking at tpacket, a new variant of socket option for
PACKET_VNET_HDR, for every new GSO type?

In practice the userspace I'm aware of, and any sane implementation,
will be future proof to drop and account packets whose type it cannot
process. So I think we can just add new types.

In the worst case, arrival of these packets is under admin control with ethtool.
