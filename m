Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C641997177
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 07:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfHUFSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 01:18:39 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46625 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfHUFSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 01:18:38 -0400
Received: by mail-io1-f65.google.com with SMTP id x4so2007932iog.13
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 22:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=29a7VDSH/j6+3zBU66+rpAvOihhY9EqwM/lySdFZ0Yk=;
        b=pnVBkiwDD3LQ+ugRpXHBLHdmBg3dZyQHXQTyRsjcCSy2A/jCiOjFkskH3DU/TEK0fE
         GBwSyu5zPeoYqD/L8tRdyYl5baqf1Pg95ympQEiq66c5Idh8kCzSeq9dIczL5qdV2Vk0
         ECuUeh+bV1yXkPfLjFMt85v9MHEj6xHGBibudCwYtLJbeSEf55TTEXVEEB+3cznIsI6Z
         08ETQDBhz2cvoVe5wTMg5APL2t6jb/ZpIXZL/aW9k4CeU2PO/1zeIITc4k/NqaYbLhbG
         aELmNYX9n+r4K/nLTpQyXObc90am3EMETKtOMdHPoJxG56DGKU2ysS6hLyxeI674rvL0
         r8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=29a7VDSH/j6+3zBU66+rpAvOihhY9EqwM/lySdFZ0Yk=;
        b=muHykNc+4uvmrUNTHrWo9wPAAqddkMIOvtsnyjw8oLAr7EJz44Jbr+oCO+jvT1JeVd
         /uXDFsq5HQk0ZPeFpFdS7sJmi5QettQdsgot/BskOljSI+JU/9zQbkZFPEdUnS1HNQl8
         Rt0+yopkeDcyFGRTfiKPL9rGpdnagDzD4APfq9yph4jWDoD3dLUQf3CXLNyGQKrSbQxy
         szUwYjUY8xa24UtopGTnFV5LupZxi/xOYXJh0po+N7jx+bSAvTJ8R4GeRli2P3fU3HnE
         8A+F1yAL4Fb3VlHm4lsiioc1CzvHet6aYNB+bcQE4YQOX4bLJ1JUc3MANp5JBAiozwPi
         Jnzg==
X-Gm-Message-State: APjAAAVZMIuo3m2MmkjLEPetITtHelKuQtk12kWrFLG+w/kcLY6+xwh8
        lP9EYJfRwOZfz63wNRvMPhKQDRb6Myk=
X-Google-Smtp-Source: APXvYqwhOhF6ONa++CiR+z8mQ3p6NfM0cuICAC8S4YSxACpDzLT5SiS/P1oeFz/gIIkABeZu5tKBnA==
X-Received: by 2002:a6b:9203:: with SMTP id u3mr3036744iod.3.1566364717945;
        Tue, 20 Aug 2019 22:18:37 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a21sm23310186ioe.27.2019.08.20.22.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 22:18:37 -0700 (PDT)
Date:   Tue, 20 Aug 2019 22:18:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Message-ID: <5d5cd426e18be_67732ae0ef5705bc4@john-XPS-13-9370.notmuch>
In-Reply-To: <20190820172411.70250551@cakuba.netronome.com>
References: <20190820.160517.617004656524634921.davem@davemloft.net>
 <20190820172411.70250551@cakuba.netronome.com>
Subject: Re: various TLS bug fixes...
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Tue, 20 Aug 2019 16:05:17 -0700 (PDT), David Miller wrote:
> > Jakub,
> > 
> > I just did a batch of networking -stable submissions, however I ran
> > into some troubles with the various TLS backports.
> 
> Yes, the TLS back ports are a little messy :S
> 
> > I was able to backport commit 414776621d10 ("net/tls: prevent
> > skb_orphan() from leaking TLS plain text with offload") to v5.2
> > but not to v4.19
> 
> We can probably leave that out of v4.19. The only practical scenario
> where the issue occurs to my knowledge is if admin configured TC
> redirect, or netem in the setup. Let me know if you'd rather we did the
> backport, I'm not 100% sure the risk/benefit ratio is favourable.
> 
> > I was not able to backport neither d85f01775850 ("net: tls, fix
> > sk_write_space NULL write when tx disabled") nor commit 57c722e932cf
> > ("net/tls: swap sk_write_space on close") to any release.  It seems
> > like there are a bunch of dependencies and perhaps other fixes.
> 
> Right, those should still be applicable but John and I rejigged 
> the close path quite a bit. I think the back port would be this:

Looks correct to me but would need to double check as well.

> 
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 4c0ac79f82d4..3288bdff9889 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -301,6 +301,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
>  #else
>         {
>  #endif
> +               if (sk->sk_write_space == tls_write_space)
> +                       sk->sk_write_space = ctx->sk_write_space;
>                 tls_ctx_free(ctx);
>                 ctx = NULL;
>         }
> 
> > I suspect you've triaged through this already on your side for other
> > reasons, so perhaps you could help come up with a sane set of TLS
> > bug fix backports that would be appropriate for -stable?
> 
> I'm planning to spend tomorrow working exactly on v4.19 backport. 
> I have internal reports of openssl failing on v4.19 while v4.20 
> works fine.. Hopefully I'll be able to figure that one out, test the
> above and see if there are any other missing fixes.
> 
> Is it okay if I come back to this tomorrow?

Is the failure with hw offload or sw case? If its sendpage related
looks like we also need to push the following patch back to 4.19,

commit 648ee6cea7dde4a5cdf817e5d964fd60b22006a4
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Wed Jun 12 17:23:57 2019 +0000

    net: tls, correctly account for copied bytes with multiple sk_msgs

If you have more details I can also spend some cycles looking into it.

.John
