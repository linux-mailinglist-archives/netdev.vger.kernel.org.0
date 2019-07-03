Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D585E735
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfGCOz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:55:56 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45575 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCOz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:55:56 -0400
Received: by mail-ed1-f66.google.com with SMTP id a14so2364741edv.12
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 07:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nXq44duXTiRcGHmRHTAhbXUvhBZyNlCHFmCEGTghKpY=;
        b=Y0ltFpUcfzJsU3GEwh5DPkYh6ZpYMn5s5vygDx75p3nJX60Qjix4TMACRgG8+yu9h+
         yvHUlAJacANo6p6CiDBeUeRW1UCaxTlYvd/tk6sAAgxlqcjeVI2aU0Xtura+IJZrd1nc
         3Uai/K9d5bejvsIgdsI+hMmUbj3qb8jNoq78D5V4Qe1cNHJesgvYIHOTFnZZ7zpwJ27+
         MpRcWmPePxgEcZEkJArLpxgU6jDZBK+0OT4prmMprbQqrzHtGyST2SNV8WT5Ac3tKaPb
         a8dWjVI8bFloM+msYxh5CJo/h8Ihx/bhjAY/E2OZU2GYl2e1zVRZve2R+Wz9s8Pis/xx
         /ytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nXq44duXTiRcGHmRHTAhbXUvhBZyNlCHFmCEGTghKpY=;
        b=hHGIMzPM15lfNSDyzbiXGtjhRg0RRxhdsW8V6rmAUiiCNBPthmm7cubOOVKpy0Nzxd
         PFMpsXMwcrVw0V8+2yhj6S/nPEYzSTUSeLU/wZKwJsDxR8s/idDPIepLFX32XAuvq5i4
         46xPepA5RYjuT6d8I+0WmPH3WoUm9KXrrk2ldVcUvXNAsnR/7gECaj1sh18hI5nwJlew
         QVj4XKs6SqYV+2l2h9qtbFMOqxa3SbfAfJbB6HWDihLtcFDjMU9XT+JaIQlGqfpObTVD
         CzbHbD4BjGnwA0jPMLwnGSh9+WvZGMf+w4K6TllTUQcabYQkzwFzo/nzd1aE/ZM48sVs
         VEuA==
X-Gm-Message-State: APjAAAV1BrVKwEFqTLACWrHKGUNmE/dRNoP/At4isfNAlworhQndDYca
        VrvjdljmZeKeiLcVmfgrjojkSuTDvWrTZXiPzy4gxSA+
X-Google-Smtp-Source: APXvYqwjgUMPM1VdDobYu1+MSr3ZUnuFGWQb7c7nSV/y5w1QCeYOSC6Tse7xYqu5kEugsPwjae89h/UhAEXeK5zUqi0=
X-Received: by 2002:a50:eb8f:: with SMTP id y15mr26553400edr.31.1562165753992;
 Wed, 03 Jul 2019 07:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190702193927.116668-1-willemdebruijn.kernel@gmail.com> <254abb52-e201-eb12-d6c2-6bd96e505871@huawei.com>
In-Reply-To: <254abb52-e201-eb12-d6c2-6bd96e505871@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Jul 2019 10:55:18 -0400
Message-ID: <CAF=yD-JkjAm_kekjNiXw9WBty3tj4wFWt_JvHdjG08dAisraYQ@mail.gmail.com>
Subject: Re: [PATCH net-next] skbuff: increase verbosity when dumping skb data
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 11:28 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2019/7/3 3:39, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > skb_warn_bad_offload and netdev_rx_csum_fault trigger on hard to debug
> > issues. Dump more state and the header.
> >
> > Optionally dump the entire packet and linear segment. This is required
> > to debug checksum bugs that may include bytes past skb_tail_pointer().
> >
> > Both call sites call this function inside a net_ratelimit() block.
> > Limit full packet log further to a hard limit of can_dump_full (5).
> >
> > Based on an earlier patch by Cong Wang, see link below.
> >
> > Link: https://patchwork.ozlabs.org/patch/1000841/
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---

> > +void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
> > +{
> > +     static atomic_t can_dump_full = ATOMIC_INIT(5);
> > +     struct skb_shared_info *sh = skb_shinfo(skb);
> > +     struct net_device *dev = skb->dev;
> > +     struct sock *sk = skb->sk;
> > +     struct sk_buff *list_skb;
> > +     bool has_mac, has_trans;
> > +     int headroom, tailroom;
> > +     int i, len, seg_len;
> > +
> > +     if (full_pkt)
> > +             full_pkt = atomic_dec_if_positive(&can_dump_full) >= 0;
> > +
> > +     if (full_pkt)
> > +             len = skb->len;
>
> Minor question:
> Here we set the len to skb->len if full_pkt is true when skb_dump is
> called with frag_list skb and full_pkt being true below, which may
> cause some problem?

Good catch, thanks!

That recursive call to skb_dump on the frag_list below was not updated
from a previous revision that passed an explicit length.

> Maybe change the definition to:
> void skb_dump(const char *level, const struct sk_buff *skb, int len, bool full_pkt)

Indeed. It is less important when full_pkt, as then the entire
frag_list will be printed.

But if len is truncated, but somehow len != 0 when reaching the
frag_list, it might overshoot the limit. Will fix for v2.

> skb_dump(KERN_ERR, skb, skb->len, true);
>
> > +     else
> > +             len = min_t(int, skb->len, MAX_HEADER + 128);
> > +
> > +     headroom = skb_headroom(skb);
> > +     tailroom = skb_tailroom(skb);
> > +
> > +     has_mac = skb_mac_header_was_set(skb);
> > +     has_trans = skb_transport_header_was_set(skb);
> > +
> > +     printk("%sskb len=%u headroom=%u headlen=%u tailroom=%u\n"
> > +            "mac=(%d,%d) net=(%d,%d) trans=%d\n"
> > +            "shinfo(txflags=%u nr_frags=%u gso(size=%hu type=%u segs=%hu))\n"
> > +            "csum(0x%x ip_summed=%u complete_sw=%u valid=%u level=%u)\n"
> > +            "hash(0x%x sw=%u l4=%u) proto=0x%04x pkttype=%u iif=%d\n",
> > +            level, skb->len, headroom, skb_headlen(skb), tailroom,
> > +            has_mac ? skb->mac_header : -1,
> > +            has_mac ? skb_mac_header_len(skb) : -1,
> > +            skb->network_header,
> > +            has_trans ? skb_network_header_len(skb) : -1,
> > +            has_trans ? skb->transport_header : -1,
> > +            sh->tx_flags, sh->nr_frags,
> > +            sh->gso_size, sh->gso_type, sh->gso_segs,
> > +            skb->csum, skb->ip_summed, skb->csum_complete_sw,
> > +            skb->csum_valid, skb->csum_level,
> > +            skb->hash, skb->sw_hash, skb->l4_hash,
> > +            ntohs(skb->protocol), skb->pkt_type, skb->skb_iif);
> > +
> > +     if (dev)
> > +             printk("%sdev name=%s feat=0x%pNF\n",
> > +                    level, dev->name, &dev->features);
> > +     if (sk)
> > +             printk("%ssk family=%hu type=%hu proto=%hu\n",
> > +                    level, sk->sk_family, sk->sk_type, sk->sk_protocol);
> > +
> > +     if (full_pkt && headroom)
> > +             print_hex_dump(level, "skb headroom: ", DUMP_PREFIX_OFFSET,
> > +                            16, 1, skb->head, headroom, false);
> > +
> > +     seg_len = min_t(int, skb_headlen(skb), len);
> > +     if (seg_len)
> > +             print_hex_dump(level, "skb linear:   ", DUMP_PREFIX_OFFSET,
> > +                            16, 1, skb->data, seg_len, false);
> > +     len -= seg_len;
> > +
> > +     if (full_pkt && tailroom)
> > +             print_hex_dump(level, "skb tailroom: ", DUMP_PREFIX_OFFSET,
> > +                            16, 1, skb_tail_pointer(skb), tailroom, false);
> > +
> > +     for (i = 0; len && i < skb_shinfo(skb)->nr_frags; i++) {
> > +             skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
> > +             u32 p_off, p_len, copied;
> > +             struct page *p;
> > +             u8 *vaddr;
> > +
> > +             skb_frag_foreach_page(frag, frag->page_offset,
> > +                                   skb_frag_size(frag), p, p_off, p_len,
> > +                                   copied) {
> > +                     seg_len = min_t(int, p_len, len);
> > +                     vaddr = kmap_atomic(p);
> > +                     print_hex_dump(level, "skb frag:     ",
> > +                                    DUMP_PREFIX_OFFSET,
> > +                                    16, 1, vaddr + p_off, seg_len, false);
> > +                     kunmap_atomic(vaddr);
> > +                     len -= seg_len;
> > +                     if (!len)
> > +                             break;
> > +             }
> > +     }
> > +
> > +     if (len && skb_has_frag_list(skb)) {
> > +             printk("skb fraglist:\n");
> > +             skb_walk_frags(skb, list_skb) {
> > +                     if (len <= 0)
> > +                             break;
> > +                     skb_dump(level, list_skb, len);
>
> Here we call skb_dump passing len as full_pkt.
>
> Maybe call it with skb_dump(level, list_skb, len, full_pkt);
>
> > +                     len -= list_skb->len;
> > +             }
> > +     }
> > +}
> > +EXPORT_SYMBOL(skb_dump);
