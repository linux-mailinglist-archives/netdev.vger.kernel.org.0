Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F54F3761E9
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbhEGI07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:26:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47780 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbhEGI05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:26:57 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210507082556epoutp02f75eef90d3dd1f229d6e0ea3e5b46a38~8u1j7ex2u2359423594epoutp02D
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 08:25:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210507082556epoutp02f75eef90d3dd1f229d6e0ea3e5b46a38~8u1j7ex2u2359423594epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620375956;
        bh=PP0oZsQYkZyh4APsugyeiQVaTOcbWDnNn+/m9GYpr2Q=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ggIoLQiBnXv5/gbovgSz7JOIfQQnBIgRd4pRaSgX1zEO4DSNy3B5KKkYCMkBzVXos
         Ltt1gpJvyGl6AtcI4a2oPVU7fIfYH8+otB/2gBP6a6GNv2apaO66iM8tivQzRAC2oU
         WyBRapoj4lhkmBwHTQBBllQt8EZDo2t1OYS6cCtY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210507082556epcas2p41af1dd4a7abf35b1c091e5974f94fac3~8u1jShPg02036620366epcas2p4F;
        Fri,  7 May 2021 08:25:56 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Fc3S12qQnz4x9Q1; Fri,  7 May
        2021 08:25:53 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.C2.09717.E89F4906; Fri,  7 May 2021 17:25:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210507082550epcas2p2d08871891e12b5b0c22281344e53afcf~8u1dn-IWy0105901059epcas2p2s;
        Fri,  7 May 2021 08:25:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210507082550epsmtrp177c70e37218f6943e1a8623789e5a46c~8u1dm9ari0880808808epsmtrp1g;
        Fri,  7 May 2021 08:25:50 +0000 (GMT)
X-AuditID: b6c32a48-4e5ff700000025f5-f1-6094f98ebd61
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C2.73.08637.D89F4906; Fri,  7 May 2021 17:25:49 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210507082549epsmtip28c7e77d404864cfa8a5a5b8a9ea34fe8~8u1dWu2J30903109031epsmtip2M;
        Fri,  7 May 2021 08:25:49 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>,
        "'Yunsheng Lin'" <linyunsheng@huawei.com>
Cc:     "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'bpf'" <bpf@vger.kernel.org>,
        "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Andrii Nakryiko'" <andrii@kernel.org>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'KP Singh'" <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
Subject: RE: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
Date:   Fri, 7 May 2021 17:25:49 +0900
Message-ID: <007001d7431a$96281960$c2784c20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKypHYW3xad5/j2XvChPebQmKG2owG+YoocAqFpyMsBZavlXQIxNaIYAiru3ucBq8RF2QKY6vTDAm6kVlUBadK04AMaqQ3GqHYXshA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJsWRmVeSWpSXmKPExsWy7bCmhW7fzykJBvNXSlh8/z2b2eLLz9vs
        Fp+PHGezWLzwG7PFnPMtLBZNO1YwWbz48ITR4vm+XiaLC9v6WC0u75rDZtHwlsvi2AIxi5+H
        zzBbLP65AahqyQxGB36PLStvMnlMbH7H7rFz1l12j5Yjb1k9um5cYvbYtKqTzePzJrkA9qgc
        m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygs5UUyhJz
        SoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BYaGBXrFibnFpXnpesn5uVaGBgZGpkCVCTkZ
        +xf+YC+Y4FlxvusSSwNjg3kXIyeHhICJxIHTV1i6GLk4hAR2MEpcvHSVDcL5xCgxd841dgjn
        G6NEa88NNpiWzUfus0Ik9jJKNB07wASSEBJ4wShxcDcPiM0moCXxZlY7K4gtIpAu8bu7B2wS
        s8A8FomGhW+ZQRKcAoESk6fOB5sqLBAs8XRSE9ggFgEVidY309lBbF4BS4me3/NYIWxBiZMz
        n7CA2MwC8hLb385hhrhIQeLn02VQy8ok9nbsZISoEZGY3dnGDLJYQuAOh8SGaa+ZIBpcJP7t
        v84IYQtLvDq+hR3ClpJ42d8GZHMA2fUSrd0xEL09jBJX9kEslhAwlpj1rJ0RpIZZQFNi/S59
        iHJliSO3oE7jk+g4/BdqCq9ER5sQhKkkMfFLPMQMCYkXJyezTGBUmoXkr1lI/pqF5P5ZCKsW
        MLKsYhRLLSjOTU8tNiowQY7rTYzgFK3lsYNx9tsPeocYmTgYDzFKcDArifCeXjQ5QYg3JbGy
        KrUoP76oNCe1+BCjKTCkJzJLiSbnA7NEXkm8oamRmZmBpamFqZmRhZI478/UugQhgfTEktTs
        1NSC1CKYPiYOTqkGppg9Lw7OcHVvXXTk3YF0znLuCM20uluHJ4pERPhtVmRYYpha0P9iwjGL
        HlarT9HVR0PvZlQ/CW7/528rFW089+KpEnn5K9/Onawts92boVXLsclgzs2vWivkjs5/7qe4
        +bZVdq5fXOXdfxZuIl8YjkdGp/R5qz3VlNTK2/X4qt9yr1ypn8v/rUk78H9BoOWi2gXnNu7p
        Odtu02jqlbNtw7sP53/38h0T8/gefiGz9pm3h82VWsu5O6Lj5EqTF4eI3HZV/qKntXnithD+
        ySeDlmzQOX5RWapnxWGtjE7PZa1XRZeqRqhY/vNv73/yvIFjT8gcqbZ1QmYnA2ewMV5Y+9bU
        xpyFa4oN0/cdfL6zlFiKMxINtZiLihMBe5UHLFoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWy7bCSvG7vzykJBnMemFl8/z2b2eLLz9vs
        Fp+PHGezWLzwG7PFnPMtLBZNO1YwWbz48ITR4vm+XiaLC9v6WC0u75rDZtHwlsvi2AIxi5+H
        zzBbLP65AahqyQxGB36PLStvMnlMbH7H7rFz1l12j5Yjb1k9um5cYvbYtKqTzePzJrkA9igu
        m5TUnMyy1CJ9uwSujP0Lf7AXTPCsON91iaWBscG8i5GTQ0LARGLzkfusXYxcHEICuxkl7p3s
        ZOli5ABKSEjs2uwKUSMscb/lCCuILSTwjFFi87l8EJtNQEvizax2sLiIQLrEnrNf2EDmMAus
        YJFomvaNDaJhFqvEyS0SIDanQKDE5KnzweLCQHb/v1uMIDaLgIpE65vp7CA2r4ClRM/veawQ
        tqDEyZlPWEBsZgFtid6HrYwQtrzE9rdzmCGOU5D4+XQZ1BFlEns7dkLViEjM7mxjnsAoPAvJ
        qFlIRs1CMmoWkpYFjCyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCo1VLcwfj9lUf
        9A4xMnEwHmKU4GBWEuE9vWhyghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNT
        UwtSi2CyTBycUg1MTYdzFPodtbbNnx3w30BNoizijKrSft7M5Q5v2Ba17+U/ePfyqXs6i54Z
        nQktmrl+54u7KjeXtGqKN+TVSzd/37SzJsmg2TJ20pybc46WHpl5hmHGnydpr+dJPN8TMftf
        tEptj6UEy9fWI7sm3Un75xrScG/N+mvLBO6/+bDS77VpyvRHSRce7jquIr16zY81yjrZDO5x
        X5T2mqt3/N9vV7aUXfIpm3/+MSHF9TM/MbnLntutk5SuZqWvN3X67E26U2O/7lK7pNL/YNN0
        4Rzm4xZPtTrLr28wn/c2SeB81qms2jwhGw23xz3pvtNWqlzgUt4kUHeyUIkjjv/9jPRH8uLX
        17YyZV7NSa77XOOvrcRSnJFoqMVcVJwIADMIND1FAwAA
X-CMS-MailID: 20210507082550epcas2p2d08871891e12b5b0c22281344e53afcf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210429102143epcas2p4c8747c09a9de28f003c20389c050394a
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
        <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
        <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
        <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com>
        <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
        <02c801d7421f$65287a90$2f796fb0$@samsung.com>
        <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
        <001801d742db$68ab8060$3a028120$@samsung.com>
        <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
        <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com>
        <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 09:53:45PM -0400, Willem de Bruijn wrote:
> On Thu, May 6, 2021 at 9:45 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >
> > On 2021/5/7 9:25, Willem de Bruijn wrote:
> > >>>> head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
> > >>>> data_len could be 8 if server sent a small size packet and it is GROed
> > >>>> to head_skb.
> > >>>>
> > >>>> Please let me know if I am missing something.
> > >>>
> > >>> This is my understanding of the data path. This is a forwarding path
> > >>> for TCP traffic.
> > >>>
> > >>> GRO is enabled and will coalesce multiple segments into a single large
> > >>> packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
> > >>> + 20.
> > >>>
> > >>> Somewhere between GRO and GSO you have a BPF program that converts the
> > >>> IPv6 address to IPv4.
> > >>
> > >> Your understanding is right. The data path is GRO -> BPF 6 to 4 ->
> > >> GSO.
> > >>
> > >>>
> > >>> There is no concept of head_skb at the time of this BPF program. It is
> > >>> a single SKB, with an skb linear part and multiple data items in the
> > >>> frags (no frag_list).
> > >>
> > >> Sorry for the confusion. head_skb what I mentioned was a skb linear
> > >> part. I'm considering a single SKB with frags too.
> > >>
> > >>>
> > >>> When entering the GSO stack, this single skb now has a payload length
> > >>> < MSS. So it would just make a valid TCP packet on its own?
> > >>>
> > >>> skb_gro_len is only relevant inside the GRO stack. It internally casts
> > >>> the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
> > >>> reused for other purposes later by other layers of the datapath. It is
> > >>> not safe to read this inside bpf_skb_proto_6_to_4.
> > >>
> > >> The condition what I made uses skb->data_len not skb_gro_len. Does
> > >> skb->data_len have a different meaning on each layer? As I know,
> > >> data_len indicates the amount of frags or frag_list. skb->data_len
> > >> should be > 20 in the sample case because the payload size of the skb
> > >> linear part is the same with mss.
> > >
> > > Ah, got it.
> > >
> > > data_len is the length of the skb minus the length in the skb linear
> > > section (as seen in skb_headlen).
> > >
> > > So this gso skb consists of two segments, the first one entirely
> > > linear, the payload of the second is in skb_shinfo(skb)->frags[0].
> > >
> > > It is not guaranteed that gso skbs built from two individual skbs end
> > > up looking like that. Only protocol headers in the linear segment and
> > > the payload of both in frags is common.
> > >
> > >> We can modify netif_needs_gso as another option to hit
> > >> skb_needs_linearize in validate_xmit_skb. But I think we should compare
> > >> skb->gso_size and skb->data_len too to check if mss exceed a payload
> > >> size.
> > >
> > > The rest of the stack does not build such gso packets with payload len
> > > < mss, so we should not have to add workarounds in the gso hot path
> > > for this.
> > >
> > > Also no need to linearize this skb. I think that if the bpf program
> > > would just clear the gso type, the packet would be sent correctly.
> > > Unless I'm missing something.
> >
> > Does the checksum/len field in ip and tcp/udp header need adjusting
> > before clearing gso type as the packet has became bigger?
> 
> gro takes care of this. see for instance inet_gro_complete for updates
> to the ip header.

I think clearing the gso type will get an error at tcp4_gso_segment
because netif_needs_gso returns true in validate_xmit_skb.

> 
> > Also, instead of testing skb->data_len, may test the skb->len?
> >
> > skb->len - (mac header + ip/ipv6 header + udp/tcp header) > mss + len_diff
> 
> Yes. Essentially doing the same calculation as the gso code that is
> causing the packet to be dropped.

BPF program is usually out of control. Can we take a general approach?
The below 2 cases has no issue when mss upgrading.
1) skb->data_len > mss + 20
2) skb->data_len < mss && skb->data_len > 20
The corner case is when
3) skb->data_len > mss && skb->data_len < mss + 20

But to cover #3 case, we should check the condition Yunsheng Lin said.
What if we do mss upgrading for both #1 and #2 cases only?

+               unsigned short off_len = skb->data_len > shinfo->gso_size ?
+                       shinfo->gso_size : 0;
[...]
                /* Due to IPv4 header, MSS can be upgraded. */
-               skb_increase_gso_size(shinfo, len_diff);
+               if (skb->data_len - off_len > len_diff)
+                       skb_increase_gso_size(shinfo, len_diff);

> 
> > >
> > > But I don't mean to argue that it should do that in production.
> > > Instead, not playing mss games would solve this and stay close to the
> > > original datapath if no bpf program had been present. Including
> > > maintaining the GSO invariant of sending out the same chain of packets
> > > as received (bar the IPv6 to IPv4 change).
> > >
> > > This could be achieved by adding support for the flag
> > > BPF_F_ADJ_ROOM_FIXED_GSO in the flags field of bpf_skb_change_proto.
> > > And similar to bpf_skb_net_shrink:
> > >
> > >                 /* Due to header shrink, MSS can be upgraded. */
> > >                 if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
> > >                         skb_increase_gso_size(shinfo, len_diff);
> > >
> > > The other case, from IPv4 to IPv6 is more difficult to address, as not
> > > reducing the MSS will result in packets exceeding MTU. That calls for
> > > workarounds like MSS clamping. Anyway, that is out of scope here.
> > >
> > >
> > >
> > >>>
> > >>>
> > >>>>>
> > >>>>> One simple solution if this packet no longer needs to be segmented
> > >>>>> might be to reset the gso_type completely.
> > >>>>
> > >>>> I am not sure gso_type can be cleared even when GSO is needed.
> > >>>>
> > >>>>>
> > >>>>> In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
> > >>>>> converting from IPv6 to IPv4, fixed gso will end up building packets
> > >>>>> that are slightly below the MTU. That opportunity cost is negligible
> > >>>>> (especially with TSO). Unfortunately, I see that that flag is
> > >>>>> available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.
> > >>>>>
> > >>>>>
> > >>>>>>>> would increse the gso_size to 1392. tcp_gso_segment will get an error
> > >>>>>>>> with 1380 <= 1392.
> > >>>>>>>>
> > >>>>>>>> Check for the size of GROed payload if it is really bigger than target
> > >>>>>>>> mss when increase mss.
> > >>>>>>>>
> > >>>>>>>> Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> > >>>>>>>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > >>>>>>>> ---
> > >>>>>>>>   net/core/filter.c | 4 +++-
> > >>>>>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
> > >>>>>>>>
> > >>>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
> > >>>>>>>> index 9323d34..3f79e3c 100644
> > >>>>>>>> --- a/net/core/filter.c
> > >>>>>>>> +++ b/net/core/filter.c
> > >>>>>>>> @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> > >>>>>>>>             }
> > >>>>>>>>
> > >>>>>>>>             /* Due to IPv4 header, MSS can be upgraded. */
> > >>>>>>>> -           skb_increase_gso_size(shinfo, len_diff);
> > >>>>>>>> +           if (skb->data_len > len_diff)
> > >>>>>>>
> > >>>>>>> Could you elaborate some more on what this has to do with data_len specifically
> > >>>>>>> here? I'm not sure I follow exactly your above commit description. Are you saying
> > >>>>>>> that you're hitting in tcp_gso_segment():
> > >>>>>>>
> > >>>>>>>          [...]
> > >>>>>>>          mss = skb_shinfo(skb)->gso_size;
> > >>>>>>>          if (unlikely(skb->len <= mss))
> > >>>>>>>                  goto out;
> > >>>>>>>          [...]
> > >>>>>>
> > >>>>>> Yes, right
> > >>>>>>
> > >>>>>>>
> > >>>>>>> Please provide more context on the bug, thanks!
> > >>>>>>
> > >>>>>> tcp_gso_segment():
> > >>>>>>         [...]
> > >>>>>>         __skb_pull(skb, thlen);
> > >>>>>>
> > >>>>>>         mss = skb_shinfo(skb)->gso_size;
> > >>>>>>         if (unlikely(skb->len <= mss))
> > >>>>>>         [...]
> > >>>>>>
> > >>>>>> skb->len will have total GROed TCP payload size after __skb_pull.
> > >>>>>> skb->len <= mss will not be happened in a normal GROed situation. But
> > >>>>>> bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
> > >>>>>> hit an error condition.
> > >>>>>>
> > >>>>>> We should ensure the following condition.
> > >>>>>> total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
> > >>>>>>
> > >>>>>> Due to
> > >>>>>> total GROed TCP payload = the original mss + skb->data_len
> > >>>>>> IPv6 size - IPv4 size = len_diff
> > >>>>>>
> > >>>>>> Finally, we can get the condition.
> > >>>>>> skb->data_len > len_diff
> > >>>>>>
> > >>>>>>>
> > >>>>>>>> +                   skb_increase_gso_size(shinfo, len_diff);
> > >>>>>>>> +
> > >>>>>>>>             /* Header must be checked, and gso_segs recomputed. */
> > >>>>>>>>             shinfo->gso_type |= SKB_GSO_DODGY;
> > >>>>>>>>             shinfo->gso_segs = 0;
> > >>>>>>>>
> > >>>>>>
> > >>>>>>
> > >>>>
> > >>
> > >
> > > .
> > >
> >

