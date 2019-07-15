Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070FA69D31
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbfGOU6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:58:49 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35590 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbfGOU6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:58:49 -0400
Received: by mail-oi1-f195.google.com with SMTP id a127so13804733oii.2;
        Mon, 15 Jul 2019 13:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MCzU/WMkxkdv3seXO1CtWBOCZdI8seyWxMpeV6ILxPM=;
        b=n/DcGixstP8vOcoFRzdudc00pT/rHSsxBRZ7R1BoGktUPgSXGdYcy4ajXkV+05oUKz
         GR6hARvV6Nkvuy8ZgD7PZLOMcxRSSPUwdmH+m1vNQL+L0VtNoIDGJoS4omuFDQuIqNfI
         XCmwRx+tGSUpxv+EddyPwFsFh5m3+YV0wbrTXQ59FEX8Yv+wSGtcnfT/0Hsa5ODoinJg
         GmFJN+fiWVwXuWbPe17xa1K1jHFt7eApUpWSVBArd8BN5nHpFTdMz77uGwg9bsS/5qPN
         +Wcb3aH+W0HZUVm04apqIHY/zDAQO6tbGJSBGyngbcEup24Hn7vLMHvH0cMv3Sbfk0pD
         4b/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MCzU/WMkxkdv3seXO1CtWBOCZdI8seyWxMpeV6ILxPM=;
        b=e5ao2v+a8LtxcvfdVXML1idjBbasa5e49uXgc4Eje4XK9O3tejKtDVHLsK0f5Nvzfa
         ISzadcW7BAIKCqbbiQiXpLb3YOVr0XlvyOqrFHulq1uzqeG+BWHom2/saSCiO4r3i6tc
         gEOHaL3bgHDnLvS5BHifcMQ12uVG2aocsCYcoGoj3gLh2tZLrenyNklnrFTyb6K2A8XT
         GSQX2sU2XanojV7dBr5v+/LzGhy7jr6bL0PqyzPc6CONqe1LPv9wd0JMvsff+WaNFlIz
         bmRA+yc1Qp6Ar5CJv+SmVe7bR4ImwF/Tm4xaYaUPuTl/pWaB79cKpk/NZtGIU3Kg/hMu
         U4jQ==
X-Gm-Message-State: APjAAAWvY47F22nVye9/NQ6kELY9yGzjGivOqDxaiJF0w+FdZw4pnGEU
        NT6TbhdaNu4jWq9c8bHfn3Q=
X-Google-Smtp-Source: APXvYqwoBb7Et3ZVKtXcT4k0fukPE8zlAdYcWoulCi+xqrDp6YXdoCwmdPm/tbl44NDcOr4i/OdLnQ==
X-Received: by 2002:aca:4806:: with SMTP id v6mr14714890oia.133.1563224328332;
        Mon, 15 Jul 2019 13:58:48 -0700 (PDT)
Received: from localhost ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id m21sm6837898otn.12.2019.07.15.13.58.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:58:47 -0700 (PDT)
Date:   Mon, 15 Jul 2019 13:58:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d2ce906c0bb2_4e792ad8fc6505b8d5@john-XPS-13-9370.notmuch>
In-Reply-To: <20190711201633.552292e6@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
 <20190709194525.0d4c15a6@cakuba.netronome.com>
 <5d255dececd33_1b7a2aec940d65b45@john-XPS-13-9370.notmuch>
 <20190710123417.2157a459@cakuba.netronome.com>
 <20190710130411.08c54ddd@cakuba.netronome.com>
 <5d276814a76ad_698f2aaeaaf925bc8a@john-XPS-13-9370.notmuch>
 <20190711113218.2f0b8c1f@cakuba.netronome.com>
 <5d27a9627b092_19762abc80ff85b856@john-XPS-13-9370.notmuch>
 <20190711201633.552292e6@cakuba.netronome.com>
Subject: Re: [bpf PATCH v2 2/6] bpf: tls fix transition through disconnect
 with close
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Thu, 11 Jul 2019 14:25:54 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > On Thu, 11 Jul 2019 09:47:16 -0700, John Fastabend wrote:  =

> > > > Jakub Kicinski wrote:  =

> > > > > On Wed, 10 Jul 2019 12:34:17 -0700, Jakub Kicinski wrote:    =

> > > > > > > > > +		if (sk->sk_prot->unhash)
> > > > > > > > > +			sk->sk_prot->unhash(sk);
> > > > > > > > > +	}
> > > > > > > > > +
> > > > > > > > > +	ctx =3D tls_get_ctx(sk);
> > > > > > > > > +	if (ctx->tx_conf =3D=3D TLS_SW || ctx->rx_conf =3D=3D=
 TLS_SW)
> > > > > > > > > +		tls_sk_proto_cleanup(sk, ctx, timeo);    =

> > > > > =

> > > > > Do we still need to hook into unhash? With patch 6 in place per=
haps we
> > > > > can just do disconnect =F0=9F=A5=BA    =

> > > > =

> > > > ?? "can just do a disconnect", not sure I folow. We still need un=
hash
> > > > in cases where we have a TLS socket transition from ESTABLISHED
> > > > to LISTEN state without calling close(). This is independent of i=
f
> > > > sockmap is running or not.
> > > > =

> > > > Originally, I thought this would be extremely rare but I did see =
it
> > > > in real applications on the sockmap side so presumably it is poss=
ible
> > > > here as well.  =

> > > =

> > > Ugh, sorry, I meant shutdown. Instead of replacing the unhash callb=
ack
> > > replace the shutdown callback. We probably shouldn't release the so=
cket
> > > lock either there, but we can sleep, so I'll be able to run the dev=
ice
> > > connection remove callback (which sleep).
> > =

> > ah OK seems doable to me. Do you want to write that on top of this
> > series? Or would you like to push it onto your branch and I can pull
> > it in push the rest of the patches on top and send it out? I think
> > if you can get to it in the next few days then it makes sense to wait=
.
> =

> Mm.. perhaps its easiest if we forget about HW for now and get SW =

> to work? Once you get the SW to 100% I can probably figure out what =

> to do for HW, but I feel like we got too many moving parts ATM.

Hi Jack,

I went ahead and pushed a v3 with your patches at the front. This resolve=
s
a set of issues for me so I think it makes sense to push now and look
to resolve any further issues later. I'll look into the close with pendin=
g
data potential issue to see if it is/is-not a real issue.

Thanks,
John=
