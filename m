Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995AB3A37BD
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhFJXVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:21:02 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:37753 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhFJXVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:21:01 -0400
Received: by mail-pf1-f179.google.com with SMTP id y15so2887762pfl.4
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uyOhOaHXVT77K8RWfSrA1Uvm4HDc1MkZJtmAnrZlEXI=;
        b=K/kpcYw9tf2NR1vbvDs4Gt/cRiyrw7RRzKnKgEwWinXAQ3myqCk/mYv9rjnxLvO2od
         7r5pzPl8fKW/owhMURWqvA+2kNJW5hxDLb0eUlqpvQ48ZaTfX1Sa/fXMbG3Vd8KDCCiI
         EKUML9Ds9VyhwkATFUdyNPyiP6RTeTHggNJujmwSKeIBFC5IjgAew7T6WjCR5c2Vm1p5
         reetGE0xp3kyQJS6exncqHKH39mCc/KtEYnm/P0Rk38Vou1X6LZQQwFB5sZivBP/qiE3
         Y27NdijdDZVjCoQ1K1lAlJ8jQ+aNJnrhPMx0KfRLG7eEoJI5EDgVg7WvRpcM0wjaNqmB
         4JHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uyOhOaHXVT77K8RWfSrA1Uvm4HDc1MkZJtmAnrZlEXI=;
        b=ejhNdYvi+bqipnLbFDRHrBzrVziYLL+cE8ORg/TA1HzfOn6zT9ntycqKYaGH+HHHtg
         EAXf8yyFoVXjClSGIqpvVSECwLvnyljGGCRZ3S/WDkKjUN+5s/DKFysWrx69CcQXRXf9
         w+sL8BgRXdm1uMyOmQ+W0PQ6HKT2xkFwk3dvCJRbpZRMQRku65tZAxNcUToQ4yFckLdf
         oC7O7hjzXSJ04I8zOEmNQHCYmvjEuQp3GSpMgIb+PEQLr1b0N9iHMlGVbvhukpN2cVJn
         9FYyyCpjaG1CSU/vd2e1zgtNVQha5MfhIKYwK0eyWszlO6qKLmV9V3u3W7mZnA/7dXaE
         x3qQ==
X-Gm-Message-State: AOAM532oNih539v/cMFPeQfeNaF5ZBAgTkQ2jmt8QlJf0KFxmU7PfKog
        1HprRSVSb+d/5ByM9BgyvPHVGBiCqTv1eemA
X-Google-Smtp-Source: ABdhPJwaGKAhBoRNRz/00e1S5eHw103rDfscpap0Cy3Hb9IHG5VSr+3NOGUqVCDSRRcV3eEMflxEZw==
X-Received: by 2002:a65:5b0d:: with SMTP id y13mr709777pgq.165.1623367069784;
        Thu, 10 Jun 2021 16:17:49 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id t13sm3365560pfh.97.2021.06.10.16.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:17:49 -0700 (PDT)
Date:   Thu, 10 Jun 2021 16:17:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] utils: bump max args number to 256 for batch
 files
Message-ID: <20210610161742.64e4c0e5@hermes.local>
In-Reply-To: <20210610075857.GA7611@linux.home>
References: <4a0fcf72130d3ef5c4ca91b518f66ac6449cf57f.1622565590.git.gnault@redhat.com>
        <20210609165949.5806f75d@hermes.local>
        <20210610075857.GA7611@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Jun 2021 09:58:57 +0200
Guillaume Nault <gnault@redhat.com> wrote:

> On Wed, Jun 09, 2021 at 04:59:49PM -0700, Stephen Hemminger wrote:
> > On Tue, 1 Jun 2021 19:09:31 +0200
> > Guillaume Nault <gnault@redhat.com> wrote:
> >   
> > > Large tc filters can have many arguments. For example the following
> > > filter matches the first 7 MPLS LSEs, pops all of them, then updates
> > > the Ethernet header and redirects the resulting packet to eth1.
> > > 
> > > filter add dev eth0 ingress handle 44 priority 100 \
> > >   protocol mpls_uc flower mpls                     \
> > >     lse depth 1 label 1040076 tc 4 bos 0 ttl 175   \
> > >     lse depth 2 label 89648 tc 2 bos 0 ttl 9       \
> > >     lse depth 3 label 63417 tc 5 bos 0 ttl 185     \
> > >     lse depth 4 label 593135 tc 5 bos 0 ttl 67     \
> > >     lse depth 5 label 857021 tc 0 bos 0 ttl 181    \
> > >     lse depth 6 label 239239 tc 1 bos 0 ttl 254    \
> > >     lse depth 7 label 30 tc 7 bos 1 ttl 237        \
> > >   action mpls pop protocol mpls_uc pipe            \
> > >   action mpls pop protocol mpls_uc pipe            \
> > >   action mpls pop protocol mpls_uc pipe            \
> > >   action mpls pop protocol mpls_uc pipe            \
> > >   action mpls pop protocol mpls_uc pipe            \
> > >   action mpls pop protocol mpls_uc pipe            \
> > >   action mpls pop protocol ipv6 pipe               \
> > >   action vlan pop_eth pipe                         \
> > >   action vlan push_eth                             \
> > >     dst_mac 00:00:5e:00:53:7e                      \
> > >     src_mac 00:00:5e:00:53:03 pipe                 \
> > >   action mirred egress redirect dev eth1
> > > 
> > > This filter has 149 arguments, so it can't be used with tc -batch
> > > which is limited to a 100.
> > > 
> > > Let's bump the limit to the next power of 2. That should leave a lot of
> > > room for big batch commands.
> > > 
> > > Signed-off-by: Guillaume Nault <gnault@redhat.com>  
> > 
> > Good idea, but we should probably go further up to 512.
> > Also, rather than keeping magic constant. Why not add value to
> > utils.h.  
> 
> Yes, right.
> 
> > I considered using sysconf(_SC_ARG_MAX) gut that is huge on modern
> > machines (2M). And we don't need to allocate for all possible args.  
> 
> Yes, 2M is probably overkill (and too much to allocate on the stack).
> 
> > diff --git a/include/utils.h b/include/utils.h
> > index 187444d52b41..6c4c403fe6c2 100644
> > --- a/include/utils.h
> > +++ b/include/utils.h
> > @@ -50,6 +50,9 @@ void incomplete_command(void) __attribute__((noreturn));
> >  #define NEXT_ARG_FWD() do { argv++; argc--; } while(0)
> >  #define PREV_ARG() do { argv--; argc++; } while(0)
> >  
> > +/* upper limit for batch mode */
> > +#define MAX_ARGS 512
> > +
> >  #define TIME_UNITS_PER_SEC     1000000
> >  #define NSEC_PER_USEC 1000
> >  #define NSEC_PER_MSEC 1000000
> > diff --git a/lib/utils.c b/lib/utils.c
> > index 93ae0c55063a..0559923beced 100644
> > --- a/lib/utils.c
> > +++ b/lib/utils.c
> > @@ -1714,10 +1714,10 @@ int do_batch(const char *name, bool force,
> >  
> >         cmdlineno = 0;
> >         while (getcmdline(&line, &len, stdin) != -1) {
> > -               char *largv[100];
> > +               char *largv[MAX_ARGS];
> >                 int largc;
> >  
> > -               largc = makeargs(line, largv, 100);
> > +               largc = makeargs(line, largv, MAX_ARGS);
> >                 if (!largc)
> >                         continue;       /* blank line */
> >  
> >   
> 
> Is this a patch you're going to apply, or should I repost it formally?
> 

Either way, you get credit
