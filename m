Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B641C5E66
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbgEERJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729248AbgEERJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:09:16 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E69DC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 10:09:15 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id p12so2567803qvm.21
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 10:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RpzQzYgI2u6oOp5fx3UYE0fD9aQpv7j3X9pieNSKWFI=;
        b=Svcmwtd9wRUMiAlUmc5gRNjGl4ymJ1yV2eXzXmu62loS9/6cWcblB3RMQ54Jj+4wvZ
         iA3PO4A6FF1MpAk1iVM64jSDu6iEP9tfBqMS8EhwuyjkK25xQnsrUGFq14T/M+0INivI
         nbEoxVu4+DjaBvO++0s02SafcsbZfTQsA7gjDqN6PpaZWwWw9XQrmzWJIADAAKyIRHCn
         R0jwdbnI+hP41hcOIxVEoAudTpyhQAzKqZgVaR9FlHXW5boyvObl2rfsN3Scu8o5Ksri
         vs1zRaGRdyfmiQtFPOSpze2NPoHiQWMPPNgeT6c2oJvVcB1TFK6IcBwuLJTOGHUZbdvx
         rFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RpzQzYgI2u6oOp5fx3UYE0fD9aQpv7j3X9pieNSKWFI=;
        b=t9SYCMqN6aKaDQoptmewIlLR7wjmWnkTEomemgiwLTskMarkcbjIYqHk7Jjr9cJRon
         z4Ay50Rgkdlr32TePBJZoCwciElLIk/Jz7e8MESzs0d6pwFRoVVbI0ZmtILk1g4JWbTH
         YscV0EgUPLitPPqDRMQOc7xeiCmIr0MMT4uKAeAu4OZbUegnpx/kUAddsrZSjD7NlN5+
         zODQndkXvUt5Xz7FxpfLf0a/IbspaKdj0m9U4X+qhEuP/OUyTmyMwE5Tm1sS1S8zdPwj
         jTFSApG0tktmzLdPZYbYahE7PJc6J3u63QXh10Gqc//VaTgsWdlWVw3zhi8tguhs4Vk+
         P33g==
X-Gm-Message-State: AGi0Pubkp/G1QutSxo5t9xNma7C8vPBOj2hu4ryKy+0YSqzJqYxmviy1
        CsAkiLMM1HtRZOXJYeKPkg3+JLY=
X-Google-Smtp-Source: APiQypLBGY2wjAeuMji6hqatbH/6vNqL12Z16p2EW+6NUtH9yaeEjN0j95/RCh7ig6TcYm0GIwiauP0=
X-Received: by 2002:a0c:f910:: with SMTP id v16mr3710849qvn.37.1588698554239;
 Tue, 05 May 2020 10:09:14 -0700 (PDT)
Date:   Tue, 5 May 2020 10:09:12 -0700
In-Reply-To: <20200505160205.GC241848@google.com>
Message-Id: <20200505170912.GE241848@google.com>
Mime-Version: 1.0
References: <20200504173430.6629-1-sdf@google.com> <20200504173430.6629-5-sdf@google.com>
 <20200504232247.GA20087@rdna-mbp> <20200505160205.GC241848@google.com>
Subject: Re: [PATCH bpf-next 4/4] bpf: allow any port in bpf_bind helper
From:   sdf@google.com
To:     Andrey Ignatov <rdna@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/05, Stanislav Fomichev wrote:
> On 05/04, Andrey Ignatov wrote:
> > Stanislav Fomichev <sdf@google.com> [Mon, 2020-05-04 10:34 -0700]:
> > > [...]
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index fa9ddab5dd1f..fc5161b9ff6a 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -4527,29 +4527,24 @@ BPF_CALL_3(bpf_bind, struct  
> bpf_sock_addr_kern *, ctx, struct sockaddr *, addr,
> > >  	struct sock *sk = ctx->sk;
> > >  	int err;
> > >
> > > -	/* Binding to port can be expensive so it's prohibited in the  
> helper.
> > > -	 * Only binding to IP is supported.
> > > -	 */
> > >  	err = -EINVAL;
> > >  	if (addr_len < offsetofend(struct sockaddr, sa_family))
> > >  		return err;
> > >  	if (addr->sa_family == AF_INET) {
> > >  		if (addr_len < sizeof(struct sockaddr_in))
> > >  			return err;
> > > -		if (((struct sockaddr_in *)addr)->sin_port != htons(0))
> > > -			return err;
> > >  		return __inet_bind(sk, addr, addr_len,
> > > +				   BIND_FROM_BPF |
> > >  				   BIND_FORCE_ADDRESS_NO_PORT);
> >
> > Should BIND_FORCE_ADDRESS_NO_PORT be passed only if port is zero?
> > Passing non zero port and BIND_FORCE_ADDRESS_NO_PORT at the same time
> > looks confusing (even though it works).
> Makes sense, will remove it here, thx.
Looking at it some more, I think we need to always have that
BIND_FORCE_ADDRESS_NO_PORT. Otherwise, it might regress your
usecase with zero port:

   if (snum || !(inet->bind_address_no_port ||
                (flags & BIND_FORCE_ADDRESS_NO_PORT)))

If snum == 0 we want to have either the flag on or
IP_BIND_ADDRESS_NO_PORT being set on the socket to prevent the port
allocation a bind time.

If snum != 0, BIND_FORCE_ADDRESS_NO_PORT doesn't matter and the port
is passed as an argument. We don't need to search for a free one, just
to confirm it's not used.

Am I missing something?
