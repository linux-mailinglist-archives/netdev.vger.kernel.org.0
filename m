Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2090DDEB27
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 13:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfJULln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 07:41:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48137 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727725AbfJULlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 07:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571658101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koi7Z8V8erTKmxD3oP4dYoVUrso6+BxU/qyyj8o5aAY=;
        b=E1tQYMWRnIXD2VC1l10c9hxaPvQpn5S5GGsRJ4QlPIBRNMz9Plir+iEp1keFDV/bYUHlSc
        BXPchaKXkVwKFeKVwnmm+C/cTPbzn2nv+L8jzJ8Pu93y878f9bX46rfUkNsHXXPuR5Myu6
        KSF8X9Ifz0Fgc8jAUEKnsvDnT331XjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-O4qoCLuwM1G_s3lnPtjanQ-1; Mon, 21 Oct 2019 07:41:37 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDD021005500;
        Mon, 21 Oct 2019 11:41:34 +0000 (UTC)
Received: from localhost (ovpn-112-54.ams2.redhat.com [10.36.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B87A0166A2;
        Mon, 21 Oct 2019 11:41:29 +0000 (UTC)
Date:   Mon, 21 Oct 2019 13:41:24 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Taehee Yoo <ap420073@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ying Xue <ying.xue@windriver.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Subject: Re: [PATCH net] net: openvswitch: free vport unless
 register_netdevice() succeeds
Message-ID: <20191021134124.35b7927d@redhat.com>
In-Reply-To: <20191021110801.16764-1-hdanton@sina.com>
References: <20191021110801.16764-1-hdanton@sina.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: O4qoCLuwM1G_s3lnPtjanQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 19:08:01 +0800
Hillf Danton <hdanton@sina.com> wrote:

> Hey Stefano=20
>=20
> On Mon, 21 Oct 2019 18:02:48 +0800 Stefano Brivio wrote:
> >=20
> > ---
> > This patch was sent to dev@openvswitch.org and appeared on netdev
> > only as Pravin replied to it, giving his Acked-by. I contacted the =20
>=20
> Correct. I am unable to find the patches I sent to lkml on
> https://lore.kernel.org/lkml/.
>=20
> > original author one month ago requesting to resend this to netdev,
> > but didn't get an answer, so I'm now resending the original patch.
> >  =20
> Nor patches to <xyz@vger.kernel.org>.
> Say sorry to you for missing in action.
> I sent a mail to <postmaster@vger.kernel.org> sometime ago asking for
> how to cure the pain, without a message echoed since.
> That is my poor defend.

Ouch, and also this reply didn't reach netdev. Looking at headers:

Received: from r3-20.sinamail.sina.com.cn (r3-20.sinamail.sina.com.cn [202.=
108.3.20])
=09by mx1.redhat.com (Postfix) with SMTP id 9868983F45
=09for <sbrivio@redhat.com>; Mon, 21 Oct 2019 11:08:14 +0000 (UTC)
Received: from unknown (HELO localhost.localdomain)([222.131.66.83])
=09by sina.com with ESMTP
=09id 5DAD919A000082B3; Mon, 21 Oct 2019 19:08:12 +0800 (CST)

it's not in DNSRBL or anything, and looks similar enough to e.g.:

=09https://patchwork.kernel.org/patch/10663003/

that was received without issues by majordomo@vger.kernel.org. The only
relevant difference seems to be the missing HELO from
r3-20.sinamail.sina.com.cn, I have no idea why that would be omitted.

Headers added by MTA delivering this to me:

X-Greylist: Sender passed SPF test, ACL 264 matched, not delayed by milter-=
greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 21 Oct 2019 11:08:19 +=
0000 (UTC)
X-Greylist: inspected by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.2=
7]); Mon, 21 Oct 2019 11:08:19 +0000 (UTC) for IP:'202.108.3.20' DOMAIN:'r3=
-20.sinamail.sina.com.cn' HELO:'r3-20.sinamail.sina.com.cn' FROM:'hdanton@s=
ina.com' RCPT:''
X-RedHat-Spam-Score: 0.001  (FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS) 202.108.=
3.20 r3-20.sinamail.sina.com.cn 202.108.3.20 r3-20.sinamail.sina.com.cn <hd=
anton@sina.com>

it even passes SPF. But maybe the missing HELO is a problem for SPF on
vger.kernel.org?

Checked against http://vger.kernel.org/majordomo-taboos.txt, also no
matches.

Sorry, I don't have any suggestions other than contacting
postmaster@vger.kernel.org again -- perhaps from a different address.

> >  net/openvswitch/vport-internal_dev.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-) =20
>=20
> And feel free to pick up the diff if they make sense, as you see,
> they were sent usually without the Signed-off-by tag.

I think this submission should be fine, I added you as From: and kept
your original Signed-off-by -- thanks for fixing this by the way!

--=20
Stefano

