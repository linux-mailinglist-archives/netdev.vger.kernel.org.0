Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409EB65DCC
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 18:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfGKQr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 12:47:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46397 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGKQrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 12:47:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id c73so3010241pfb.13;
        Thu, 11 Jul 2019 09:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=1jPCorTngpzEx4XizbpuVEi21Kt+QhYHCdL+iFWLc2Y=;
        b=tNwvuYIG9Bi6k0fiy/Oum5bgDeBzL1OXZqYx8iVo1h7HEiEoE4wimGU5eUNEAtJ/sg
         ehnUInAEsVfsQcWNLndYyqDaxsqvFPblKvrVg63/fgqP5/sN92aO4LebVnIyH6SFmi+s
         MCdOo8PVAyOWLYIcKytj++8dY55XJdKRvVG4HUmqxkJTz6JmXLirq1LbyDv+3E0vQgfb
         x7XAxOfWyaVF0Iq9JkZlQUeCHwwT3E1+FcJwZ+nz90OsaowNz/UDu+UBdWy3lfZX9/kZ
         uTT+Da5tiZBzQB8c517IOzSNGcAYxKn4rvcIn6eesFAjEPhia7Ol5ctUcHzPA7c/tSpg
         AFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=1jPCorTngpzEx4XizbpuVEi21Kt+QhYHCdL+iFWLc2Y=;
        b=oHoI92EDKGq/LlqVOojVImpeM53qEzbM1Bhefi1BR21h0jXLVKBOitamT0bdF+ozJX
         Km2+Sy/OVtkLKuCCKjTaqJkZW3EJI+6QX+Mv2BOU4qeFLDVw7yxHRl9GDnkE88T0Nj+J
         LbAQdnXgInD96l12QrBZ0dF/Ss6z6Jq8YX6aW7n7g+cOsRvEHE65j9miV98v5GJZTTaJ
         YFQrpKHBNugYo8HcGIzaOmngTcHlM7K+WB+uZNRvWvkLgOZuVhWOBNd8bKaI/7YT+dUd
         RSzG8F2aCpu0hn8dDF+PaO/ohL4lBgugXhIiAeLnl8qVs3HrPpa482JFgg7Z3Muk2MsW
         ajEw==
X-Gm-Message-State: APjAAAVRMxTBfHEyiuECpDU5QaEraYoadrGurPu7A+IEu9GPFb5I2pXV
        K5FgZqSMdlE8PE+w4A+nuqQ=
X-Google-Smtp-Source: APXvYqwwvvnchHiaJwP44BvycV1qrXjpF8kHakFnvOJxcUypN9nOxKUrGBGPPmHKu/XsygYoUjfXjQ==
X-Received: by 2002:a17:90a:ff17:: with SMTP id ce23mr5907756pjb.47.1562863645299;
        Thu, 11 Jul 2019 09:47:25 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a5sm5259199pjv.21.2019.07.11.09.47.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 09:47:24 -0700 (PDT)
Date:   Thu, 11 Jul 2019 09:47:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d276814a76ad_698f2aaeaaf925bc8a@john-XPS-13-9370.notmuch>
In-Reply-To: <20190710130411.08c54ddd@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
 <20190709194525.0d4c15a6@cakuba.netronome.com>
 <5d255dececd33_1b7a2aec940d65b45@john-XPS-13-9370.notmuch>
 <20190710123417.2157a459@cakuba.netronome.com>
 <20190710130411.08c54ddd@cakuba.netronome.com>
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
> On Wed, 10 Jul 2019 12:34:17 -0700, Jakub Kicinski wrote:
> > > > > +		if (sk->sk_prot->unhash)
> > > > > +			sk->sk_prot->unhash(sk);
> > > > > +	}
> > > > > +
> > > > > +	ctx =3D tls_get_ctx(sk);
> > > > > +	if (ctx->tx_conf =3D=3D TLS_SW || ctx->rx_conf =3D=3D TLS_SW)=

> > > > > +		tls_sk_proto_cleanup(sk, ctx, timeo);
> =

> Do we still need to hook into unhash? With patch 6 in place perhaps we
> can just do disconnect =F0=9F=A5=BA

?? "can just do a disconnect", not sure I folow. We still need unhash
in cases where we have a TLS socket transition from ESTABLISHED
to LISTEN state without calling close(). This is independent of if
sockmap is running or not.

Originally, I thought this would be extremely rare but I did see it
in real applications on the sockmap side so presumably it is possible
here as well.

> =

> cleanup is going to kick off TX but also:
> =

> 	if (unlikely(sk->sk_write_pending) &&
> 	    !wait_on_pending_writer(sk, &timeo))
> 		tls_handle_open_record(sk, 0);
> =

> Are we guaranteed that sk_write_pending is 0?  Otherwise
> wait_on_pending_writer is hiding yet another release_sock() :(

Not seeing the path to release_sock() at the moment?

   tls_handle_open_record
     push_pending_record
      tls_sw_push_pending_record
        bpf_exec_tx_verdict

If bpf_exec_tx_verdict does a redirect we could hit a relase but that
is another fix I have to get queued up shortly. I think we can fix
that in another series.=
