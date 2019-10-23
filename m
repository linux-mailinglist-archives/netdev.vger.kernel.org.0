Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94BCFE205B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407153AbfJWQQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:16:47 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:42207 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407150AbfJWQQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:16:46 -0400
Received: by mail-pg1-f178.google.com with SMTP id f14so12412165pgi.9
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z82OOusB5OMb9wbvxSvHN8dIdvJSZWQJIRRS954M2h8=;
        b=h8VziyeV68fVCoDF5fes0SQILfKX40eBYwfeRGLayc/e3pXZvbWQkNISsJJgaMNGNJ
         aaTFp5D/xO+VAEQZ9OSfrQSDwBKjdT+1yRRWmqu14mIo7KRN51Srxeq9Zu8paFJpNF0/
         EbJBXA15z3K/7ouPXJb/7ETbzWojFETNPJwXLKmP+IjwdyKSeOs8mW4vF9HtoE0F3OUE
         HSR726vSezzqaZ+5Y9c2OmY4hYKgPyNuEPb78FDpBEbyLEnVGhhhezjFVrwIekqoGwvJ
         YF0XkujBVwtEzGJz4wv4BzR/HTBvBTYQhxtIIOZDdQUAEju9qoN7FQ1t1PMyhgJQzy4r
         y3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z82OOusB5OMb9wbvxSvHN8dIdvJSZWQJIRRS954M2h8=;
        b=YSKpho3CB2ntTAt38zk/n7L+D0rdq1S0n0+Yq+V87YG7i2qH66i4g3eFzf42L0jOkV
         r6z1AerhkG/K2RzeHoXgFBvggeuDO2P1EzyRX9eEzGJcEfB1nvLIH9tzLnkGIKBaP62G
         O3tH26Jzc9+Vj2sGMcMeIQC4Tc/kCKrCajSDSWJL9FDMwmEWSA+Mo/ZRCkX5HGw9vO8T
         Qmytx34s1JEs4vU6n1t7Uo6tssdyFDouEJu8ln42+5SxVdFKnWEYLwW+GzC8zu+VQgcw
         ctvdwloOizcvC2Ym2P88WgHKTWhMmNkvU0NXX0Cj9tQIUmLVyup3+Ccht7ii8dLY/O/E
         v8+g==
X-Gm-Message-State: APjAAAWXiogX8JtVhQClQot3RaOWunCkvgbf0RnYZRtYNEV6RrMS492i
        GYjSh6eKIkzYPv78Styvf7qWdT6Cn/X7Gg==
X-Google-Smtp-Source: APXvYqz9qCUcI9sdBSG6vMKrLlLq/pz1f4E24zkHMOitUlUrfavafDLfXQDGZjuA3iGmPcPM0iqq/Q==
X-Received: by 2002:a17:90a:234d:: with SMTP id f71mr971896pje.134.1571847403702;
        Wed, 23 Oct 2019 09:16:43 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m12sm12012724pjk.13.2019.10.23.09.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 09:16:42 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 2/3] examples: remove gaiconf
Date:   Wed, 23 Oct 2019 09:16:31 -0700
Message-Id: <20191023161632.541-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191023161632.541-1-stephen@networkplumber.org>
References: <20191023161632.541-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gaiconf script is a workaround for something now handled
in distros as part of libc.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 examples/gaiconf | 134 -----------------------------------------------
 1 file changed, 134 deletions(-)
 delete mode 100644 examples/gaiconf

diff --git a/examples/gaiconf b/examples/gaiconf
deleted file mode 100644
index d75292b900cc..000000000000
--- a/examples/gaiconf
+++ /dev/null
@@ -1,134 +0,0 @@
-#!/bin/sh
-
-#
-# Setup address label from /etc/gai.conf
-#
-# Written by YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, 2010.
-#
-
-IP=ip
-DEFAULT_GAICONF=/etc/gai.conf
-verbose=
-debug=
-
-function run ()
-{
-	if [ x"$verbose" != x"" ]; then
-		echo "$@"
-	fi
-	if [ x"$debug" = x"" ]; then
-		"$@"
-	fi
-}
-
-function do_load_config ()
-{
-	file=$1; shift
-	flush=1
-	cat $file | while read command prefix label; do
-		if [ x"$command" = x"#label" ]; then
-			if [ ${flush} = 1 ]; then
-				run ${IP} -6 addrlabel flush
-				flush=0
-			fi
-			run ${IP} -6 addrlabel add prefix $prefix label $label
-		fi
-	done
-}
-
-function do_list_config ()
-{
-	${IP} -6 addrlabel list | while read p pfx l lbl; do
-		echo label ${pfx} ${lbl}
-	done
-}
-
-function help ()
-{
-	echo "Usage: $0 [-v] {--list | --config [ ${DEFAULT_GAICONF} ] | --default}"
-	exit 1
-}
-
-TEMP=`getopt -o c::dlv -l config::,default,list,verbose -n gaiconf -- "$@"`
-
-if [ $? != 0 ]; then
-	echo "Terminating..." >&2
-	exit 1
-fi
-
-TEMPFILE=`mktemp`
-
-eval set -- "$TEMP"
-
-while true ; do
-	case "$1" in
-		-c|--config)
-			if [ x"$cmd" != x"" ]; then
-				help
-			fi
-			case "$2" in
-			"")	gai_conf="${DEFAULT_GAICONF}"
-				shift 2
-				;;
-			*)	gai_conf="$2"
-				shift 2
-			esac
-			cmd=config
-			;;
-		-d|--default)
-			if [ x"$cmd" != x"" ]; then
-				help
-			fi
-			gai_conf=${TEMPFILE}
-			cmd=config
-			;;
-		-l|--list)
-			if [ x"$cmd" != x"" ]; then
-				help
-			fi
-			cmd=list
-			shift
-			;;
-		-v)
-			verbose=1
-			shift
-			;;
-		--)
-			shift;
-			break
-			;;
-		*)
-			echo "Internal error!" >&2
-			exit 1
-			;;
-	esac
-done
-
-case "$cmd" in
-	config)
-		if [ x"$gai_conf" = x"${TEMPFILE}" ]; then
-			sed -e 's/^[[:space:]]*//' <<END_OF_DEFAULT >${TEMPFILE}
-				label ::1/128       0
-				label ::/0          1
-				label 2002::/16     2
-				label ::/96         3
-				label ::ffff:0:0/96 4
-				label fec0::/10     5
-				label fc00::/7      6
-				label 2001:0::/32   7
-END_OF_DEFAULT
-		fi
-		do_load_config "$gai_conf"
-		;;
-	list)
-		do_list_config
-		;;
-	*)
-		help
-		;;
-esac
-
-rm -f "${TEMPFILE}"
-
-exit 0
-
-- 
2.20.1

