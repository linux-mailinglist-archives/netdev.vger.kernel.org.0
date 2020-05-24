Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9AD1E01C6
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 21:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbgEXTJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 15:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388059AbgEXTJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 15:09:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20352C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 12:09:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f4so7752443pgi.10
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 12:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o+GSMkonRmWEPDkdMmxa5YXNk11jnHvsc3+4Ohue4+E=;
        b=VQuT4BAT3274X5Et/iAaS1UneizOhPLg6eFp0/Sfwdb/klUnqeZS09wRKo+O+s0NJY
         lAPKiFCVLlM6N9IPDD+536a4+E4A4IBnWn1oWybl+TXTQPXDxC5KbXCF3d+HfwtpIIas
         jSFvrw17eV0IlR7t2zJqlh3fi1b9tIsKMj4TZqOGcdkHTShI8LQeEZLhXuWfq3HEqsx0
         gX44zl3CWOb2rwXG+uRyfzJicPyViuGWHX29f3E9H4bEOF5PaRKwBjnrCH6KTla/nnx1
         6BwxOBvv3Uq5jdU1MUyKGQPVjbuuEfiaFLK7g35zL20kqDdxGE2LOyaqtjBGbK/OTJ9K
         DmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o+GSMkonRmWEPDkdMmxa5YXNk11jnHvsc3+4Ohue4+E=;
        b=NXRdwITXnyq3RoH8pPHI6ReaHsnZfYnLcMPWR0ltSoUTG45qAJP3E6h6rjPRDyok89
         Uln/HW3CAuXNlEnDAHTsh4hx0znEuoFiaJFMcRXV5wbLB3ZbdPbVRVsyzlcaOvj14Dua
         +Sj/YpcmfFES8ju5/hAYHXGCZxns1c1AsJMcSGeO532KD/rKNypyEcSUg+Me1nps+ci2
         NDJ/6gpK6b7bj9p051M6wyGfX2Fyo1rvXY6EOlhVnOZ9v8NZQU5DGR3LY7zer2Pqbri4
         iBQGItqU0G3vpXSh4k3XkL7BxmTetuPcppfp5/NxjKrWugOQO2ze/6si4JImmhpyo54i
         N/Fg==
X-Gm-Message-State: AOAM530H5TLJ2jZaZK0UpnKUPFgyFGEKz8S6Uf/jTIg7X/3GOCCmP8ku
        Vth5et6dMGB1KfrseH+wO5r2IcH2vUnatg==
X-Google-Smtp-Source: ABdhPJyqEdn4kOOcWrH+5unN1NZm5gvuO3X0j2VBaCokScU8oAIFrmT6KWVODS0nmOrJaoWoh/5Fpw==
X-Received: by 2002:a62:7cd1:: with SMTP id x200mr14109755pfc.232.1590347357543;
        Sun, 24 May 2020 12:09:17 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 128sm11051325pfd.114.2020.05.24.12.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:09:17 -0700 (PDT)
Date:   Sun, 24 May 2020 12:09:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Ian K. Coolidge" <icoolidge@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] iproute2: ip addr: Accept 'optimistic' flag
Message-ID: <20200524120908.28f30059@hermes.lan>
In-Reply-To: <20200524015144.44017-1-icoolidge@google.com>
References: <20200524015144.44017-1-icoolidge@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 May 2020 18:51:44 -0700
"Ian K. Coolidge" <icoolidge@google.com> wrote:

> This allows addresses added to use IPv6 optimistic DAD.
> ---
>  ip/ipaddress.c           | 7 ++++++-
>  man/man8/ip-address.8.in | 7 ++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 80d27ce2..48cf5e41 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -72,7 +72,7 @@ static void usage(void)
>  		"           [-]tentative | [-]deprecated | [-]dadfailed | temporary |\n"
>  		"           CONFFLAG-LIST ]\n"
>  		"CONFFLAG-LIST := [ CONFFLAG-LIST ] CONFFLAG\n"
> -		"CONFFLAG  := [ home | nodad | mngtmpaddr | noprefixroute | autojoin ]\n"
> +		"CONFFLAG  := [ home | nodad | optimistic | mngtmpaddr | noprefixroute | autojoin ]\n"
>  		"LIFETIME := [ valid_lft LFT ] [ preferred_lft LFT ]\n"
>  		"LFT := forever | SECONDS\n"
>  		"TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n"
> @@ -2335,6 +2335,11 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
>  				ifa_flags |= IFA_F_HOMEADDRESS;
>  			else
>  				fprintf(stderr, "Warning: home option can be set only for IPv6 addresses\n");
> +		} else if (strcmp(*argv, "optimistic") == 0) {
> +			if (req.ifa.ifa_family == AF_INET6)
> +				ifa_flags |= IFA_F_OPTIMISTIC;
> +			else
> +				fprintf(stderr, "Warning: optimistic option can be set only for IPv6 addresses\n");
>  		} else if (strcmp(*argv, "nodad") == 0) {
>  			if (req.ifa.ifa_family == AF_INET6)
>  				ifa_flags |= IFA_F_NODAD;
> diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
> index 2a553190..fe773c91 100644
> --- a/man/man8/ip-address.8.in
> +++ b/man/man8/ip-address.8.in
> @@ -92,7 +92,7 @@ ip-address \- protocol address management
>  
>  .ti -8
>  .IR CONFFLAG " := "
> -.RB "[ " home " | " mngtmpaddr " | " nodad " | " noprefixroute " | " autojoin " ]"
> +.RB "[ " home " | " mngtmpaddr " | " nodad " | " optimstic " | " noprefixroute " | " autojoin " ]"
>  
>  .ti -8
>  .IR LIFETIME " := [ "
> @@ -258,6 +258,11 @@ stateless auto-configuration was active.
>  (IPv6 only) do not perform Duplicate Address Detection (RFC 4862) when
>  adding this address.
>  
> +.TP
> +.B optimistic
> +(IPv6 only) When performing Duplicate Address Detection, use the RFC 4429
> +optimistic variant.
> +
>  .TP
>  .B noprefixroute
>  Do not automatically create a route for the network prefix of the added

Since there already is a table for print() code, could that be used for parse()?
Something like the following UNTESTED

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 80d27ce27d0c..debb83157d60 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1236,7 +1236,7 @@ static unsigned int get_ifa_flags(struct ifaddrmsg *ifa,
 /* Mapping from argument to address flag mask */
 static const struct {
 	const char *name;
-	unsigned long value;
+	unsigned int value;
 } ifa_flag_names[] = {
 	{ "secondary",		IFA_F_SECONDARY },
 	{ "temporary",		IFA_F_SECONDARY },
@@ -1253,13 +1253,46 @@ static const struct {
 	{ "stable-privacy",	IFA_F_STABLE_PRIVACY },
 };
 
+#define IPV6ONLY_FLAGS	\
+		(IFA_F_NODAD | IFA_F_OPTIMISTIC | IFA_F_DADFAILED | \
+		 IFA_F_HOMEADDRESS | IFA_F_TENTATIVE | \
+		 IFA_F_MANAGETEMPADDR | IFA_F_STABLE_PRIVACY)
+
+#define READONLY_FLAGS \
+	( IFA_F_SECONDARY | IFA_F_DADFAILED | IFA_F_DEPRECATED )
+
+static int parse_ifa_flags(int family, const char *arg, unsigned int *flags)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ifa_flag_names); i++) {
+		const char *name = ifa_flag_names[i].name;
+		unsigned int mask = ifa_flag_names[i].value;
+
+		if (strcasecmp(arg, name))
+			continue;
+
+		if (mask & READONLY_FLAGS)
+			fprintf(stderr,
+				"Warning: %s flag can not be set.\n", name);
+		else if ((mask & IPV6ONLY_FLAGS) && family != AF_INET6)
+			fprintf(stderr,
+				"Warning: %s flag can be set only for IPV6 addresses\n",
+				name);
+		else
+			*flags |= mask;
+		return 0;
+	}
+	return -1;
+}
+
 static void print_ifa_flags(FILE *fp, const struct ifaddrmsg *ifa,
 			    unsigned int flags)
 {
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(ifa_flag_names); i++) {
-		unsigned long mask = ifa_flag_names[i].value;
+		unsigned int mask = ifa_flag_names[i].value;
 
 		if (mask == IFA_F_PERMANENT) {
 			if (!(flags & mask))
@@ -2330,26 +2363,7 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 			preferred_lftp = *argv;
 			if (set_lifetime(&preferred_lft, *argv))
 				invarg("preferred_lft value", *argv);
-		} else if (strcmp(*argv, "home") == 0) {
-			if (req.ifa.ifa_family == AF_INET6)
-				ifa_flags |= IFA_F_HOMEADDRESS;
-			else
-				fprintf(stderr, "Warning: home option can be set only for IPv6 addresses\n");
-		} else if (strcmp(*argv, "nodad") == 0) {
-			if (req.ifa.ifa_family == AF_INET6)
-				ifa_flags |= IFA_F_NODAD;
-			else
-				fprintf(stderr, "Warning: nodad option can be set only for IPv6 addresses\n");
-		} else if (strcmp(*argv, "mngtmpaddr") == 0) {
-			if (req.ifa.ifa_family == AF_INET6)
-				ifa_flags |= IFA_F_MANAGETEMPADDR;
-			else
-				fprintf(stderr, "Warning: mngtmpaddr option can be set only for IPv6 addresses\n");
-		} else if (strcmp(*argv, "noprefixroute") == 0) {
-			ifa_flags |= IFA_F_NOPREFIXROUTE;
-		} else if (strcmp(*argv, "autojoin") == 0) {
-			ifa_flags |= IFA_F_MCAUTOJOIN;
-		} else {
+		} else if (parse_ifa_flags(req.ifa.ifa_family, *argv, &ifa_flags) != 0) {
 			if (strcmp(*argv, "local") == 0)
 				NEXT_ARG();
 			if (matches(*argv, "help") == 0)
