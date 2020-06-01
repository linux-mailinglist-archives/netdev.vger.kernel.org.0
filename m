Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684F21EA752
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 17:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgFAPuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 11:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgFAPuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 11:50:09 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764B6C05BD43;
        Mon,  1 Jun 2020 08:50:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 64so3672161pfg.8;
        Mon, 01 Jun 2020 08:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZCn6jNA85I3AY2o98m/3ff4n9p48a49LP0OkK16FQFM=;
        b=ehSDbr2qPRsp61UR9K/wtJGASImq3q1QD1fPT3tGAayVZqzGC4RWb4OmV7JyaWeyB8
         1/F0S2c8Hyh4W3iJyGB2ic/fAxE8OaewPoTt9fLdKlmmK0UOPPCmrkNRfjNkuy8aGKn0
         Rk5Dn3JQaY9ykXBfMB134O6QZHN6qzEIVssM268p2Otz3OBqGaNBal4ggzP1wh0IMi1/
         +F80Z8vQxBiG587L0U+2aRmnYWeH6QvfyBx0UHR3TiPITrYYYviNoV7Ylb3q4rsdkNb0
         7IekVB7gBLfbjPPXQ+mn7PMhRcnLdnDmlHVp0gJSbgAUDmceXn4K6+tSWin4XXJe2N7E
         yZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZCn6jNA85I3AY2o98m/3ff4n9p48a49LP0OkK16FQFM=;
        b=ZejTNniBdDceDw31JDbW1ff27o1S2oF4HmgFgiEa8ZMhFOnLE5u+T2TyAsryIJQq4z
         erqQjMFKahZhMzi6v6m2WtJZkpmlcYFPFdh8cJopUWyVsRRWxtKLNEq3ao2kD0jZKbHU
         hOc4A/e++zlQLX5Qbs14uwlkQoMia7MvrA/K1t1o31BeM5fkCT++NpZjdGdaRR+kFT6D
         24B+P6McPs3ulrQ/WBWVVzW7HNorRuK432kfuYdIgeGJr27Dg29TJ4L4NxTxc9Rh1o05
         ZpXEBbpddcYLoJZ70weYl6FEn6rnZrJ4groEMEAsOcM8ATje/qyoN+6ztretV8zx062u
         yO2w==
X-Gm-Message-State: AOAM5329tTXOLjkmKG2QHYsSfpqnw8H1klR1M+LXDaZYhRBZ4eayXy/n
        ebGTby4h6TGrBUOHaGB0NcERIiOrSTg=
X-Google-Smtp-Source: ABdhPJz7dS63qbWolJ1+KoTH9aBKVnvvB/CYAPPmbgcGbcQ/vOA3IWs1cvW8byh4tfae7kj+BPDNpg==
X-Received: by 2002:a65:6704:: with SMTP id u4mr19843700pgf.125.1591026609007;
        Mon, 01 Jun 2020 08:50:09 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id ev20sm20254pjb.8.2020.06.01.08.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 08:50:08 -0700 (PDT)
Date:   Mon, 01 Jun 2020 08:50:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Message-ID: <5ed523a8b7749_54cc2acde13425b85b@john-XPS-13-9370.notmuch>
In-Reply-To: <5ed51cae71d0d_3f612ade269e05b46e@john-XPS-13-9370.notmuch>
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
 <159079361946.5745.605854335665044485.stgit@john-Precision-5820-Tower>
 <20200601165716.5a6fa76a@toad>
 <5ed51cae71d0d_3f612ade269e05b46e@john-XPS-13-9370.notmuch>
Subject: Re: [bpf-next PATCH 2/3] bpf: fix running sk_skb program types with
 ktls
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Jakub Sitnicki wrote:
> > On Fri, 29 May 2020 16:06:59 -0700
> > John Fastabend <john.fastabend@gmail.com> wrote:
> > 
> > > KTLS uses a stream parser to collect TLS messages and send them to
> > > the upper layer tls receive handler. This ensures the tls receiver
> > > has a full TLS header to parse when it is run. However, when a
> > > socket has BPF_SK_SKB_STREAM_VERDICT program attached before KTLS
> > > is enabled we end up with two stream parsers running on the same
> > > socket.
> > > 
> > > The result is both try to run on the same socket. First the KTLS
> > > stream parser runs and calls read_sock() which will tcp_read_sock
> > > which in turn calls tcp_rcv_skb(). This dequeues the skb from the
> > > sk_receive_queue. When this is done KTLS code then data_ready()
> > > callback which because we stacked KTLS on top of the bpf stream
> > > verdict program has been replaced with sk_psock_start_strp(). This
> > > will in turn kick the stream parser again and eventually do the
> > > same thing KTLS did above calling into tcp_rcv_skb() and dequeuing
> > > a skb from the sk_receive_queue.
> > > 
> > > At this point the data stream is broke. Part of the stream was
> > > handled by the KTLS side some other bytes may have been handled
> > > by the BPF side. Generally this results in either missing data
> > > or more likely a "Bad Message" complaint from the kTLS receive
> > > handler as the BPF program steals some bytes meant to be in a
> > > TLS header and/or the TLS header length is no longer correct.
> > > 
> > > We've already broke the idealized model where we can stack ULPs
> > > in any order with generic callbacks on the TX side to handle this.
> > > So in this patch we do the same thing but for RX side. We add
> > > a sk_psock_strp_enabled() helper so TLS can learn a BPF verdict
> > > program is running and add a tls_sw_has_ctx_rx() helper so BPF
> > > side can learn there is a TLS ULP on the socket.
> > > 
> > > Then on BPF side we omit calling our stream parser to avoid
> > > breaking the data stream for the KTLS receiver. Then on the
> > > KTLS side we call BPF_SK_SKB_STREAM_VERDICT once the KTLS
> > > receiver is done with the packet but before it posts the
> > > msg to userspace. This gives us symmetry between the TX and
> > > RX halfs and IMO makes it usable again. On the TX side we
> > > process packets in this order BPF -> TLS -> TCP and on
> > > the receive side in the reverse order TCP -> TLS -> BPF.
> > > 
> > > Discovered while testing OpenSSL 3.0 Alpha2.0 release.
> > > 
> > > Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---

[...]

> > > +static void sk_psock_tls_verdict_apply(struct sk_psock *psock,
> > > +				       struct sk_buff *skb, int verdict)
> > > +{
> > > +	switch (verdict) {
> > > +	case __SK_REDIRECT:
> > > +		sk_psock_skb_redirect(psock, skb);
> > > +		break;
> > > +	case __SK_PASS:
> > > +	case __SK_DROP:
> > 
> > The two cases above need a "fallthrough;", right?
> 
> Correct otherwise will get the "fallthrough" patch shortly after this
> lands. Thanks I'll add it.
> 

hmm actually I don't think we need 'fallthrough;' here when the
case doesn't have statements,

 switch (a) {
 case 1:
 case 2:
 default:
     break;
 }

seems OK to me. I don't have a preference though so feel free to
correct me.
