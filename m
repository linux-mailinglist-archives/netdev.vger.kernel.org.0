Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16B30A308
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 09:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhBAIJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 03:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhBAIJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 03:09:05 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89002C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 00:08:25 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s5so4895164edw.8
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 00:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D48ue510EZyqc3drPgLg8sCHAvLn0JXfiNYm43dUTmA=;
        b=smGTlZZ651B7iKw7AuyGLRSKAIlsyVWZOXpBGAR4FNmRz5l9UH0mEvEb4SVIc6hT6w
         27LbL8QeHjy/ACLqMcvAWZnVdbMLt/j8s02JhpGYyxr/UX4LfW6TPC0ZmpPkCkOlOCsy
         HwEGRp5uEFQA8pSkflf2z//5DqIbtnz32q/1Ym8Z5rJpFSzNrT5oiQinmViBnWHY4OKM
         jJL4d0BuZddFm9sofeitGB9S2c6+MQmyWWTh56Ln6CgVtdyLo4oKDiPd4bDWFRcC80VW
         8h9L1LW5xvagPrVjnYstTQGYyrHGn8eimCp2ToMdjith1QffYxordoLik+Fufj7Ysl0a
         CIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D48ue510EZyqc3drPgLg8sCHAvLn0JXfiNYm43dUTmA=;
        b=o6XJ9Tort1gF35X3se6ygBeG5PX32dDGKpNpmYBcvVuhw+aOxYhBt8/+sxTV635sNB
         pZZTlTjnn1rj3JnK9+6sxNA4Xvug/x1B/NJP+IYKA465iXJxpWqc/rPAJNnF6f+fnYSn
         C4SlIFbwv2h/wQZ77rdGHJwGETtCxF11v1IYpm/ch3KKqqqrZ71H2/nCQPRF+OTqyKzm
         dWFdRZUBB7vvRQ1UdSbNz4g10SF+l+enj2QA9xc59rHY3rSQQSHEwBZoyqkioCsgjQS3
         S1KdcpC1IBHFHXjWM+e/5yleUw2IemfMsdyFH70a7xoBpl8GaPRxELdvYXM+F3i7tBF+
         aiDQ==
X-Gm-Message-State: AOAM5328P4IJ9conHP7cxi060PuqyrIHgssTTuh26U9IDMw3Sa8WQtq3
        R02hsbEoDT/MfTjAKpccIR6a7UKXs+24xkRCmnVxUtsomAQ=
X-Google-Smtp-Source: ABdhPJyi8hSjDVLKjQSOaeU0CuZ2ICJQv2pXcmitNgIyJFHQcm18afnfN7wZsU8VLPWjtpWidkM1mfEvfFUStJCwTtw=
X-Received: by 2002:aa7:c895:: with SMTP id p21mr17527205eds.165.1612166903735;
 Mon, 01 Feb 2021 00:08:23 -0800 (PST)
MIME-Version: 1.0
References: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org> <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 1 Feb 2021 09:15:32 +0100
Message-ID: <CAMZdPi_6tBkdQn+wakUmeMC+p8N3HStEja5ZfA3K-+x4DcM68g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mhi-net: Add de-aggeration support
To:     Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Willem,

On Sat, 30 Jan 2021 at 02:01, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 25 Jan 2021 16:45:57 +0100 Loic Poulain wrote:
> > When device side MTU is larger than host side MRU, the packets
> > (typically rmnet packets) are split over multiple MHI transfers.
> > In that case, fragments must be re-aggregated to recover the packet
> > before forwarding to upper layer.
> >
> > A fragmented packet result in -EOVERFLOW MHI transaction status for
> > each of its fragments, except the final one. Such transfer was
> > previoulsy considered as error and fragments were simply dropped.
> >
> > This patch implements the aggregation mechanism allowing to recover
> > the initial packet. It also prints a warning (once) since this behavior
> > usually comes from a misconfiguration of the device (modem).
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>
> > +static struct sk_buff *mhi_net_skb_append(struct mhi_device *mhi_dev,
> > +                                       struct sk_buff *skb1,
> > +                                       struct sk_buff *skb2)
> > +{
> > +     struct sk_buff *new_skb;
> > +
> > +     /* This is the first fragment */
> > +     if (!skb1)
> > +             return skb2;
> > +
> > +     /* Expand packet */
> > +     new_skb = skb_copy_expand(skb1, 0, skb2->len, GFP_ATOMIC);
> > +     dev_kfree_skb_any(skb1);
> > +     if (!new_skb)
> > +             return skb2;
>
> I don't get it, if you failed to grow the skb you'll return the next
> fragment to the caller? So the frame just lost all of its data up to
> where skb2 started? The entire fragment "train" should probably be
> dropped at this point.

Right, there is no point in keeping the partial packet in that case.

>
> I think you can just hang the skbs off skb_shinfo(p)->frag_list.
>
> Willem - is it legal to feed frag_listed skbs into netif_rx()?

In QMAP case, the packets will be forwarded to rmnet link, which works
with linear skb (no NETIF_F_SG), does the linearization will be
properly performed by the net core, in the same way as for xmit path?

Regards,
Loic
