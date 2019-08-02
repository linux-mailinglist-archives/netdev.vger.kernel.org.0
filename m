Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D228C7FDCA
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbfHBPtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:49:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41552 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbfHBPtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:49:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id x15so25920664pgg.8
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 08:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=weMUz3+iyGaXQk6zA3UTHGzmCOXCf5+uJ/B+/85+6Nk=;
        b=kgoJzz3Euq6S8U4iM184RNCS0akIsV4NcUc1h4UD3l+8/he165fRNf4Wkw8VDZIeLW
         ZvaOiuB5qYvSaiAUEpo5uiCRe/SmBkzfhPqLmMKDSfBo44wgi5bIbqIAZiUh0doEtr4V
         GvjPycLccCOAQvt+lfaDetTG2BAdq0Chyq56jFe6+iK7FBSvyFv7J1/XzLTYsj12yEHO
         gpFIbLgfHPMedvfhfmjWGpITlgZTW3Fr/WE+aX6bdj2b8unKxQ79poOeOxSQ47jy8AOm
         yX2rtXLarveiRQz8BKiyFl/ODqjepc4pdvMiiN4juY+xNRCbaKTGtzVHv6e+wzlq8Csg
         veDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=weMUz3+iyGaXQk6zA3UTHGzmCOXCf5+uJ/B+/85+6Nk=;
        b=TSQ3PTTNj8m44c3mmDMClT5gUgelbwdGxkaUSjhCIC2EZm8KYquylliX1YMJQOfoBS
         rIKYrX19bHLcdvjxnFysbJoDXRkpByyA6DSVM9CCIlGwz4LmI7XanLMjTllS9VkZzfG6
         nTQNraPihHloitzdWEKJQqHsQSyQrNQAC7I18yQXP/OivZIF6ToNMZukfJIlJfqc8ERg
         Tyfmbk0JUaiKxCsee+hi3n+vi22LVsQvMlrswUdgYrQvV4XCC7N9K1Vb4b29OkYyJ3qt
         g7uYTbdjaagM89an5eOP3Hi9SUIlLaHJbseJNA3IxTqhpKraNVvN0yxu1N1Qgpwop9ku
         iF+Q==
X-Gm-Message-State: APjAAAWt1rMszQ2qAhI846gyOF4TPbajD5EoiEZi3kI5v5Y7p416FSgr
        dIz43u6nRLZ5Og/sk4LdOiIBdg==
X-Google-Smtp-Source: APXvYqxxkW7qpR0nb8X6LzFrJnxRtGpSYCXu9udoeLDwDv2k+TMlnU+FB/B/5lnrpLyGgMIcojWNkg==
X-Received: by 2002:a17:90a:7d09:: with SMTP id g9mr4886990pjl.38.1564760980405;
        Fri, 02 Aug 2019 08:49:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o11sm133764132pfh.114.2019.08.02.08.49.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 08:49:40 -0700 (PDT)
Date:   Fri, 2 Aug 2019 08:49:33 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next] ip tunnel: add json output
Message-ID: <20190802084933.10992569@hermes.lan>
In-Reply-To: <CAPpH65wSxeXGQc+r+7W_LRZR=vjnL2bXfub1U10vt-Gni67+kQ@mail.gmail.com>
References: <7090709d3ddace589952a128fb62f6603e2da9e8.1564653511.git.aclaudi@redhat.com>
        <20190801081620.6b25d23c@hermes.lan>
        <CAPpH65wSxeXGQc+r+7W_LRZR=vjnL2bXfub1U10vt-Gni67+kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Aug 2019 13:14:15 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Thu, Aug 1, 2019 at 5:16 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Thu,  1 Aug 2019 12:12:58 +0200
> > Andrea Claudi <aclaudi@redhat.com> wrote:
> >  
> > > Add json support on iptunnel and ip6tunnel.
> > > The plain text output format should remain the same.
> > >
> > > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > > ---
> > >  ip/ip6tunnel.c | 82 +++++++++++++++++++++++++++++++--------------
> > >  ip/iptunnel.c  | 90 +++++++++++++++++++++++++++++++++-----------------
> > >  ip/tunnel.c    | 42 +++++++++++++++++------
> > >  3 files changed, 148 insertions(+), 66 deletions(-)
> > >
> > > diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
> > > index d7684a673fdc4..f2b9710c1320f 100644
> > > --- a/ip/ip6tunnel.c
> > > +++ b/ip/ip6tunnel.c
> > > @@ -71,57 +71,90 @@ static void usage(void)
> > >  static void print_tunnel(const void *t)
> > >  {
> > >       const struct ip6_tnl_parm2 *p = t;
> > > -     char s1[1024];
> > > -     char s2[1024];
> > > +     SPRINT_BUF(b1);
> > >
> > >       /* Do not use format_host() for local addr,
> > >        * symbolic name will not be useful.
> > >        */
> > > -     printf("%s: %s/ipv6 remote %s local %s",
> > > -            p->name,
> > > -            tnl_strproto(p->proto),
> > > -            format_host_r(AF_INET6, 16, &p->raddr, s1, sizeof(s1)),
> > > -            rt_addr_n2a_r(AF_INET6, 16, &p->laddr, s2, sizeof(s2)));
> > > +     open_json_object(NULL);
> > > +     print_string(PRINT_ANY, "ifname", "%s: ", p->name);  
> >
> > Print this using color for interface name?  
> 
> Thanks for the suggestion, I can do the same also for remote and local
> addresses?
> 
> >
> >  
> > > +     snprintf(b1, sizeof(b1), "%s/ipv6", tnl_strproto(p->proto));
> > > +     print_string(PRINT_ANY, "mode", "%s ", b1);
> > > +     print_string(PRINT_ANY,
> > > +                  "remote",
> > > +                  "remote %s ",
> > > +                  format_host_r(AF_INET6, 16, &p->raddr, b1, sizeof(b1)));
> > > +     print_string(PRINT_ANY,
> > > +                  "local",
> > > +                  "local %s",
> > > +                  rt_addr_n2a_r(AF_INET6, 16, &p->laddr, b1, sizeof(b1)));
> > > +
> > >       if (p->link) {
> > >               const char *n = ll_index_to_name(p->link);
> > >
> > >               if (n)
> > > -                     printf(" dev %s", n);
> > > +                     print_string(PRINT_ANY, "link", " dev %s", n);
> > >       }
> > >
> > >       if (p->flags & IP6_TNL_F_IGN_ENCAP_LIMIT)
> > > -             printf(" encaplimit none");
> > > +             print_bool(PRINT_ANY,
> > > +                        "ip6_tnl_f_ign_encap_limit",
> > > +                        " encaplimit none",
> > > +                        true);  
> >
> > For flags like this, print_null is more typical JSON than a boolean
> > value. Null is better for presence flag. Bool is better if both true and
> > false are printed.  
> 
> Using print_null json JSON output becomes:
> 
>   {
>     "ifname": "gre2",
>     "mode": "gre/ipv6",
>     "remote": "fd::1",
>     "local": "::",
>     "ip6_tnl_f_ign_encap_limit": null,
>     "hoplimit": 64,
>     "tclass": "0x00",
>     "flowlabel": "0x00000",
>     "flowinfo": "0x00000000",
>     "flags": []
>   }
> 
> Which seems a bit confusing to me (what does the "null" value means?).
> Using print_null we also introduce an inconsistency with the JSON
> output of ip/link_gre6.c and ip/link_ip6tnl.c.
> I would prefer to use print_bool and print out
> ip6_tnl_f_ign_encap_limit both when true and false, patching both
> files above to do the same. WDYT?

JSON has several ways to represent the same type of flag value.
Since JSON always has key/value. Null is used to indicate something is present and
in that case the value is unnecessary, which is what the null field was meant for.


