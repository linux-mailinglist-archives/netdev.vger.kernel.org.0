Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2838DE1BC
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 03:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfJUBU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 21:20:28 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:35990 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfJUBU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 21:20:28 -0400
Received: by mail-oi1-f181.google.com with SMTP id k20so9662026oih.3
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 18:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rikXBpy2WdiRQCccaI2OhBDa+W/r6Hy4cLDRLEnnjB0=;
        b=hRuR9Ozo1f2AXExXLQYJydCqjkp9ngU7xXSNu6wTz1rVe6IYun6B34eRkhNanfE3hE
         lpU1d6wN+GPqT6IX/lUQCwoQ3wLyDpIK7WoWMVeiFnXf5oAfxPC3VR+TsA++V5MZJK1O
         amZVny+x8HtbQak3k8BgFoIaHcjM06Ygd+TJlvzQYgCDyCR/uey/iWhk1WzlrnK8JiRh
         3/EfWdnwEN092jhuTH/P6nU6RMWFF6m7xAOpaDCSfHc8+RsHEfI44WcS3VLTnOXQWVNn
         SLNgUm57VbgXtiGmIVt9ecVgzSyvvcMWPYs9Jsc+1TMzoCymhj707xDLQdzvOCGIJXnu
         3vKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rikXBpy2WdiRQCccaI2OhBDa+W/r6Hy4cLDRLEnnjB0=;
        b=tkICAe2NFpWDK37mdv2kg/F3x3/rOGzbhmaMam39yFNUMgOgIKD83WUj8fMhIfxPYs
         loLlujWqpTKLc9qbhtg/XpA2yi7qec6dJOq8sR4tD+5RyQ3b16mfIJL6HrZpv3RX8DWC
         N5i9TmuZgd2fseziFwjFz56a6O3+YSN1npNn+1fxyKnKFaYR8WOtsVk8mLnjCY2d0N40
         Zebe6r1fq9IYRZEXViwEqiu3XZL729SsDXmm/2NTFiZyG+DAjDyltBPVut+t8DJ/EYYh
         Mo6sI8dPKKM1KflUys/RuQSdnNSyuzN2E3b4vUzzlqckKX76Js2w/+pm/SPJbDrgVkXl
         IAOQ==
X-Gm-Message-State: APjAAAUCJBgcGmlD5v8dwfNySZnWCYiJGmF5y8ZYfitTBPOw8ZEFNsNM
        sHjjHqtJ4FqG5z5b+viD937KZETNCzUJWQcQSD4EZA==
X-Google-Smtp-Source: APXvYqzGa0dbCHfhzf7NRP9uOEC2g4Lc2mBRFXcd6gE3Ml2U3b+vZ6fMQDs0hqpQYH59WQauMnYQtOAFgZCnXZEMCXY=
X-Received: by 2002:a54:4e8a:: with SMTP id c10mr16893327oiy.14.1571620825268;
 Sun, 20 Oct 2019 18:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com> <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
In-Reply-To: <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sun, 20 Oct 2019 21:20:08 -0400
Message-ID: <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 7:15 PM Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
>
> > Hmm. Random related thought while searching for a possible cause: I
> > wonder if tcp_write_queue_purge() should clear tp->highest_sack (and
> > possibly tp->sacked_out)? The tcp_write_queue_purge() code is careful
> > to call  tcp_clear_all_retrans_hints(tcp_sk(sk)) and I would imagine
> > that similar considerations would imply that we should clear at least
> > tp->highest_sack?
> >
> > neal
>
> Hi Neal
>
> If the socket is in FIN-WAIT1, does that mean that all the segments
> corresponding to SACK blocks are sent and ACKed already?

FIN-WAIT1 just means the local application has called close() or
shutdown() to shut down the sending direction of the socket, and the
local TCP stack has sent a FIN, and is waiting to receive a FIN and an
ACK from the other side (in either order, or simultaneously). The
ASCII art state transition diagram on page 22 of RFC 793 (e.g.
https://tools.ietf.org/html/rfc793#section-3.2 ) is one source for
this, though the W. Richard Stevens books have a much more readable
diagram.

There may still be unacked and SACKed data in the retransmit queue at
this point.

> tp->sacked_out is non zero in all these crashes

Thanks, that is a useful data point. Do you know what particular value
 tp->sacked_out has? Would you be able to capture/log the value of
tp->packets_out, tp->lost_out, and tp->retrans_out as well?

> (is the SACK information possibly invalid or stale here?).

Yes, one guess would be that somehow the skbs in the retransmit queue
have been freed, but tp->sacked_out is still non-zero and
tp->highest_sack is still a dangling pointer into one of those freed
skbs. The tcp_write_queue_purge() function is one function that fees
the skbs in the retransmit queue and leaves tp->sacked_out as non-zero
and  tp->highest_sack as a dangling pointer to a freed skb, AFAICT, so
that's why I'm wondering about that function. I can't think of a
specific sequence of events that would involve tcp_write_queue_purge()
and then a socket that's still in FIN-WAIT1. Maybe I'm not being
creative enough, or maybe that guess is on the wrong track. Would you
be able to set a new bit in the tcp_sock in tcp_write_queue_purge()
and log it in your instrumentation point, to see if
tcp_write_queue_purge()  was called for these connections that cause
this crash?

thanks,
neal
