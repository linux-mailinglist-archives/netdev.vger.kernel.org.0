Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7117B2EB79C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 02:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbhAFBad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 20:30:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53539 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbhAFBac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 20:30:32 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210106012947epoutp027d5fd8a6434c3d8c4fefb9587c6d5568~XgGqm3Wh22836728367epoutp02w
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 01:29:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210106012947epoutp027d5fd8a6434c3d8c4fefb9587c6d5568~XgGqm3Wh22836728367epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609896587;
        bh=3QXRuG8IcfTM8EsdS2v4RlosyPk5o5uoH+4fZbr0kKw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=VCIIp71ZMLgAcSEC+LJk2+709fBAwsY4+ruktnonYXM2kPwxs1jFlnjnF0ZBavZhx
         hkIPnmb/8aUsgdaKkUn3/yCznpAZNgeYBbhm77uDCa463oGjcgbyYlx0LvtG69cSsP
         7tDTASoiagwtrHynRU6TKmJH+ds1hj9AVNfwr7jc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210106012946epcas2p3f6da8347d9dcb5be13c24e321b8f4d03~XgGqG5rUc0338803388epcas2p3j;
        Wed,  6 Jan 2021 01:29:46 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4D9Wxh70YczMqYkt; Wed,  6 Jan
        2021 01:29:44 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.D6.56312.88215FF5; Wed,  6 Jan 2021 10:29:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210106012944epcas2p28eb422cf1d17aaf679df3872f7cf29bd~XgGn16aHp3110831108epcas2p2Y;
        Wed,  6 Jan 2021 01:29:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210106012944epsmtrp13f5b53ee179260afdfdfbe78165491ef~XgGn0pixb0228702287epsmtrp1S;
        Wed,  6 Jan 2021 01:29:44 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-e6-5ff51288e464
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.D5.13470.88215FF5; Wed,  6 Jan 2021 10:29:44 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210106012944epsmtip1c69bd113585033a1655b98e8a28ed143~XgGnjHjvx2292122921epsmtip1M;
        Wed,  6 Jan 2021 01:29:44 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Miaohe Lin'" <linmiaohe@huawei.com>,
        "'Willem de Bruijn'" <willemb@google.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "'Florian Westphal'" <fw@strlen.de>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>,
        "'Guillaume Nault'" <gnault@redhat.com>,
        "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        "'Yadu Kishore'" <kyk.segfault@gmail.com>,
        "'Marco Elver'" <elver@google.com>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, <namkyu78.kim@samsung.com>
In-Reply-To: <CAF=yD-+bDdYg7X+WpP14w3fbv+JewySpdCbjdwWXB-syCwQ9uQ@mail.gmail.com>
Subject: RE: [PATCH net] net: fix use-after-free when UDP GRO with shared
 fraglist
Date:   Wed, 6 Jan 2021 10:29:43 +0900
Message-ID: <017f01d6e3cb$698246a0$3c86d3e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGzSLyD0IId2D3HDIYy/7dNsmGIiACENc+NAWJEhNGqUcp8MA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmuW6H0Nd4g9uvTSzmnG9hsWg7s53V
        YlvvakaLGZ82sltc2NbHarFu2yJGi87vS1ksLu+aw2bR8JbLouFOM5vFsQViFt9Ov2G02N35
        g93i/N/jrBbvthxht1j8cwOTg4DHlpU3mTx2zrrL7rFgU6lHy5G3rB6bVnWyebzfd5XNo2/L
        KkaPTa1LWD0OfV/A6vF5k5zHpidvmQK4o3JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
        DS0tzJUU8hJzU22VXHwCdN0yc4DeUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQU
        GBoW6BUn5haX5qXrJefnWhkaGBiZAlUm5GRMXxJUsEW/omXrRtYGxkdKXYycHBICJhITew8y
        djFycQgJ7GCU+NJzkh3C+cQo8erZAqjMN0aJtq87mGBanuyfyAaR2Mso0dL1E8p5wShx5Ugz
        I0gVm4CWxJtZ7awgtoiAlcT/2SfYQWxmge8sEkeneoHYnAKBEsvnTQWrFxYIkdi+7gxzFyMH
        B4uAisTllSYgYV4BS4mvk96zQ9iCEidnPmGBGCMvsf3tHGaIgxQkfj5dBrXKSWLjmslQq0Qk
        Zne2QdU0c0rsPpQKYbtIfOs/wwphC0u8Or6FHcKWknjZ38YOcoKEQL1Ea3cMyFsSAj1Ab+2D
        2CshYCwx61k7I0gNs4CmxPpd+hDlyhJHbkFdxifRcfgv1BReiY42IQhTSWLil3iIGRISL05O
        ZpnAqDQLyVuzkLw1C8n5sxBWLWBkWcUollpQnJueWmxUYIQc0ZsYwclcy20H45S3H/QOMTJx
        MB5ilOBgVhLhtTj2JV6INyWxsiq1KD++qDQntfgQoykwnCcyS4km5wPzSV5JvKGpkZmZgaWp
        hamZkYWSOG+xwYN4IYH0xJLU7NTUgtQimD4mDk6pBqZkrhadshULHbcmdt7JaepduW3V7/LK
        x0mel/4fWuf10m/atW87zx+Ki/KsErzgz3V28YvT3/pcQvkZ1GYl3XDSPOW43+yMwYQ1mlvf
        if4/q/2veM39rhVvdqg9v1cv8Txwdkmy4p1PeepaJb1O221+ZvCkiTSw3r+34vux/GVfWPNX
        TZT95npAbubWr+vDODftPi+82vWf764ZXDa3Zr44Pvth34GI6Ojlk1gFt+46kmpc+3Sbjhzj
        YpYrleY907bWzs+fUZIacKy6PfTGxZLEnVyZ1arf+XpMqzW4CuSFtuzRWvQ+0N5/S/G1I72J
        l95xP4hW7z9042fbizONjO6nl2Z9V7536XvagovvVplJKbEUZyQaajEXFScCAHZknCNvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02ReWyLcRjH/dr3Wqm9uuJnEqRzxMRs1PwccYs3/MNMJLOo0tfY1q5plTnT
        xYw2Nsc0mypqp9awvapjdXYzZpZiGZo4YpewdYdjM7cqyf775vl+nu/zTR6KL3qAhVJbVFtZ
        jUqeLCEEmLNSMmryQdFnWWTlWxpZPOkYynhYjiNn5nmAcj+UkeiRMwtHF515ABl6CzFUX2Eh
        kN4nQPoX+whUbR2GemrbAXIZvpDI8+MejjocVSTK7yvlzacZh83LY66ZX5KMldMx6VU+nOHs
        BoLpvNlAMFkOO2C4/QU44+614sxHbhTDNft4KwbGCeYo2OQt21jNlLnrBZtzCmLUjimp6VfK
        cD1olBhBEAVpKWy+dZQwAgElol0AZj95TxoB9ceAsOLykgATAl+nV+EBphXApy+7Cb9B0OGw
        3XwA92sxPQv+Onmf9EN8Og2HLR7Hv9QXAJqO92F+KoheCYtPm4Bfh9Ax8NbzUsJ/DaPHwnqb
        1D8W0jPh52OdZEAPgTUnmv+u8ulJMPPNfhDQo2G5z8IPtBsD+1qK/pVYCMtKsskAI4YnDRn8
        IyDE3C/K3C/K3C/K3G/FCjA7GMGqtcoEpTZKHaVit0do5UqtTpUQsTFFyYG/7w6feBWU27si
        3IBHATeAFF8iFqLqTzKRUCHfsZPVpMg0umRW6wYjKUwyXPjIWCMT0QnyrWwSy6pZzX+XRwWF
        6nlRq9en7p6orwjWXYwP44ZHLLWnbbKNS6kzRfKlTd5B85Ynej2nSvKHZni6MxcMTnyX1nD2
        UncQHrfLlqrePdj29e60M6H192i3zza94bCsRUsdEZ9xr1DfTgpevOfVs7CUV8Wr2zx50Xc2
        LmKuHzUqPlkjvYXRuriWAYbYbdy6rrAvdV42eQN5CP1ss/EuI90qU/xCE2Nd23jhxrU1APSE
        iOIfnzvIm1q3qOedathY19Rz0kHKUx11t/N/NVSZI8fFLQv9plAIpJuafiRMz3mzV1htKZod
        2zlQQHIlpW0ucW9Ozvfaxu37WnHUznytPDRjQpYzVzBeXHBTqjBZ0DwJpt0sjwrna7Ty3zIW
        d6pdAwAA
X-CMS-MailID: 20210106012944epcas2p28eb422cf1d17aaf679df3872f7cf29bd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5
References: <CGME20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5@epcas2p1.samsung.com>
        <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
        <CAF=yD-+bDdYg7X+WpP14w3fbv+JewySpdCbjdwWXB-syCwQ9uQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-05 06:03, Willem de Bruijn wrote:
> 
> On Mon, Jan 4, 2021 at 4:00 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >
> > skbs in frag_list could be shared by pskb_expand_head() from BPF.
> 
> Can you elaborate on the BPF connection?

With the following registered ptypes,

/proc/net # cat ptype
Type Device      Function
ALL           tpacket_rcv
0800          ip_rcv.cfi_jt
0011          llc_rcv.cfi_jt
0004          llc_rcv.cfi_jt
0806          arp_rcv
86dd          ipv6_rcv.cfi_jt

BPF checks skb_ensure_writable between tpacket_rcv and ip_rcv
(or ipv6_rcv). And it calls pskb_expand_head.

[  132.051228] pskb_expand_head+0x360/0x378
[  132.051237] skb_ensure_writable+0xa0/0xc4
[  132.051249] bpf_skb_pull_data+0x28/0x60
[  132.051262] bpf_prog_331d69c77ea5e964_schedcls_ingres+0x5f4/0x1000
[  132.051273] cls_bpf_classify+0x254/0x348
[  132.051284] tcf_classify+0xa4/0x180
[  132.051294] __netif_receive_skb_core+0x590/0xd28
[  132.051303] __netif_receive_skb+0x50/0x17c
[  132.051312] process_backlog+0x15c/0x1b8

> 
> > While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
> > But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
> > chain made by skb_segment_list().
> >
> > If the new skb (not frag_list) is queued to one of the sk_receive_queue,
> > multiple ptypes can see this. The skb could be released by ptypes and
> > it causes use-after-free.
> 
> If I understand correctly, a udp-gro-list skb makes it up the receive
> path with one or more active packet sockets.
> 
> The packet socket will call skb_clone after accepting the filter. This
> replaces the head_skb, but shares the skb_shinfo and thus frag_list.
> 
> udp_rcv_segment later converts the udp-gro-list skb to a list of
> regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
> Now all the frags are fully fledged packets, with headers pushed
> before the payload. This does not change their refcount anymore than
> the skb_clone in pf_packet did. This should be 1.
> 
> Eventually udp_recvmsg will call skb_consume_udp on each packet.
> 
> The packet socket eventually also frees its cloned head_skb, which triggers
> 
>   kfree_skb_list(shinfo->frag_list)
>     kfree_skb
>       skb_unref
>         refcount_dec_and_test(&skb->users)

Every your understanding is right, but

> 
> >
> > [ 4443.426215] ------------[ cut here ]------------
> > [ 4443.426222] refcount_t: underflow; use-after-free.
> > [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> > refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> > [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> > [ 4443.426808] Call trace:
> > [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426823]  skb_release_data+0x144/0x264
> > [ 4443.426828]  kfree_skb+0x58/0xc4
> > [ 4443.426832]  skb_queue_purge+0x64/0x9c
> > [ 4443.426844]  packet_set_ring+0x5f0/0x820
> > [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> > [ 4443.426853]  __sys_setsockopt+0x188/0x278
> > [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> > [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> > [ 4443.426873]  el0_svc_handler+0x74/0x98
> > [ 4443.426880]  el0_svc+0x8/0xc
> >
> > Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > ---
> >  net/core/skbuff.c | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index f62cae3..1dcbda8 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >         unsigned int delta_truesize = 0;
> >         unsigned int delta_len = 0;
> >         struct sk_buff *tail = NULL;
> > -       struct sk_buff *nskb;
> > +       struct sk_buff *nskb, *tmp;
> > +       int err;
> >
> >         skb_push(skb, -skb_network_offset(skb) + offset);
> >
> > @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >                 nskb = list_skb;
> >                 list_skb = list_skb->next;
> >
> > +               err = 0;
> > +               if (skb_shared(nskb)) {
> 
> I must be missing something still. This does not square with my
> understanding that the two sockets are operating on clones, with each
> frag_list skb having skb->users == 1.
> 
> Unless the packet socket patch previously also triggered an
> skb_unclone/pskb_expand_head, as that call skb_clone_fraglist, which
> calls skb_get on each frag_list skb.

A cloned skb after tpacket_rcv cannot go through skb_ensure_writable
with the original shinfo. pskb_expand_head reallocates the shinfo of
the skb and call skb_clone_fraglist. skb_release_data in
pskb_expand_head could not reduce skb->users of the each frag_list skb
if skb_shinfo(skb)->dataref == 2.

After the reallocation, skb_shinfo(skb)->dataref == 1 but each frag_list
skb could have skb->users == 2.

> 
> 
> > +                       tmp = skb_clone(nskb, GFP_ATOMIC);
> > +                       if (tmp) {
> > +                               kfree_skb(nskb);
> > +                               nskb = tmp;
> > +                               err = skb_unclone(nskb, GFP_ATOMIC);
> > +                       } else {
> > +                               err = -ENOMEM;
> > +                       }
> > +               }
> > +
> >                 if (!tail)
> >                         skb->next = nskb;
> >                 else
> >                         tail->next = nskb;
> >
> > +               if (unlikely(err)) {
> > +                       nskb->next = list_skb;
> > +                       goto err_linearize;
> > +               }
> > +
> >                 tail = nskb;
> >
> >                 delta_len += nskb->len;
> > --
> > 2.7.4
> >

