Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD05D72F2E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfGXMtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:49:12 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34572 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfGXMtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:49:12 -0400
Received: by mail-qt1-f195.google.com with SMTP id k10so45374927qtq.1;
        Wed, 24 Jul 2019 05:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0WBo3IsNsY5g/rd7NYWisaoVCSXDyqaWOjzbDM1CWZw=;
        b=sxNa+CbugClWUnnuVvNwv2pJiScBOkIM+/35RkXgkjSB3qaxgc85KD+H4TmK/89FPN
         QfCLSmtT01Uje8LIaa3QkntL3II5SFDz0yOEKr9JNjfO+3vpIUKullZyndmsCjxNaWER
         vmwtaQ9oQIYStqjGrFaCLnBgSUksXJPgzBIosqAkzY6Tr6pUD6kihj6ptIqpOz2QCaiu
         CG9Xdu/Hqr3dD4OaAnPREhhD4eSBN28PA6j0tuRan1NJZ6tvYLQoDuwivezjY5KS77Ft
         KMvmOfYHjnVFlFpWuCSOmeCZSNrH5gcl0842chTLDCO5T2Zvy45qqIWjH7Y5sWIU0RHN
         Nv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0WBo3IsNsY5g/rd7NYWisaoVCSXDyqaWOjzbDM1CWZw=;
        b=XWxwucCpQPBT6JGHfrUss4U8/0C7LAJRWmzHZEz4Qp6ROj6sd/Sa5gQSbOF6dsBd/T
         y3MP6uLsva4uGrf0/MfuOkC/vBLuJ1VSyjDZl8YacUqBh2UVgMrVWiYl7VtJt9nvpGGV
         ULXMP6L89kMvKTd/8esSX/9aZrWzGhACrz44vjdEeJDZG1ZCi4Zkw2ZmjyawYDO70xyd
         3Oi42s6ZRez5hypHY0sK3BNNJoNyFCW6U7xF0kakVhcj4vdXsak2woSaCdJrlefPYAh7
         JfL9mIypsOcwefLqfYSWhsoq6flkycsw8V+7AQEICiYyUGaAyv5rz/LEmDPUj8JR5XYz
         pbfA==
X-Gm-Message-State: APjAAAXAEceQykobkkQxTQnDiUR12tXg2pmRnVunLZx09iyxTAHF7PCr
        +yNneHdTqy0UlJRGyImgzZo=
X-Google-Smtp-Source: APXvYqw5uo7gEt1mXAq+bdLphV1M9PJvEwcw+ggeydhSk+n2lVgAAvMuRFTiau7c3WW5tjp4MPAmKA==
X-Received: by 2002:ad4:4562:: with SMTP id o2mr59523838qvu.116.1563972551177;
        Wed, 24 Jul 2019 05:49:11 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:2135:7c3d:d61c:7f11:969d])
        by smtp.gmail.com with ESMTPSA id m19sm20478652qkk.29.2019.07.24.05.49.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 05:49:10 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D6FACC0AAD; Wed, 24 Jul 2019 09:49:07 -0300 (-03)
Date:   Wed, 24 Jul 2019 09:49:07 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size
 in __sctp_setsockopt_connectx
Message-ID: <20190724124907.GA8640@localhost.localdomain>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <20190723152449.GB8419@localhost.localdomain>
 <CADvbK_eiS26aMZcPrj2oNvZh_42phWiY71M7=UNvjEeB-B9bDQ@mail.gmail.com>
 <20190724112235.GA7212@hmswarspite.think-freely.org>
 <20190724123650.GD6204@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724123650.GD6204@localhost.localdomain>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 09:36:50AM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Jul 24, 2019 at 07:22:35AM -0400, Neil Horman wrote:
> > On Wed, Jul 24, 2019 at 03:21:12PM +0800, Xin Long wrote:
> > > On Tue, Jul 23, 2019 at 11:25 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > >
> > > > On Tue, Jul 23, 2019 at 01:37:57AM +0800, Xin Long wrote:
> > > > > Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
> > > > > sctp_inet_connect(), the latter has done addr_size check with size
> > > > > of sa_family_t.
> > > > >
> > > > > In the next patch to clean up __sctp_connect(), we will remove
> > > > > addr_size check with size of sa_family_t from __sctp_connect()
> > > > > for the 1st address.
> > > > >
> > > > > So before doing that, __sctp_setsockopt_connectx() should do
> > > > > this check first, as sctp_inet_connect() does.
> > > > >
> > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > ---
> > > > >  net/sctp/socket.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > index aa80cda..5f92e4a 100644
> > > > > --- a/net/sctp/socket.c
> > > > > +++ b/net/sctp/socket.c
> > > > > @@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
> > > > >       pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
> > > > >                __func__, sk, addrs, addrs_size);
> > > > >
> > > > > -     if (unlikely(addrs_size <= 0))
> > > > > +     if (unlikely(addrs_size < sizeof(sa_family_t)))
> > > > I don't think this is what you want to check for here.  sa_family_t is
> > > > an unsigned short, and addrs_size is the number of bytes in the addrs
> > > > array.  The addrs array should be at least the size of one struct
> > > > sockaddr (16 bytes iirc), and, if larger, should be a multiple of
> > > > sizeof(struct sockaddr)
> > > sizeof(struct sockaddr) is not the right value to check either.
> > > 
> > > The proper check will be done later in __sctp_connect():
> > > 
> > >         af = sctp_get_af_specific(daddr->sa.sa_family);
> > >         if (!af || af->sockaddr_len > addrs_size)
> > >                 return -EINVAL;
> > > 
> > > So the check 'addrs_size < sizeof(sa_family_t)' in this patch is
> > > just to make sure daddr->sa.sa_family is accessible. the same
> > > check is also done in sctp_inet_connect().
> > > 
> > That doesn't make much sense, if the proper check is done in __sctp_connect with
> > the size of the families sockaddr_len, then we don't need this check at all, we
> > can just let memdup_user take the fault on copy_to_user and return -EFAULT.  If
> > we get that from memdup_user, we know its not accessible, and can bail out.
> > 
> > About the only thing we need to check for here is that addr_len isn't some
> > absurdly high value (i.e. a negative value), so that we avoid trying to kmalloc
> > upwards of 2G in memdup_user.  Your change does that just fine, but its no
> > better or worse than checking for <=0
> 
> One can argue that such check against absurdly high values is random
> and not effective, as 2G can be somewhat reasonable on 8GB systems but
> certainly isn't on 512MB ones. On that, kmemdup_user() will also fail
> gracefully as it uses GFP_USER and __GFP_NOWARN.
> 
> The original check is more for protecting for sane usage of the
> variable, which is an int, and a negative value is questionable. We
> could cast, yes, but.. was that really the intent of the application?
> Probably not.

Though that said, I'm okay with the new check here: a quick sanity
check that can avoid expensive calls to kmalloc(), while more refined
check is done later on.

> 
> > 
> > Neil
> > 
> > > >
> > > > Neil
> > > >
> > > > >               return -EINVAL;
> > > > >
> > > > >       kaddrs = memdup_user(addrs, addrs_size);
> > > > > --
> > > > > 2.1.0
> > > > >
> > > > >
> > > 
