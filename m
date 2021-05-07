Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA85375E99
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 03:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhEGBzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 21:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhEGBzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 21:55:31 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EDEC061574;
        Thu,  6 May 2021 18:54:30 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id u1so4127819qvg.11;
        Thu, 06 May 2021 18:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a+4dNNiI1+2u64fASl7JHolzckwlzH1hpOrNavtuif4=;
        b=Nmtb6cpQ+yEbnxRHw4KiuEyASAmEbgclDkhdLpPM336+li0ZY9IvwYj01QV+JXSUEs
         EkzBPZaNpLlJJqrqx8wnvWtMeeFyFH9WVYBZALnuJpFq3zlWjNTl9VzMbUgo/qBqQ4lS
         frm+vZe9q5Fi7TPPpKmhQbgO9ezpg99/v0Pv0+xNHQNkdvrLz3gmy0Iwx9II/n9K5zcU
         mipPduphRRMUpRhVAB53GheXfBb5JUOOK+3R1ZWX43vTNK9IvukBT3bgWH5bmoRuwJ2F
         ABojNx5xBC7omeS1QqCVAIwFO/tYpqUVuHeWpVEiVVjB4IaHyV8xXlc1NIIXAwT5KsJn
         czRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a+4dNNiI1+2u64fASl7JHolzckwlzH1hpOrNavtuif4=;
        b=q4BHhqAteYIn44ANq+dh0exifEy9aGUZvFfCIfwH1NUDFsN6ND69NC5PRRoqGWmuEH
         Br6w43mZFYQXwHlO5RtjSfZifpaTgsskrazEIqmAfPTwv3r0G26xCyjnHm+lk7MfP8gl
         8NHygw7IUa07gpzX0bcyyLNoLD1/esMLAyIGj8Sy/TlvU+2o34d3ImfpFxzhnWNn4K3u
         ms7+NtZxcVJllrIPTWIrjt7mO5+KTFRNfA/Rf60zmnbMP2Zj15DNqZdo4UlPL1uoe3dT
         C4KUq9QlXZfQeVOt+KwdAxzMaKqJPkWag5LGV5auhzUhrUyX9+E8iScwMTkpuC4wwS+O
         5o/A==
X-Gm-Message-State: AOAM532v1eyCPSifdna4CEpIJmblCVTrECa3wB+zLWAsZ2C9Q54ousbA
        XhvK2RLMkWTahOoZQLRWshc984BzVTyW4Vgt2kE=
X-Google-Smtp-Source: ABdhPJxpCh4QaB+Ozysrm7kXuFm2/+7FkDJ/uoybNP9JrAet8644s0jFRYQOA6BMTQ44A3eHdp/3Wbh/+O3KWLIqTvo=
X-Received: by 2002:ad4:542c:: with SMTP id g12mr7385295qvt.38.1620352469567;
 Thu, 06 May 2021 18:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com> <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
 <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com> <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
 <02c801d7421f$65287a90$2f796fb0$@samsung.com> <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
 <001801d742db$68ab8060$3a028120$@samsung.com> <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
 <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com>
In-Reply-To: <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 6 May 2021 21:53:45 -0400
Message-ID: <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Dongseok Yi <dseok.yi@samsung.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 9:45 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/5/7 9:25, Willem de Bruijn wrote:
> >>>> head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
> >>>> data_len could be 8 if server sent a small size packet and it is GROed
> >>>> to head_skb.
> >>>>
> >>>> Please let me know if I am missing something.
> >>>
> >>> This is my understanding of the data path. This is a forwarding path
> >>> for TCP traffic.
> >>>
> >>> GRO is enabled and will coalesce multiple segments into a single large
> >>> packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
> >>> + 20.
> >>>
> >>> Somewhere between GRO and GSO you have a BPF program that converts the
> >>> IPv6 address to IPv4.
> >>
> >> Your understanding is right. The data path is GRO -> BPF 6 to 4 ->
> >> GSO.
> >>
> >>>
> >>> There is no concept of head_skb at the time of this BPF program. It is
> >>> a single SKB, with an skb linear part and multiple data items in the
> >>> frags (no frag_list).
> >>
> >> Sorry for the confusion. head_skb what I mentioned was a skb linear
> >> part. I'm considering a single SKB with frags too.
> >>
> >>>
> >>> When entering the GSO stack, this single skb now has a payload length
> >>> < MSS. So it would just make a valid TCP packet on its own?
> >>>
> >>> skb_gro_len is only relevant inside the GRO stack. It internally casts
> >>> the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
> >>> reused for other purposes later by other layers of the datapath. It is
> >>> not safe to read this inside bpf_skb_proto_6_to_4.
> >>
> >> The condition what I made uses skb->data_len not skb_gro_len. Does
> >> skb->data_len have a different meaning on each layer? As I know,
> >> data_len indicates the amount of frags or frag_list. skb->data_len
> >> should be > 20 in the sample case because the payload size of the skb
> >> linear part is the same with mss.
> >
> > Ah, got it.
> >
> > data_len is the length of the skb minus the length in the skb linear
> > section (as seen in skb_headlen).
> >
> > So this gso skb consists of two segments, the first one entirely
> > linear, the payload of the second is in skb_shinfo(skb)->frags[0].
> >
> > It is not guaranteed that gso skbs built from two individual skbs end
> > up looking like that. Only protocol headers in the linear segment and
> > the payload of both in frags is common.
> >
> >> We can modify netif_needs_gso as another option to hit
> >> skb_needs_linearize in validate_xmit_skb. But I think we should compare
> >> skb->gso_size and skb->data_len too to check if mss exceed a payload
> >> size.
> >
> > The rest of the stack does not build such gso packets with payload len
> > < mss, so we should not have to add workarounds in the gso hot path
> > for this.
> >
> > Also no need to linearize this skb. I think that if the bpf program
> > would just clear the gso type, the packet would be sent correctly.
> > Unless I'm missing something.
>
> Does the checksum/len field in ip and tcp/udp header need adjusting
> before clearing gso type as the packet has became bigger?

gro takes care of this. see for instance inet_gro_complete for updates
to the ip header.

> Also, instead of testing skb->data_len, may test the skb->len?
>
> skb->len - (mac header + ip/ipv6 header + udp/tcp header) > mss + len_diff

Yes. Essentially doing the same calculation as the gso code that is
causing the packet to be dropped.

> >
> > But I don't mean to argue that it should do that in production.
> > Instead, not playing mss games would solve this and stay close to the
> > original datapath if no bpf program had been present. Including
> > maintaining the GSO invariant of sending out the same chain of packets
> > as received (bar the IPv6 to IPv4 change).
> >
> > This could be achieved by adding support for the flag
> > BPF_F_ADJ_ROOM_FIXED_GSO in the flags field of bpf_skb_change_proto.
> > And similar to bpf_skb_net_shrink:
> >
> >                 /* Due to header shrink, MSS can be upgraded. */
> >                 if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
> >                         skb_increase_gso_size(shinfo, len_diff);
> >
> > The other case, from IPv4 to IPv6 is more difficult to address, as not
> > reducing the MSS will result in packets exceeding MTU. That calls for
> > workarounds like MSS clamping. Anyway, that is out of scope here.
> >
> >
> >
> >>>
> >>>
> >>>>>
> >>>>> One simple solution if this packet no longer needs to be segmented
> >>>>> might be to reset the gso_type completely.
> >>>>
> >>>> I am not sure gso_type can be cleared even when GSO is needed.
> >>>>
> >>>>>
> >>>>> In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
> >>>>> converting from IPv6 to IPv4, fixed gso will end up building packets
> >>>>> that are slightly below the MTU. That opportunity cost is negligible
> >>>>> (especially with TSO). Unfortunately, I see that that flag is
> >>>>> available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.
> >>>>>
> >>>>>
> >>>>>>>> would increse the gso_size to 1392. tcp_gso_segment will get an error
> >>>>>>>> with 1380 <= 1392.
> >>>>>>>>
> >>>>>>>> Check for the size of GROed payload if it is really bigger than target
> >>>>>>>> mss when increase mss.
> >>>>>>>>
> >>>>>>>> Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> >>>>>>>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> >>>>>>>> ---
> >>>>>>>>   net/core/filter.c | 4 +++-
> >>>>>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>>>>>
> >>>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
> >>>>>>>> index 9323d34..3f79e3c 100644
> >>>>>>>> --- a/net/core/filter.c
> >>>>>>>> +++ b/net/core/filter.c
> >>>>>>>> @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> >>>>>>>>             }
> >>>>>>>>
> >>>>>>>>             /* Due to IPv4 header, MSS can be upgraded. */
> >>>>>>>> -           skb_increase_gso_size(shinfo, len_diff);
> >>>>>>>> +           if (skb->data_len > len_diff)
> >>>>>>>
> >>>>>>> Could you elaborate some more on what this has to do with data_len specifically
> >>>>>>> here? I'm not sure I follow exactly your above commit description. Are you saying
> >>>>>>> that you're hitting in tcp_gso_segment():
> >>>>>>>
> >>>>>>>          [...]
> >>>>>>>          mss = skb_shinfo(skb)->gso_size;
> >>>>>>>          if (unlikely(skb->len <= mss))
> >>>>>>>                  goto out;
> >>>>>>>          [...]
> >>>>>>
> >>>>>> Yes, right
> >>>>>>
> >>>>>>>
> >>>>>>> Please provide more context on the bug, thanks!
> >>>>>>
> >>>>>> tcp_gso_segment():
> >>>>>>         [...]
> >>>>>>         __skb_pull(skb, thlen);
> >>>>>>
> >>>>>>         mss = skb_shinfo(skb)->gso_size;
> >>>>>>         if (unlikely(skb->len <= mss))
> >>>>>>         [...]
> >>>>>>
> >>>>>> skb->len will have total GROed TCP payload size after __skb_pull.
> >>>>>> skb->len <= mss will not be happened in a normal GROed situation. But
> >>>>>> bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
> >>>>>> hit an error condition.
> >>>>>>
> >>>>>> We should ensure the following condition.
> >>>>>> total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
> >>>>>>
> >>>>>> Due to
> >>>>>> total GROed TCP payload = the original mss + skb->data_len
> >>>>>> IPv6 size - IPv4 size = len_diff
> >>>>>>
> >>>>>> Finally, we can get the condition.
> >>>>>> skb->data_len > len_diff
> >>>>>>
> >>>>>>>
> >>>>>>>> +                   skb_increase_gso_size(shinfo, len_diff);
> >>>>>>>> +
> >>>>>>>>             /* Header must be checked, and gso_segs recomputed. */
> >>>>>>>>             shinfo->gso_type |= SKB_GSO_DODGY;
> >>>>>>>>             shinfo->gso_segs = 0;
> >>>>>>>>
> >>>>>>
> >>>>>>
> >>>>
> >>
> >
> > .
> >
>
