Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0860C420B1F
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhJDMrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:47:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229836AbhJDMrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 08:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633351546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GQTLvOetyvTHwtz2oA9buLbuLEp4ipv8CjGj+Cs2hpQ=;
        b=D8RoJCbTZ+jTczIQ1v27fmryOc3oLaZhATCpU6CcC1YK+tIdOsoR0eE/fA7hR0I+CAotHI
        5jqtHnKRn6tbr7R0LFAI+YyeK6873xDIfuUT9/nds73crJcjaP+y11xlPKRFYjTQY2MX2Q
        3a6Bum+ZnQSUj1FABsvIWQ1nd1M9ZSg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-KiWVTMzdPF-8BmKmANJlXA-1; Mon, 04 Oct 2021 08:45:45 -0400
X-MC-Unique: KiWVTMzdPF-8BmKmANJlXA-1
Received: by mail-wr1-f72.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso1029044wrc.2
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 05:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GQTLvOetyvTHwtz2oA9buLbuLEp4ipv8CjGj+Cs2hpQ=;
        b=tR2arx3SvGilp3sjv57H+PKLTGhbna2Sx9zsuVE73/vRhY6lvlGM1e5lofDWRQ47LT
         atCAHiAtyEdlrkqZdEG7GcVOI754wJ3wJJei4RdhMA3S151TnIk5wZ/suvrhFkWFhJSy
         N01OEDVnB7eUIKMtbmWrD3FFmmkPt2kkJcis+8GvMj2S06unvW5iahrGlyThZT8VNMLt
         a+/zMhgm2D6f9eQ2YowM3eD33SaPSji8+HpC1lkBiT70e+63EI8oVsRILV4IER+lt54d
         KHQ95HwNq8FkuQVKa2kMoCh4+ycSBe6XAyRCJcUwOot0pDmXdFtv5xaRxDj6x5vaUlue
         vnyg==
X-Gm-Message-State: AOAM532SfqASThjmiR0rNYGoz1k7b4thBMGKpvDKYMZQqQ9ps98EMNeG
        5WJmOAGdbN+Qs6FU0FzKXWKpqR1maWWgMTIN5QkpU4eVdf7fk4zwR0t/xU/BL/WKruMXOd3cXrg
        HAAC9EEhZH+Jeg6Su
X-Received: by 2002:a05:600c:4144:: with SMTP id h4mr10702643wmm.105.1633351544538;
        Mon, 04 Oct 2021 05:45:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRK1kopyanS6Xp5gtMpx/X2G/Vb39IbJVhg8IToATOr+tm8CSxYHJh8HvvXCAahO8cepT3wQ==
X-Received: by 2002:a05:600c:4144:: with SMTP id h4mr10702631wmm.105.1633351544321;
        Mon, 04 Oct 2021 05:45:44 -0700 (PDT)
Received: from localhost ([37.163.4.200])
        by smtp.gmail.com with ESMTPSA id r27sm14160748wrr.70.2021.10.04.05.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 05:45:43 -0700 (PDT)
Date:   Mon, 4 Oct 2021 14:45:39 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Luca Boccassi <bluca@debian.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH 2/2 iproute2] configure: add the --libdir param
Message-ID: <YVr3c4wFRpxd4HCP@renaissance-vector>
References: <cover.1633191885.git.aclaudi@redhat.com>
 <1047327c1350db0fe3df84d7eb96bf45955fa795.1633191885.git.aclaudi@redhat.com>
 <6363502d3ce806acdbc7ba194ddc98d3fac064de.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6363502d3ce806acdbc7ba194ddc98d3fac064de.camel@debian.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 12:52:35PM +0100, Luca Boccassi wrote:
> On Sat, 2021-10-02 at 18:41 +0200, Andrea Claudi wrote:
> > This commit allows users/packagers to choose a lib directory to store
> > iproute2 lib files.
> > 
> > At the moment iproute2 ship lib files in /usr/lib and offers no way to
> > modify this setting. However, according to the FHS, distros may choose
> > "one or more variants of the /lib directory on systems which support
> > more than one binary format" (e.g. /usr/lib64 on Fedora).
> > 
> > As Luca states in commit a3272b93725a ("configure: restore backward
> > compatibility"), packaging systems may assume that 'configure' is from
> > autotools, and try to pass it some parameters.
> > 
> > Allowing the '--libdir=/path/to/libdir' syntax, we can use this to our
> > advantage, and let the lib directory to be chosen by the distro
> > packaging system.
> > 
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > ---
> >  Makefile  |  7 ++++---
> >  configure | 21 +++++++++++++++++++++
> >  2 files changed, 25 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 5bc11477..45655ca4 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,6 +1,8 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  # Top level Makefile for iproute2
> >  
> > 
> > +-include config.mk
> > +
> >  ifeq ("$(origin V)", "command line")
> >  VERBOSE = $(V)
> >  endif
> > @@ -13,7 +15,6 @@ MAKEFLAGS += --no-print-directory
> >  endif
> >  
> > 
> >  PREFIX?=/usr
> > -LIBDIR?=$(PREFIX)/lib
> >  SBINDIR?=/sbin
> >  CONFDIR?=/etc/iproute2
> >  NETNS_RUN_DIR?=/var/run/netns
> > @@ -60,7 +61,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
> >  LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
> >  LDLIBS += $(LIBNETLINK)
> >  
> > 
> > -all: config
> > +all: config.mk
> >  	@set -e; \
> >  	for i in $(SUBDIRS); \
> >  	do echo; echo $$i; $(MAKE) -C $$i; done
> > @@ -80,7 +81,7 @@ help:
> >  	@echo "Make Arguments:"
> >  	@echo " V=[0|1]             - set build verbosity level"
> >  
> > 
> > -config:
> > +config.mk:
> >  	@if [ ! -f config.mk -o configure -nt config.mk ]; then \
> >  		sh configure $(KERNEL_INCLUDE); \
> >  	fi
> > diff --git a/configure b/configure
> > index f0c81ee1..a1b0261a 100755
> > --- a/configure
> > +++ b/configure
> > @@ -148,6 +148,19 @@ EOF
> >  	rm -f $TMPDIR/ipttest.c $TMPDIR/ipttest
> >  }
> >  
> > 
> > +check_lib_dir()
> > +{
> > +	echo -n "lib directory: "
> > +	if [ -n "$LIB_DIR" ]; then
> > +		echo "$LIB_DIR"
> > +		echo "LIBDIR:=$LIB_DIR" >> $CONFIG
> > +		return
> > +	fi
> > +
> > +	echo "/usr/lib"
> > +	echo "LIBDIR:=/usr/lib" >> $CONFIG
> > +}
> > +
> >  check_ipt()
> >  {
> >  	if ! grep TC_CONFIG_XT $CONFIG > /dev/null; then
> > @@ -486,6 +499,7 @@ usage()
> >  	cat <<EOF
> >  Usage: $0 [OPTIONS]
> >  	--include_dir		Path to iproute2 include dir
> > +	--libdir		Path to iproute2 lib dir
> >  	--libbpf_dir		Path to libbpf DESTDIR
> >  	--libbpf_force		Enable/disable libbpf by force. Available options:
> >  				  on: require link against libbpf, quit config if no libbpf support
> > @@ -507,6 +521,12 @@ else
> >  			--include_dir=*)
> >  				INCLUDE="${1#*=}"
> >  				shift ;;
> > +			--libdir)
> > +				LIB_DIR="$2"
> > +				shift 2 ;;
> > +			--libdir=*)
> > +				LIB_DIR="${1#*=}"
> > +				shift ;;
> >  			--libbpf_dir)
> >  				LIBBPF_DIR="$2"
> >  				shift 2 ;;
> > @@ -559,6 +579,7 @@ if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
> >  fi
> >  
> > 
> >  echo
> > +check_lib_dir
> >  if ! grep -q TC_CONFIG_NO_XT $CONFIG; then
> >  	echo -n "iptables modules directory: "
> >  	check_ipt_lib_dir
> 
> 	./configure --build=x86_64-linux-gnu --prefix=/usr --
> includedir=\${prefix}/include --mandir=\${prefix}/share/man --
> infodir=\${prefix}/share/info --sysconfdir=/etc --localstatedir=/var --
> disable-option-checking --disable-silent-rules --
> libdir=\${prefix}/lib/x86_64-linux-gnu --runstatedir=/run --disable-
> maintainer-mode --disable-dependency-tracking
> TC schedulers
>  ATM	yes
>  IPT	using xtables
>  IPSET  yes
> 
> lib directory: ${prefix}/lib/x86_64-linux-gnu
> 
> 
> But you end up with:
> 
> /lib/x86_64-linux-gnu/tc
> 
> /usr disappears somewhere?
>

Hi Luca,
and thanks for your review.

This is probably because my patch does not manage the --prefix option I
see in your command line. I'll fix this in v2.

Regards,
Andrea

