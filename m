Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90019878D
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbfHUWz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:55:27 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45998 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731036AbfHUWz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:55:27 -0400
Received: by mail-qk1-f196.google.com with SMTP id m2so3386907qki.12
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 15:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nrPZov62TO3RLm/bghYf6pttKle8lYIN4Q/3ugMqBF4=;
        b=Oe19zsqRQt+ojJCl63atgbjTjuRrH/0qejvj+rnoEEGSQK+fh+8tsUYXztFpra3tis
         bUm/yOWqP8amdm+DmMv5DdmGG0WTcAl8LZZBoqRrYR4aQq0z7+P0ZygwJVE5mR4uySOR
         92YFRAT4Wfk/B6ib2ls3XDBuzv/md7SEB4Dqq7J8Tx9SGUdpHcns8NgRALP6aNLTy4rO
         qi2n7H4eJaKFdcjSmSC5xdjNpYMIfhfp3++v5R+UsJqUATVjfFwralvto53fuRS6xb7w
         SiYMf4cj+ArCMPCqJh1of9n/aEejHOmjHtE5IUm3VQq4GRWGCumYx1uUBProS3EdGf1D
         7N9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nrPZov62TO3RLm/bghYf6pttKle8lYIN4Q/3ugMqBF4=;
        b=c2u3g39/+ImojAB2LbvAPWc4bfDPJSlVHMCjyAjW9Ed4gjhpobGOQ63MaRZgNmx6oW
         mBolaIYnpwzvu4hQpc1/Et02FsUOJ1aVXlgnVMLvx9b3M7iVyNavaqRluC0Avz13RhgV
         snpRpOae+ihbCP3Ym5p6E87U1nMZkomahDqDmzxFrBJs2YZgvKKLmJdiew1YJdYzfVzu
         E6l7H3ZqF22MjLL2Wh4nzj7nh9trsd7yQq5ftn2oUDT+iN6OZgrhH3D8u1WMQtGzm4p2
         8HeK9b/qktGt+K6lLUk+/I8TO5yHsLnj4k5GM0H1uZYohspaArkpy7VoHeE90g1DtQKJ
         v4Qg==
X-Gm-Message-State: APjAAAXHNGKkryO5jBhUoHWUBkHGEIytgRVgqcUKEPrLtZstwNj6pGJC
        f3V5hdNNO7KJNbkjB1kDhY2o2w==
X-Google-Smtp-Source: APXvYqxvqA57914cNpl8+XXNDP1dYGn6AJDLNYrUm7pGcpFoO+cqJYCqBrirjC1xliSNzmUT9KZd0A==
X-Received: by 2002:a37:4b49:: with SMTP id y70mr31519059qka.447.1566428126252;
        Wed, 21 Aug 2019 15:55:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o127sm11167710qkd.104.2019.08.21.15.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 15:55:26 -0700 (PDT)
Date:   Wed, 21 Aug 2019 15:55:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: various TLS bug fixes...
Message-ID: <20190821155519.61d9feda@cakuba.netronome.com>
In-Reply-To: <20190821110346.449c5612@cakuba.netronome.com>
References: <20190820.160517.617004656524634921.davem@davemloft.net>
        <20190820172411.70250551@cakuba.netronome.com>
        <5d5cd426e18be_67732ae0ef5705bc4@john-XPS-13-9370.notmuch>
        <20190820235112.2b5348aa@cakuba.netronome.com>
        <20190821110346.449c5612@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 11:03:46 -0700, Jakub Kicinski wrote:
> On Tue, 20 Aug 2019 23:51:12 -0700, Jakub Kicinski wrote:
> > > If you have more details I can also spend some cycles looking into it.    
> > 
> > Awesome, I'll let you know what the details are as soon as I get them.  
> 
> Just a quick update on that.
> 
> The test case is nginx running with ktls offload.
> 
> The client (hurl or openssl client) requests a file of ~2M, but only
> 44K ever gets across (not even sure which side sees an error at this
> point, outputs are pretty quiet).

I had a look, it's this:

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 6848a8196711..8a05e4bf1c58 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -370,7 +370,8 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
        lock_sock(sk);
 
-       if (tls_complete_pending_work(sk, tls_ctx, msg->msg_flags, &timeo))
+       ret = tls_complete_pending_work(sk, tls_ctx, msg->msg_flags, &timeo);
+       if (ret)
                goto send_end;
 
        if (unlikely(msg->msg_controllen)) {

Which is commit 150085791afb ("net/tls: Fixed return value when
tls_complete_pending_work() fails"). 

I also tried to test what we described previously for sk_write_space
and it seems to work okay (although TBH I'm not sure my testing is 100%
here, I can't reliably trigger that race in the first place).
