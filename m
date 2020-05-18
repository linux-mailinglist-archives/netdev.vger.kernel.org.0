Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84E21D7D5F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgERPvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:51:52 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34445 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727005AbgERPvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:51:51 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 5654D846;
        Mon, 18 May 2020 11:51:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Mon, 18 May 2020 11:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=benboeckel.net;
         h=date:from:to:cc:subject:message-id:reply-to:references
        :mime-version:content-type:in-reply-to; s=fm1; bh=/k6Uxefv5KR5De
        o3sESOUjXzq3bRzNHWL0Vw3jNx8TM=; b=NuHvEljJ+d74MxbNbt0IcdDN9xc84T
        EHDdvqt6RshgLbRFK11KxarFQSg70p+Yxu84qM7lnNczEPSpda/54k4frRshT1R+
        mnvd5x6t3qobpjBelcWkpRa220yT/HRfma6Uo7cne5YZd9kg2UskjsSamJs1sH8/
        JA8PHE6IGQsj7w5iehy6XA6qqldh2z8dIDZ8tMH6dCoTen95zf4fyT3AoBX/H2TP
        fCEdNzyqF8ix2q6KA+CadEgziyKc7NsWnwou7E8pez7bukRDTTksrMlIu43yMg50
        xPfJuXBPHqLh1kUt3LS0y7vRAi5+geDedxdo18mrnN3LYqPx+no2BH3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/k6Uxefv5KR5Deo3sESOUjXzq3bRzNHWL0Vw3jNx8TM=; b=2Dsh/SQK
        jh0rMCyIN1dsj3q/pvM29qDgAKEEn8qBwoQ96CGb8MnYpgoslHQ2lqii4qza6FOO
        fQ4zj69L+Huv3c0qwZSv16LSAKj70prQQVwTH4TmAbaPDalmNBXEKRebbpubvS5y
        s1HNJ7FuOsaSS9hmClcDd7exNhAR1r+2e6pYalGRVDSqLkYQb+zqsT6JLPjA4HK1
        7voixJCaR5FeomBF3To98M0vSKj4GFyl4xhBX6GtzU6JcjslkY4KGUXI/JkL+QGL
        FuaE5Uz9vF/urYEUQfXhcJO52sQ5zE9dQawtHWClo9AA9nyBQlBfdyoGgVjzwvxI
        3lGaBlAV/65V8g==
X-ME-Sender: <xms:Fa_CXqMd_B97yruaVQXL4CFEm8jLzuxkrixrkxh8qou0A-fq4XGR9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhrfhggtggujggfsehttdertddtreejnecuhfhrohhmpeeuvghn
    uceuohgvtghkvghluceomhgvsegsvghnsghovggtkhgvlhdrnhgvtheqnecuggftrfgrth
    htvghrnhepjedtvdffheetgfektdehvefgieelgeefheejvdehtdduieetgedtfedtleev
    vdffnecukfhppeeiledrvddtgedrudeikedrvdeffeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmvgessggvnhgsohgvtghkvghlrdhnvght
X-ME-Proxy: <xmx:Fa_CXo8sMxWTUWmv33PUjhTxoMuKU7rvHqc7EWQ3INq8FFxQT8gMCA>
    <xmx:Fa_CXhTLBg6uuY7B0m3xh1NPwmYx5ciDsH2XpqWXAyxcwKgI56REtg>
    <xmx:Fa_CXqvbq-ZBzOBW1yy4gEEI5foZBb09cHJZ5ra5EvuEcWddAG6ugQ>
    <xmx:Fa_CXvFsXzihHcpc90fzRH_BtU5FWd7GCiMfwYd9AqDrbQI68lNZ0A>
Received: from localhost (cpe-69-204-168-233.nycap.res.rr.com [69.204.168.233])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77A3730663FD;
        Mon, 18 May 2020 11:51:49 -0400 (EDT)
Date:   Mon, 18 May 2020 11:51:48 -0400
From:   Ben Boeckel <me@benboeckel.net>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        keyrings@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweimer@redhat.com
Subject: Re: [PATCH] dns: Apply a default TTL to records obtained from
 getaddrinfo()
Message-ID: <20200518155148.GA2595638@erythro.dev.benboeckel.internal>
Reply-To: me@benboeckel.net
References: <158981176590.872823.11683683537698750702.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <158981176590.872823.11683683537698750702.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.13.3 (2020-01-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 15:22:45 +0100, David Howells wrote:
> Address records obtained from getaddrinfo() don't come with any TTL
> information, even if they're obtained from the DNS, with the result that
> key.dns_resolver upcall program doesn't set an expiry time on dns_resolver
> records unless they include a component obtained directly from the DNS,
> such as an SRV or AFSDB record.
> 
> Fix this to apply a default TTL of 10mins in the event that we haven't got
> one.  This can be configured in /etc/keyutils/key.dns_resolver.conf by
> adding the line:
> 
> 	default_ttl: <number-of-seconds>
> 
> to the file.

Is there precedent for this config file format? It looks like possible
YAML, but this patch doesn't mention that anywhere. Is there a good
reason to not be using an existing format (ini, toml, json, shell-alike,
anything)? I have no preference for anything other than a format that
already exists out there. Maybe one that supports comments too so that
these settings can have context associated with them in real
deployments (which effectively rules out json)?

> +	while (fgets(buf, sizeof(buf) - 1, f)) {
> +		line++;
> +		if (buf[0] == '#')
> +			continue;

So it does support comments...

> +		p = strchr(buf, '\n');
> +		if (!p)
> +			error("%s:%u: line missing newline or too long", config_file, line);
> +		while (p > buf && isspace(p[-1]))
> +			p--;
> +		*p = 0;
> +
> +		if (strncmp(buf, "default_ttl:", 12) == 0) {
> +			p = buf + 12;
> +			while (isspace(*p))
> +				p++;

...but not if it starts with whitespace. So if one does indent the
`default_ttl` setting for whatever reason, the comment is stuck at the
first column.

> +			if (sscanf(p, "%u%n", &u, &n) != 1)
> +				error("%s:%u: default_ttl: Bad value",
> +				      config_file, line);
> +			if (p[n])
> +				error("%s:%u: default_ttl: Extra data supplied",
> +				      config_file, line);

But no trailing whitespace is allowed?

> +			if (u < 1 || u > INT_MAX)
> +				error("%s:%u: default_ttl: Out of range",
> +				      config_file, line);

The valid range should be mentioned in the docs (basically that 0 is not
allowed and has no special meaning (it could mean leaving off the TTL as
previously done)).

> +			key_expiry = u;
> +		} else {
> +			error("%s:%u: Unknown option", config_file, line);

Forwards compatibility is hard with such behavior. Is there any reason
this can't be a warning?

> @@ -24,6 +26,21 @@ It can be called in debugging mode to test its functionality by passing a
>  \fB\-D\fR flag on the command line.  For this to work, the key description and
>  the callout information must be supplied.  Verbosity can be increased by
>  supplying one or more \fB\-v\fR flags.
> +.P
> +A configuration file can be supplied to adjust various parameters.  The file
> +is looked for at:
> +.IP
> +/etc/keyutils/key.dns_resolver.conf
> +.P
> +unless otherwise specified with the \fB\-c\fR flag.
> +.P
> +Configuration options include:
> +.TP
> +.B default_ttl: <number>
> +The number of seconds to set as the expiration on a cached record.  This will
> +be overridden if the program manages to retrieve TTL information along with
> +the addresses (if, for example, it accesses the DNS directly).  The default is
> +600 seconds.

There's no mention of the leading whitespace support or comments here.
Does the file deserve its own manpage?

--Ben
