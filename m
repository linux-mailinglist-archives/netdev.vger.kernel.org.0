Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37FA81E761
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 06:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfEOERY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 00:17:24 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:50227 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEOERY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 00:17:24 -0400
Received: by mail-it1-f196.google.com with SMTP id i10so2685801ite.0;
        Tue, 14 May 2019 21:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2GgFXSPMTBM9YpduS8XXMMsk6iAZV4OBmIu0NVIWTH8=;
        b=eJIz/ZVT1u24mqnGYvamUn7LQpwK5wUQeMojW3RsJqmqQbh9awwuJUu5zBTrZv7hxk
         UxWe3kr4yoHCzNJmHDIOSONGtDCCeL0F8wJI8pnw2Vq1urzoksvaWoxE3/5gEq8J9buU
         nA1VueHgT5yD+BWsfTMmj8fY360txiityuGcCnQJ03z2VvRWOaIP6BsoM4fasc8nvSRM
         feZeuF3gcxKOiw0i9oNv58fUwPx5hwvMTmnBLGufbQac3Nhs1Gr49sWW9XsRc/wdT7wu
         v/qf0w4r+dr+eHTddRSh2j9CUAQe4jmdw/NQaNU6qP4PZy9sjyF264tdhT0au6kvSQML
         MVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2GgFXSPMTBM9YpduS8XXMMsk6iAZV4OBmIu0NVIWTH8=;
        b=CgZ9uWllqyC0xjHnqkxOXonD6GaViD/CCy7/KGB12PG4WzBvxbToOwaNj+oRSK2/Y5
         SY+cLJE0C/mpg2V1w/PgYv5ZyHOPkgroWqQA8x9Emm6rIPeIqI1lZpJyi0o32SGcubxw
         jUfVbyJvUYY5c67vmJGaVkokcR8GfOSsqHQ3oA1RVif7xy4NgUHRKWY4AQkaXLTKWZPs
         Ky21D+iLf4c14+QCdocRScMZdIk7zxaKCQwLzLih+122AIfa5weNS1aYERrXS0y1Dchy
         bnTmAX4FEjf70KoI4Fc+RYRQBVY8Nuxl8Mm+g5xrOwC6Ja1VI9GeVO668PgsqaKye4gU
         WTpw==
X-Gm-Message-State: APjAAAUvPCtq0cfAEiNuw2HNNzI80X5/QYemaS64KgK+kUzrW6Owli1r
        7b8fs4PaN+YRGknIYYAJ24HRgtgH6hk=
X-Google-Smtp-Source: APXvYqxyM3z7EblIbF9akdJbp+qVY9vs0X5PzIZRw/wHnuWDP86Svky6OcDQ9Q35tmY/ePoqnD0vRg==
X-Received: by 2002:a24:4043:: with SMTP id n64mr2987853ita.25.1557893843587;
        Tue, 14 May 2019 21:17:23 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e188sm576988ite.20.2019.05.14.21.17.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 21:17:23 -0700 (PDT)
Date:   Tue, 14 May 2019 21:17:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Message-ID: <5cdb92cc4bed5_12292afa9bb1c5b8d5@john-XPS-13-9360.notmuch>
In-Reply-To: <20190514155857.1f10ef78@cakuba.netronome.com>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
 <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
 <20190510100054.29f7235c@cakuba.netronome.com>
 <5cd603329f753_af72ae355cbe5b8e8@john-XPS-13-9360.notmuch>
 <5cdb428fe9f53_3e672b0357f765b85c@john-XPS-13-9360.notmuch>
 <20190514155857.1f10ef78@cakuba.netronome.com>
Subject: Re: [bpf PATCH v4 1/4] bpf: tls, implement unhash to avoid transition
 out of ESTABLISHED
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Tue, 14 May 2019 15:34:55 -0700, John Fastabend wrote:
> > John Fastabend wrote:
> > > Jakub Kicinski wrote:  
> > > > On Thu, 09 May 2019 21:57:49 -0700, John Fastabend wrote:  
> > > > > @@ -2042,12 +2060,14 @@ void tls_sw_free_resources_tx(struct sock *sk)
> > > > >  	if (atomic_read(&ctx->encrypt_pending))
> > > > >  		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
> > > > >  
> > > > > -	release_sock(sk);
> > > > > +	if (locked)
> > > > > +		release_sock(sk);
> > > > >  	cancel_delayed_work_sync(&ctx->tx_work.work);  
> > > > 
> > > > So in the splat I got (on a slightly hacked up kernel) it seemed like
> > > > unhash may be called in atomic context:
> > > > 
> > > > [  783.232150]  tls_sk_proto_unhash+0x72/0x110 [tls]
> > > > [  783.237497]  tcp_set_state+0x484/0x640
> > > > [  783.241776]  ? __sk_mem_reduce_allocated+0x72/0x4a0
> > > > [  783.247317]  ? tcp_recv_timestamp+0x5c0/0x5c0
> > > > [  783.252265]  ? tcp_write_queue_purge+0xa6a/0x1180
> > > > [  783.257614]  tcp_done+0xac/0x260
> > > > [  783.261309]  tcp_reset+0xbe/0x350
> > > > [  783.265101]  tcp_validate_incoming+0xd9d/0x1530
> > > > 
> > > > I may have been unclear off-list, I only tested the patch no longer
> > > > crashes the offload :(
> > > >   
> > > 
> > > Yep, I misread and thought it was resolved here as well. OK I'll dig into
> > > it. I'm not seeing it from selftests but I guess that means we are missing
> > > a testcase. :( yet another version I guess.
> > >   
> > 
> > Seems we need to call release_sock in the unhash case as well. Will
> > send a new patch shortly.
> 
> My reading of the stack trace was that unhash gets called from
> tcp_reset(), IOW from soft IRQ, so we can't cancel_delayed_work_sync()
> in tls_sw_free_resources_tx(), no?

Well the tcp_close() path has the lock held and can also call unhash(). Anyways
this dropping the sock lock in the middle of the block seems a bit suspect
to me anyways. I think we can defer the free until after sock is released this
is how it was solved on sockmap side.
