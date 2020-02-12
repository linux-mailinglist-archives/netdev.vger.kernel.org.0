Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF724159F0D
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 03:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgBLCXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 21:23:14 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:56264 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbgBLCXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 21:23:13 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so184797pjz.5
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 18:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gRiqmQQdwgWrCE7KLUeA6ON0fi/0dS1/ZbEEXhpreRQ=;
        b=WIDkTkIwQG2Uv+x/04Oz/vvRzoNCyFuo4lwHy39JEt2fwAauDllfKWcQ0ePHYvV0h/
         nPALwRapsgAtNmuLliuo973jpN8HQcWvXjaCi/6/t2SUKewE2UUWjOvNwv9CdIif2lbl
         EoKmGjfjLfVijH7TjL9EEgUwi8GxTJyZDZ21iNOneSjGEh98F3A6Ej7HYnuUam0ryBg9
         bsPPBau/6Yil8DUrVIsire+Mfylnea6B/QdxSld/QT8uqeAcJACDLhUhVKaSaXWEdm29
         B9KZu2LrCCASWB/6AG2DujK6UyIwWoMxcKQJPFk97tSglMV+IYZHaCsoNjom8Kj4yLGv
         q2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gRiqmQQdwgWrCE7KLUeA6ON0fi/0dS1/ZbEEXhpreRQ=;
        b=VBQtmenQsgVoOvcKLjx5OKdR6IQ1nAGi25qrVD6DLpIH4efW65qp5kyiDe3ukAuDTy
         eZ/u2pU7ep2JQyzKH3L8bvCNULVBGDxrTxkL2JZnAf9esWfYLLs0jpwFf+R5casZryGQ
         EDAnjVBaYjVi6tMWJwH6EwVvM1c3NleAgSEx+XvzwkOACdpRXXBnREhMxwyqqy8/x7lE
         orIOBXcBzfkM0IZ5DbMkHJV4LSuneAN+D22MOUvC9dwNQ6aiNFgqqodYU/VgPvdRCtqc
         jKnZtrx3f+XP8/tvpufcMYdT4VFn4Bjm0jrcgIBuFfUx2TdC0amdU8Tcoiu6hIesVWFG
         fsPw==
X-Gm-Message-State: APjAAAU0BgghwJYF6qCRk+pHl86HN5c4FTtcllSiq+u8QON8+LSopRZQ
        SE5HITEFFVZ89iwLrfwH6biQraoqysU=
X-Google-Smtp-Source: APXvYqzwGtfBbjJP47bPFEv9ikXJUgePkJrpD6I2SCBmJwkgC9LcYRdDyanG1/RWLyp8pNUYToFIrA==
X-Received: by 2002:a17:902:ba8a:: with SMTP id k10mr6229720pls.333.1581474192819;
        Tue, 11 Feb 2020 18:23:12 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c10sm5416714pgj.49.2020.02.11.18.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 18:23:11 -0800 (PST)
Date:   Wed, 12 Feb 2020 10:23:02 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Petr Machata <pmachata@gmail.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [PATCH net] selftests: forwarding: use proto icmp for
 {gretap,ip6gretap}_mac testing
Message-ID: <20200212022302.GL2159@dhcp-12-139.nay.redhat.com>
References: <20200211073256.32652-1-liuhangbin@gmail.com>
 <87eev1rp8g.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eev1rp8g.fsf@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 06:50:38PM +0100, Petr Machata wrote:
> 
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > For tc ip_proto filter, when we extract the flow via __skb_flow_dissect()
> > without flag FLOW_DISSECTOR_F_STOP_AT_ENCAP, we will continue extract to
> > the inner proto.
> >
> > So for GRE + ICMP messages, we should not track GRE proto, but inner ICMP
> > proto.
> >
> > For test mirror_gre.sh, it may make user confused if we capture ICMP
> > message on $h3(since the flow is GRE message). So I move the capture
> > dev to h3-gt{4,6}, and only capture ICMP message.
> 
> [...]
> 
> > Fixes: ba8d39871a10 ("selftests: forwarding: Add test for mirror to gretap")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> This looks correct. The reason we never saw this internally is that the
> ASIC puts the outer protocol to ACL ip_proto. Thus the flower rule 77
> actually only matched in HW, not in both HW and SW like it should, given
> the missing skip_sw.

Hi Petr,

Thanks for the review and testing. I also got the same issue with
test_ttl in mirror_gre_changes.sh, because the actual ttl it captured
is inner ip header's ttl, not gretap's ttl. But that test is hard to fix
as it is for gretap ttl testing, we need mirror the ttl on lower level
interface(i.e. interface $h3).

What I thought is to fix it on kernel side. First I thought is to add
a new flag FLOW_DIS_STOP_AT_ENCAP for struct flow_dissector_key_control.
But that looks not useful as we do skb_flow_dissect() first, and do
fl_lookup() later.

Now I'm thinking about setting flag STOP_AT_ENCAP directly for tc flower, like

static int fl_classify() {
	[...]
	skb_flow_dissect(skb, &mask->dissector, &skb_key, FLOW_DIS_STOP_AT_ENCAP);
	[...]
}

Because when we check the ip proto on the interface, most time we only care
about the outer ip proto. If we care about the inner ip proto, why don't we
set the tc rule on inner interface?

Hi Tom, what do you think?

Thanks
Hangbin

> 
> Reviewed-by: Petr Machata <pmachata@gmail.com>
> Tested-by: Petr Machata <pmachata@gmail.com>
> 
> Thanks!
> 
> > ---
> >  .../selftests/net/forwarding/mirror_gre.sh    | 25 ++++++++++---------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> >
> > diff --git a/tools/testing/selftests/net/forwarding/mirror_gre.sh b/tools/testing/selftests/net/forwarding/mirror_gre.sh
> > index e6fd7a18c655..0266443601bc 100755
> > --- a/tools/testing/selftests/net/forwarding/mirror_gre.sh
> > +++ b/tools/testing/selftests/net/forwarding/mirror_gre.sh
> > @@ -63,22 +63,23 @@ test_span_gre_mac()
> >  {
> >  	local tundev=$1; shift
> >  	local direction=$1; shift
> > -	local prot=$1; shift
> >  	local what=$1; shift
> >
> > -	local swp3mac=$(mac_get $swp3)
> > -	local h3mac=$(mac_get $h3)
> > +	case "$direction" in
> > +	ingress) local src_mac=$(mac_get $h1); local dst_mac=$(mac_get $h2)
> > +		;;
> > +	egress) local src_mac=$(mac_get $h2); local dst_mac=$(mac_get $h1)
> > +		;;
> > +	esac
> >
> >  	RET=0
> >
> >  	mirror_install $swp1 $direction $tundev "matchall $tcflags"
> > -	tc filter add dev $h3 ingress pref 77 prot $prot \
> > -		flower ip_proto 0x2f src_mac $swp3mac dst_mac $h3mac \
> > -		action pass
> > +	icmp_capture_install h3-${tundev} "src_mac $src_mac dst_mac $dst_mac"
> >
> > -	mirror_test v$h1 192.0.2.1 192.0.2.2 $h3 77 10
> > +	mirror_test v$h1 192.0.2.1 192.0.2.2 h3-${tundev} 100 10
> >
> > -	tc filter del dev $h3 ingress pref 77
> > +	icmp_capture_uninstall h3-${tundev}
> >  	mirror_uninstall $swp1 $direction
> >
> >  	log_test "$direction $what: envelope MAC ($tcflags)"
> > @@ -120,14 +121,14 @@ test_ip6gretap()
> >
> >  test_gretap_mac()
> >  {
> > -	test_span_gre_mac gt4 ingress ip "mirror to gretap"
> > -	test_span_gre_mac gt4 egress ip "mirror to gretap"
> > +	test_span_gre_mac gt4 ingress "mirror to gretap"
> > +	test_span_gre_mac gt4 egress "mirror to gretap"
> >  }
> >
> >  test_ip6gretap_mac()
> >  {
> > -	test_span_gre_mac gt6 ingress ipv6 "mirror to ip6gretap"
> > -	test_span_gre_mac gt6 egress ipv6 "mirror to ip6gretap"
> > +	test_span_gre_mac gt6 ingress "mirror to ip6gretap"
> > +	test_span_gre_mac gt6 egress "mirror to ip6gretap"
> >  }
> >
> >  test_all()
