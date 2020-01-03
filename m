Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360E012F4DC
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 08:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgACHLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 02:11:53 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39772 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgACHLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 02:11:52 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so41470241wrt.6
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 23:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qDWtwUVrKd0wTpBxfHT8UEBmPYWKVE1f1rQ5fs4ZTtw=;
        b=bBvQRPyFfctPoXZcWcVbig6ev8x/k5qw7PfESw1dOuUGneaf/m/wplbRjZBq26ML23
         CqKyjhYlFJ9DpsDiiCE6ks9u0vLEw20FIW3t7J2dpRcderBDksNEPgHazRnaZZLj/H69
         qGmwLyyWefjcoml7OyFY0fnDiSbRbO1ujEwy/STi19O2G5iZOEWaJ31VOjNUYIua1Rnu
         sZxMGPnDsUWidHKsbPsIUnIiPicaXJfu9dBmgIPgSJNBYVAM+UA7jMoSidIN9EdP6eAm
         b0g+LDKIFquUBgNCoyl+GB+V7e2VpfJxdODABEOi8pF4kJjvtNMN/GvTlYlLVrbkMVnb
         qlcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDWtwUVrKd0wTpBxfHT8UEBmPYWKVE1f1rQ5fs4ZTtw=;
        b=h3RQ4wNEoGPG9YJNr8R9w5VHcEglEGfAwmcQ7JuTF1gEgNGvgKn5k8Ls62EIICOUmV
         FPqvwWR5rzA7DdTrfovapKZV4s+yXSVHkY3jIheZs1J88t7XrJfy8VuzexobNgsa+YUP
         74PmFCzFdatyQdHKW9X3kLWZpRsnoc3SPOItFN189S6ZikNUMN3m0MIvDlIzfBujLkmC
         DUK+EGiAbFjB8klXxJMPke++jrWXjQUEMrYgCylQ2YgpyPWZoF4L/fSsrg0Jz1rPfnKW
         RktgWpBCa4Rp2HeI+8pibAd/NQT99qSLfDXMn9p54Ra4syHNAgRRFaZd/mTU7MzJ6nxD
         W71Q==
X-Gm-Message-State: APjAAAVET73EuPry6YiWcxKO1q6BwM0EXeL90xwSujncG2AYsmK+lUzh
        5+Bt6S3BRXSS9t6RrwQMyxA=
X-Google-Smtp-Source: APXvYqw60zfp8+66h94/Led1fzf3v5Yo5tzqVi3EGN2Y0IbwW89bsxHDgaBNtIsMNFxXPB+uiMlKHg==
X-Received: by 2002:adf:eb48:: with SMTP id u8mr83216618wrn.283.1578035509820;
        Thu, 02 Jan 2020 23:11:49 -0800 (PST)
Received: from AHABDELS-M-J3JG ([85.119.46.8])
        by smtp.gmail.com with ESMTPSA id x26sm10870641wmc.30.2020.01.02.23.11.48
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 02 Jan 2020 23:11:49 -0800 (PST)
Date:   Fri, 3 Jan 2020 08:11:47 +0100
From:   kernel Dev <ahabdels.dev@gmail.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
Message-Id: <20200103081147.8c27b18aec79bb1cd8ad1a1f@gmail.com>
In-Reply-To: <CALx6S37uWDOgWqx_8B0YunQZRGCyjeBY_TLczxmKZySDK4CteA@mail.gmail.com>
References: <1577400698-4836-1-git-send-email-tom@herbertland.com>
        <20200102.134138.1618913847173804689.davem@davemloft.net>
        <CALx6S37uWDOgWqx_8B0YunQZRGCyjeBY_TLczxmKZySDK4CteA@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom, 
Happy new year!!

I believe that these patches cost you great effort. However, we would like to see the 6-10 subsequent patch set to be really able to understand where are you going with these ones.

At some point you mentioned that router vendors make protocol in miserable way. Do you believe the right way is that every individual defines the protocol the way he wants in a single authored IETF draft ? 

Regarding 10) Support IPv4 extension headers.
I see that your drafts describing the idea are expired [1][2]. 
Do you plan to add to the kernel the implementation of expired contents ? or did you abandoned these drafts and described the idea somewhere else that I’m not aware of ?   

[1] https://tools.ietf.org/html/draft-herbert-ipv4-udpencap-eh-01
[2] https://tools.ietf.org/html/draft-herbert-ipv4-eh-01

Ahmed 


On Thu, 2 Jan 2020 16:42:24 -0800
Tom Herbert <tom@herbertland.com> wrote:

> On Thu, Jan 2, 2020 at 1:41 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Tom Herbert <tom@herbertland.com>
> > Date: Thu, 26 Dec 2019 14:51:29 -0800
> >
> > > The fundamental rationale here is to make various TLVs, in particular
> > > Hop-by-Hop and Destination options, usable, robust, scalable, and
> > > extensible to support emerging functionality.
> >
> > So, patch #1 is fine and it seems to structure the code to more easily
> > enable support for:
> >
> > https://tools.ietf.org/html/draft-ietf-6man-icmp-limits-07
> >
> > (I'll note in passing how frustrating it is that, based upon your
> > handling of things in that past, I know that I have to go out and
> > explicitly look for draft RFCs containing your name in order to figure
> > out what your overall long term agenda actually is.  You should be
> > stating these kinds of things in your commit messages)
> >
> > But as for the rest of the patch series, what are these "emerging
> > functionalities" you are talking about?
> >
> > I've heard some noises about people wanting to do some kind of "kerberos
> > for packets".  Or even just plain putting app + user ID information into
> > options.
> >
> > Is that where this is going?  I have no idea, because you won't say.
> >
> Yes, there is some of that. Here are some of the use cases for HBH options:
> 
> PMTU option: draft-ietf-6man-mtu-option-01. There is a P4
> implementation as well as Linux PoC for this that was demonstated
> @IETF103 hackathon.
> IOAM option: https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options-00.
> There is also P4 implementation and Linux router support demonstrated
> at IETF104 hackathon. INT is a related technology that would also use
> this.
> FAST option: https://datatracker.ietf.org/doc/draft-herbert-fast/. I
> have PoC for this. There are some other protocol proposals in the is
> are (I know Huawei has something to describe the QoS that should be
> applied).
> 
> There are others including the whole space especially as a real
> solution for host to networking signaling gets fleshed out. There's
> also the whole world of segment routing options and where that's
> going.
> 
> > And honestly, this stuff sounds so easy to misuse by governments and
> > other entities.  It could also be used to allow ISPs to limit users
> > in very undesirable and unfair ways.   And honestly, surveilance and
> > limiting are the most likely uses for such a facility.  I can't see
> > it legitimately being promoted as a "security" feature, really.
> >
> Yes, but the problem isn't unique to IPv6 options nor would abuse be
> prevented by not implementing them in Linux. Router vendors will
> happily provide the necessary support to allow abuse :-) AH is the
> prescribed way to prevent this sort of abuse (aside from encrypting
> everything that isn't necessary to route packets, but that's another
> story). AH is fully supported by Linux, good luck finding a router
> vendor that cares about it :-)
> 
> > I think the whole TX socket option can wait.
> >
> > And because of that the whole consolidation and cleanup of the option
> > handling code is untenable, because without a use case all it does is
> > make -stable backports insanely painful.
> 
> The problem with "wait and see" approach is that Linux is not the only
> game in town. There are other players that are pursuing this area
> (Cisco and Huawei in particular). They are able to implement protocols
> more to appease their short term marketing requirements with little
> regard for what is best for the community. This is why Linux is so
> critical to networking, it is the only open forum where real scrutiny
> is applied to how protocols are implemented. If the alternatives are
> given free to lead then it's very likely we'll end up being stuck with
> what they do and probably have to follow their lead regardless of how
> miserable they make the protocols. We've already seen this in segment
> routing, their attempts to kill IP fragmentation, and all the other
> examples of protocol ossification that unnecessarily restrict what
> hosts are allowed to send in the network and hence reduce the utility
> and security we are able to offer the user.
> 
> The other data point I will offer is that the current Linux
> implementation of IPv6 destination and hop-by-hop options in the
> kernel is next to useless. Nobody is using the ones that have been
> implemented, and adding support for a new is a major pain-- the
> ability for modules to register support for an option seems like an
> obvious feature to me. Similarly, the restriction that only admin can
> set options is overly restrictive-- allowing to non-privileged users
> to send options under tightly controlled constraints set by the admin
> also seems reasonable to me.
> 
> Tom


-- 
kernel Dev <ahabdels.dev@gmail.com>
