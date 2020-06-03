Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB531ED8CC
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 00:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgFCWvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 18:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgFCWvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 18:51:51 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0CEC08C5C0;
        Wed,  3 Jun 2020 15:51:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g12so1334478pll.10;
        Wed, 03 Jun 2020 15:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=75AnbeF25C5PRHxMmWsplju/2l9IUUVHTzTZ0/yQJAc=;
        b=SDhBGLUJVPcBJbIeW5nwe6+j1yB0umBcNiVJr5B1L82JZptTYzKpKq7oTfaunxCfE2
         G9m9P3VUA8YordePTB2o7TCUPrDMekcMK8UU8pvuPDF0b2ysRKLEMGi3pXmlzbAwHQ6C
         ekGLoBBW/9NlIkBg75FRE4d/0ML/VN3C91xIisv1arzlteZiyjg3Sb9lcxptXkdnLffW
         XsRVegn1omS6cj1eYpAWZR0OFUMBfCGqRIt1er4MnpfWLiiebdXz2152LRxDRWevgOWe
         /8KB6bUUU7JKFw9pCKsfDER4mp2hWRhzcvKf4y3ToSh8l/q//pmMmh9U+VTeXTok1P/1
         xXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=75AnbeF25C5PRHxMmWsplju/2l9IUUVHTzTZ0/yQJAc=;
        b=YB8Fnc2OPN900iSDmyCadKZgI7A36UCJBpd+qKD9pMqI+wn+YZpqHfRF5KFLEU9HwQ
         Gspvay5VBr8NmayarUk4qzpV+mOVHjmGdGlkYQ568X8yTdAQCsQoBNnGyH5du5vknr6T
         4TO9cWDnHQM0uyYOlytuOcjqiXNGzPxJIpEJZ1K6AOFzcoWLfGsi22ykApV1RQoi0lPL
         1B0urZodKPBThIVfxP1oQ3rgd+n65Lrzm5lTSP5nuU7btE3OSuCaQ0qdMoMY8eBqgLLy
         S+jyc500mm7athd//fM3AdHbUbLFMcUC3fgKrkB305+XTpCCCdtAChwvSbSJpnzxkKv9
         IOvw==
X-Gm-Message-State: AOAM531BZqRBUmlHL6XSG1Yae5uOgsXyXUeADigzDOkZKg/WABPwbsEH
        XokjVqcohZYp8jBzWAHAO1alsgeEj84=
X-Google-Smtp-Source: ABdhPJz4pidEV/JBtin0o/PScX4wuDrRQl7WdxdFMqQxZX03oEiDeQKoC2pbF+5b5ImvIGr4w5XPtw==
X-Received: by 2002:a17:90a:aa8f:: with SMTP id l15mr2626996pjq.156.1591224710358;
        Wed, 03 Jun 2020 15:51:50 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k101sm4094947pjb.26.2020.06.03.15.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 15:51:49 -0700 (PDT)
Date:   Wed, 03 Jun 2020 15:51:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5ed8297cbf0fd_6d732af83f96a5c0a5@john-XPS-13-9370.notmuch>
In-Reply-To: <878sh33mvj.fsf@cloudflare.com>
References: <158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower>
 <6f8bb6d8-bb70-4533-f15b-310db595d334@gmail.com>
 <87a71k2yje.fsf@cloudflare.com>
 <5ed7ed7d315bd_36aa2ab64b3c85bcd9@john-XPS-13-9370.notmuch>
 <878sh33mvj.fsf@cloudflare.com>
Subject: Re: [bpf PATCH] bpf: sockmap, remove bucket->lock from
 sock_{hash|map}_free
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Wed, Jun 03, 2020 at 08:35 PM CEST, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> 
> [...]
> 
> >> I'm not sure that the check for map->refcnt when sock is unlinking
> >> itself from the map will do it. I worry we will then have issues when
> >> sockhash is unlinking itself from socks (so the other way around) in
> >> sock_hash_free(). We could no longer assume that the sock & psock
> >> exists.
> >>
> >> What comes to mind is to reintroduce the spin-lock protected critical
> >> section in sock_hash_free(), but delay the processing of sockets to be
> >> unlinked from sockhash. We could grab a ref to sk_psock while holding a
> >> spin-lock and unlink it while no longer in atomic critical section.
> >
> > It seems so. In sock_hash_free we logically need,
> >
> >  for (i = 0; i < htab->buckets_num; i++) {
> >   hlist_for_each_entryy_safe(...) {
> >   	hlist_del_rcu() <- detached from bucket and no longer reachable
> 
> Just to confirm - synchronize_rcu() doesn't prevent
> sock_hash_delete_from_link() from getting as far as hlist_del_rcu(),
> that is here [0], while on another cpu sock_hash_free() is also
> performing hlist_del_rcu().

Right.

> 
> That is, reintroducing the spin-lock is needed, right? Otherwise we have
> two concurrent updaters that are not synchronized.
> 

Agree I don't have any better idea.

> >         synchronize_rcu()
> >         // now element can not be reached from unhash()
> > 	... sock_map_unref(elem->sk, elem) ...
> >   }
> >  }
> >
> > We don't actually want to stick a synchronize_rcu() in that loop
> > so I agree we need to collect the elements do a sync then remove them.
> 
> [...]
> 
> >>
> >> John, WDYT?
> >
> > Want to give it a try? Or I can draft something.
> 
> I can give it a try, as I clearly need to wrap my head better around
> this code path. But I can only see how to do it with a spin-lock back in
> place in sock_hash_free(). If you have an idea in mind how to do it
> locklessly, please go ahead.

No I can't think of anything better.

> 
> [...]
> 
> [0] https://elixir.bootlin.com/linux/latest/source/net/core/sock_map.c#L738


