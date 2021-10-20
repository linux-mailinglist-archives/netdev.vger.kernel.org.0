Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD34434F5B
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhJTPyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhJTPyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 11:54:18 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAE0C06161C;
        Wed, 20 Oct 2021 08:52:03 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n7so25292141iod.0;
        Wed, 20 Oct 2021 08:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QMTCPjO3wwdoiVbxw6GnEB0zqUrLMjDbBj032lhBm04=;
        b=P852d2IcahcUelfPw1MA+TVEm8UQ/Yzhok4DywJgdWgfA3FQivQnDjSNUkoI5cEnDt
         bRahYlIfOB3fqKZJaykJl978YVnUMaQQKiJmT1mAZGYYqInC3zLLjh9+uhA24y/vLNuP
         Xa+Gq1VguatrGt/E/iV01ALnjDSmwIsLOFpL5tSKVtEd4PdxgykHUlu4uXFe17DQUN44
         pmQPMtNubzAaFrnDsR8UcdNJUnVwv1TBdK025Vc5s07JhQAD5gud5rPLUTGMkjtW9Pzx
         E9QCth4lW+ZMtkGfEGjGlPmCRIbN3zI7sl5b43ger3A2/X0H2SnoUHQT3hhwSgOB7CMi
         6OGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QMTCPjO3wwdoiVbxw6GnEB0zqUrLMjDbBj032lhBm04=;
        b=aW5u76ipntM83nJ4ZsfLIFg66AX8m1yVaqTQmpNRwWeOzwS5aWFPjXS7Se/SsEZLo+
         QsjbBZj9jhkMn2YUcrJnJE9m7lObyL0xX52+K+kQ8SMqSfRvFBC/yoraFXJudCePds7U
         AxbsBX6jF068+mE7cCtXavkwGtY3cgldPqsCgLGb09XvvvA8z6iSWvQ8CsSJF7pgX1Km
         sX4MULg/TKAoYhDFDvZKTFWTeFllTF5PUZojgxOCyGSPxIUj96XbW1v5DiTvJIdTwwnF
         lAmN/Th9xnR19zutU3wFzCYt4UQviT+QEimt/IVkeEP8J2D7iSuFODrOWG7O1t6E4Q8G
         w9AQ==
X-Gm-Message-State: AOAM531Q7XU+KoTscVGlHqx1hL/25TEN8HMBX7B5BKFwSg5E7HI0qDGf
        76vBKS7ZghTCV/M9WV5YSTo=
X-Google-Smtp-Source: ABdhPJzGHDY6JouWgDmcgcUxNr30NEzWDTfdwgfmhH32dWqwiSlEXVN/TdDCsrstKLzLPVTJ65nafA==
X-Received: by 2002:a02:6064:: with SMTP id d36mr100351jaf.80.1634745122620;
        Wed, 20 Oct 2021 08:52:02 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id j3sm1291284ilu.15.2021.10.20.08.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 08:52:02 -0700 (PDT)
Date:   Wed, 20 Oct 2021 08:51:52 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com
Message-ID: <61703b183b7ac_48ee720873@john-XPS-13-9370.notmuch>
In-Reply-To: <87pmrzg28a.fsf@cloudflare.com>
References: <20211011191647.418704-1-john.fastabend@gmail.com>
 <20211011191647.418704-2-john.fastabend@gmail.com>
 <87tuhdfpq4.fsf@cloudflare.com>
 <616fa9127fa63_340c7208ef@john-XPS-13-9370.notmuch>
 <87pmrzg28a.fsf@cloudflare.com>
Subject: Re: [PATCH bpf 1/4] bpf, sockmap: Remove unhash handler for BPF
 sockmap usage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Wed, Oct 20, 2021 at 07:28 AM CEST, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> >> On Mon, Oct 11, 2021 at 09:16 PM CEST, John Fastabend wrote:
> >> > We do not need to handle unhash from BPF side we can simply wait for the
> >> > close to happen. The original concern was a socket could transition from
> >> > ESTABLISHED state to a new state while the BPF hook was still attached.
> >> > But, we convinced ourself this is no longer possible and we also
> >> > improved BPF sockmap to handle listen sockets so this is no longer a
> >> > problem.
> >> >
> >> > More importantly though there are cases where unhash is called when data is
> >> > in the receive queue. The BPF unhash logic will flush this data which is
> >> > wrong. To be correct it should keep the data in the receive queue and allow
> >> > a receiving application to continue reading the data. This may happen when
> >> > tcp_abort is received for example. Instead of complicating the logic in
> >> > unhash simply moving all this to tcp_close hook solves this.
> >> >
> >> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
> >> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> >> > ---
> >>
> >> Doesn't this open the possibility of having a TCP_CLOSE socket in
> >> sockmap if I disconnect it, that is call connect(AF_UNSPEC), instead of
> >> close it?
> >
> > Correct it means we may have TCP_CLOSE socket in the map. I'm not
> > seeing any problem with this though. A send on the socket would
> > fail the sk_state checks in the send hooks. (tcp.c:1245). Receiving
> > from the TCP stack would fail with normal TCP stack checks.
> >
> > Maybe we want a check on redirect into ingress if the sock is in
> > ESTABLISHED state as well? I might push that in its own patch
> > though it seems related, but I think we should have that there
> > regardless of this patch.
> >
> > Did you happen to see any issues on the sock_map side for close case?
> > It looks good to me.
> 
> OK, I didn't understand if that was an intended change or not.
> 

wrt bpf-next:
The problem is this needs to be backported in some way that fixes the
case for stable kernels as well. We have applications that are throwing
errors when they hit this at the moment.

> If we're considering allowing TCP sockets in TCP_CLOSE state in sockmap,
> a few things come to mind:

I think what makes most sense is to do the minimal work to fix the
described issue for bpf tree without introducing new issues and
then do the consistency/better cases in bpf-next.

> 
> 1) We can't insert TCP_CLOSE sockets today. sock_map_sk_state_allowed()
>    won't allow it. However, with this change we will be able to have a
>    TCP_CLOSE socket in sockmap by disconnecting it. If so, perhaps
>    inserting TCP sockets in TCP_CLOSE state should be allowed for
>    consistency.

I agree, but would hold off on this for bpf-next. I missed points
2,3 though in this series.

> 
> 2) Checks in bpf_sk_lookup_assign() helper need adjusting. Only TCP
>    sockets in TCP_LISTEN state make a valid choice (and UDP sockets in
>    TCP_CLOSE state). Today we rely on the fact there that you can't
>    insert a TCP_CLOSE socket.

This should be minimal change, just change the logic to allow only
TCP_LISTEN.

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10402,7 +10402,7 @@ BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
                return -EINVAL;
        if (unlikely(sk && sk_is_refcounted(sk)))
                return -ESOCKTNOSUPPORT; /* reject non-RCU freed sockets */
-       if (unlikely(sk && sk->sk_state == TCP_ESTABLISHED))
+       if (unlikely(sk && sk->sk_state != TCP_LISTEN))
                return -ESOCKTNOSUPPORT; /* reject connected sockets */
 
        /* Check if socket is suitable for packet L3/L4 protocol */


> 
> 3) Checks in sk_select_reuseport() helper need adjusting as well. It's a
>    similar same case as with bpf_sk_lookup_assign() (with a slight
>    difference that reuseport allows dispatching to connected UDP
>    sockets).

Is it needed here? There is no obvious check now.  Is ESTABLISHED
state OK here now?

> 
> 4) Don't know exactly how checks in sockmap redirect helpers would need
>    to be tweaked. I recall that it can't be just TCP_ESTABLISHED state
>    that's allowed due to a short window of opportunity that opens up
>    when we transition from TCP_SYN_SENT to TCP_ESTABLISHED.
>    BPF_SOCK_OPS_STATE_CB callback happens just before the state is
>    switched to TCP_ESTABLISHED.
> 
>    TCP_CLOSE socket sure doesn't make sense as a redirect target. Would
>    be nice to get an error from the redirect helper. If I understand
>    correctly, if the TCP stack drops the packet after BPF verdict has
>    selected a socket, only the socket owner will know about by reading
>    the error queue.
> 
>    OTOH, redirecting to a TCP_CLOSE_WAIT socket doesn't make sense
>    either, but we don't seem to filter it out today, so the helper is
>    not airtight.

Right. At the moment for sending we call do_tcp_sendpages() and this
has the normal check ~(TCPF_ESABLISHED | TCPF_CLOSE_WAIT) so we
would return an error. The missing case is ingress. We currently
let these happen and would need a check there. I was thinking
of doing it in a separate patch, but could tack it on to this
series for completeness.

> 
> All in all, sounds like an API change when it comes to corner cases, in
> addition to being a fix for the receive queue flush issue which you
> explained in the patch description. If possible, would push it through
> bpf-next.

I think if we address 2,3,4 then we can fix the described issue
without introducing new cases. And then 1 is great for consistency
but can go via bpf-next?

WDYT.

Thanks,
John
