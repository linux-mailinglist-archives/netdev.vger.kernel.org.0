Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6871E52E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 00:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfENWfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 18:35:07 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32984 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfENWfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 18:35:07 -0400
Received: by mail-io1-f67.google.com with SMTP id z4so642099iol.0;
        Tue, 14 May 2019 15:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=c6VIJcB489ztcRK0OwTZEV2xJHqOq/bHOIY/aqM0MDA=;
        b=FyQDWCqIO+zllMezkVswKNsrfrAjRoxdWQwYjJokW1fRuNYOkgFPfnixHIv8WS1Pcm
         cNUQZwbgsXPU7Ul7TKWD+fVBf7TdXLyLdiHyk+yZ8EbknBpvArfRd0LvqXovvu+y1ZT0
         GsCrHS/N0UwPoaaCei8SNcLwCKKkfOAVAOErp2b2NP3VtyeLXGH6Slx264KA2FlpFZMM
         7u2vCuWKR/fnaLZoU2lseFVZ2bJwwuTlCo52D2Kzup9x6yAQvOr9WcNluR1zVR3X2Om3
         GInNY7woejGljh+NpT0xbEtyW0jzqS8CmjRReA2GfO6iUqx/kUYrXLVri+5JhVBkf8xy
         h+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=c6VIJcB489ztcRK0OwTZEV2xJHqOq/bHOIY/aqM0MDA=;
        b=kp3YqcS/fGYmL4l1n6pwKY8gCEfyeS5cwpMv90DdUeRXFULBuZW+Irle16xhnb0xj6
         daw7SlkXaTvOgpipi8gbTiS/lYlek6x+lokwn0jyeCRqJ/ahs89I8gFYlU2wdiRA+Ki8
         YhmEKGNAp+Jhm4mRKis6mxaCqiHjs2+0EEPIvzUegptDLf/sODBaHsnBatTSTJQEveXO
         QbRmvpk2zxGTkumMRf8GQKNiSJ+LSGTqCFUHc7OKgcb6myl4YBMtZxkhqWlk+qu5Yp8P
         nxx0y/+4lPH4r96F5vzuYyt46lg2+ceWrmgAadc/mzICRx7M+MdyQ/rPDc71lH/Wm2n+
         W5fw==
X-Gm-Message-State: APjAAAUoFGim4hyculexi6+n/xaTFXyvUBQHubTfyh1zk8f6xP6PJBeO
        MCvPhT8xSomYeB2c7VpN3dI=
X-Google-Smtp-Source: APXvYqx+Mmt7ClhQ20pvgDTvu7FiqTiQcUzT9Lmb/8enKmOL0BU8phBJFwGpFnEZ6da6z7wQWS6UBA==
X-Received: by 2002:a6b:ef07:: with SMTP id k7mr20643762ioh.276.1557873306105;
        Tue, 14 May 2019 15:35:06 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k76sm213428ita.6.2019.05.14.15.35.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 15:35:05 -0700 (PDT)
Date:   Tue, 14 May 2019 15:34:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Message-ID: <5cdb428fe9f53_3e672b0357f765b85c@john-XPS-13-9360.notmuch>
In-Reply-To: <5cd603329f753_af72ae355cbe5b8e8@john-XPS-13-9360.notmuch>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
 <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
 <20190510100054.29f7235c@cakuba.netronome.com>
 <5cd603329f753_af72ae355cbe5b8e8@john-XPS-13-9360.notmuch>
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

John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Thu, 09 May 2019 21:57:49 -0700, John Fastabend wrote:
> > > @@ -2042,12 +2060,14 @@ void tls_sw_free_resources_tx(struct sock *sk)
> > >  	if (atomic_read(&ctx->encrypt_pending))
> > >  		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
> > >  
> > > -	release_sock(sk);
> > > +	if (locked)
> > > +		release_sock(sk);
> > >  	cancel_delayed_work_sync(&ctx->tx_work.work);
> > 
> > So in the splat I got (on a slightly hacked up kernel) it seemed like
> > unhash may be called in atomic context:
> > 
> > [  783.232150]  tls_sk_proto_unhash+0x72/0x110 [tls]
> > [  783.237497]  tcp_set_state+0x484/0x640
> > [  783.241776]  ? __sk_mem_reduce_allocated+0x72/0x4a0
> > [  783.247317]  ? tcp_recv_timestamp+0x5c0/0x5c0
> > [  783.252265]  ? tcp_write_queue_purge+0xa6a/0x1180
> > [  783.257614]  tcp_done+0xac/0x260
> > [  783.261309]  tcp_reset+0xbe/0x350
> > [  783.265101]  tcp_validate_incoming+0xd9d/0x1530
> > 
> > I may have been unclear off-list, I only tested the patch no longer
> > crashes the offload :(
> > 
> 
> Yep, I misread and thought it was resolved here as well. OK I'll dig into
> it. I'm not seeing it from selftests but I guess that means we are missing
> a testcase. :( yet another version I guess.
> 

Seems we need to call release_sock in the unhash case as well. Will
send a new patch shortly.

.John

> Thanks,
> John
> 
