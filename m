Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0066D5BB12
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfGAL6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:58:01 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.1]:61052 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbfGAL6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 07:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nordea.com;
        s=nordeacom201804dpqlbrw; t=1561982277; i=@nordea.com;
        bh=G87xvlleifxFHMc3HMAeaTJskrvNrdUBgHeQILRge4w=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=UcYPQK6uWCAGQcx9Z2hgJvd9jUbmGezbQd14vGxhYAq8DMGZc6UjJDDRlO/J7qwg8
         SUqdP1lq+X8RYUKbI7ixSuMZSV0WVCFlr7qorrGuOwjdzZW2wMm8VH2Di4WzH6vwwy
         jMUP2co8VEB6Nf0qaoFg449LzbRkUatAYQdz7mWsaU7Fwfwmfkrz3fDdY7jF3dJfxz
         BXDv8nOUxF5kfzYYkrzkvuVHH+PR9X9Lp1qauA4xFcisl20hfRd7EIJPgkFGbeSRxZ
         Xbq8VAm7XnsowFq48+uCkg711ChWwaYB+sKiDLUJxeqcimmxYICq+7rAUA1uFVOM+r
         dacbn8lQgLa3g==
Received: from [85.158.142.100] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-central-1.aws.symcld.net id 32/4E-10067-545F91D5; Mon, 01 Jul 2019 11:57:57 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRWlGSWpSXmKPExsVy8NUOMV2Xr5K
  xBjMbrCy27n3DYnFsgZgDk8fOWXfZPT5vkgtgimLNzEvKr0hgzZh47B9zwXbRiqPPWpgaGLsF
  uxg5OdgEdCRutC1nBLFFBMQl5i/vZAexmQVcJJ70bWIFsYUFvCU+dN0Ds1kEVCT6z65gBrF5B
  Wwk9r1rBLMlBOQlfq7YBNTLwcEpYCuxa7YQSFgIqGTexm5GiHJBiZMzn7BAjJeXaN46mxnClp
  A4+OIFM0S9isTFCf/ZIEYqSJxa9J0Fwo6XeL7kAPsERv5ZSEbNQjJqFpJRCxiZVzFaJhVlpme
  U5CZm5ugaGhjoGhoa6xroGhlY6CVW6SbqpZbqJqfmlRQlAmX1EsuL9Yorc5NzUvTyUks2MQKD
  NqWQ4cIOxtuz3ugdYpTkYFIS5Z37STJWiC8pP6UyI7E4I76oNCe1+BCjDAeHkgTv1s9AOcGi1
  PTUirTMHGAEwaQlOHiURHgvg6R5iwsSc4sz0yFSpxgtOXYenbeImWPB1iVAcu12ICnEkpefly
  olzvv4C1CDAEhDRmke3DhYlF9ilJUS5mVkYGAQ4ilILcrNLEGVf8UozsGoJMzrDjKFJzOvBG7
  rK6CDmIAOyqgSAzmoJBEhJdXA1LHm5wUjhqS9pxwECrffPBMYZ3HDVvNt8Yu0EEObj+ETN9yQ
  sZl4UXpyQMnuhy47TQu62kM+2Zi7rrvYWMYUPOuthlNfy5RZ9ltFzN1zZ5zujFn6RUls+S7Hj
  E8/T8abFvdfjApJWSMbpVl/cKfdX5kpvOfrsiZduyGx5Gf9gTTJPAsWwQlHFq+9sdsmPvtux/
  y2nVwB5glsPu232e84f76WvmvleZ169tCn6YxaufnC5xQ3VKna/49K5YmVSWa4z/AtWSredUv
  bUy2Wh3zuzAElkroyV+ekZ/PrK54UMpZcWn+q/sucU6kHknbPnH7jS/y0LaZ6e/7emXBbK/LG
  gUnLW7/VX/nMoLSw6OhCJZbijERDLeai4kQA3XdpS20DAAA=
X-Env-Sender: Tomasz.Torcz@nordea.com
X-Msg-Ref: server-27.tower-225.messagelabs.com!1561982272!153264!14
X-Originating-IP: [193.234.184.22]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.43.9; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 28016 invoked from network); 1 Jul 2019 11:57:56 -0000
Received: from unknown (HELO mx5.nordea.com) (193.234.184.22)
  by server-27.tower-225.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 1 Jul 2019 11:57:56 -0000
From:   Tomasz Torcz <tomasz.torcz@nordea.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, Tomasz Torcz <tomasz.torcz@nordea.com>
Subject: [PATCH v3] ss: introduce switch to print exact value of data rates
Date:   Mon, 1 Jul 2019 13:52:44 +0200
Message-ID: <20190701115242.25960-1-tomasz.torcz@nordea.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <c28e349c-25b7-7a09-b2b3-5e64294bb089@gmail.com>
References: <c28e349c-25b7-7a09-b2b3-5e64294bb089@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.152.4.132]
X-ClientProxiedBy: VDD1MS0155.oneadr.net (10.53.65.85) To
 VDD1MS0135.oneadr.net (10.158.0.245)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Introduce -X/--exact switch to disable human-friendly printing
 of data rates. Without the switch (default), data is presented as MBps/Kbps.

  Signed-off-by: Tomasz Torcz <tomasz.torcz@nordea.com>
---
 man/man8/ss.8 |  3 +++
 misc/ss.c     | 12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

 Changes in v3:
  - updated ss man page with new option

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 9054fab9..2ba5fda2 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -290,6 +290,9 @@ that parsing /proc/net/tcp is painful.
 .B \-E, \-\-events
 Continually display sockets as they are destroyed
 .TP
+.B \-X, \-\-exact
+Show exact bandwidth values, instead of human-readable
+.TP
 .B \-Z, \-\-context
 As the
 .B \-p
diff --git a/misc/ss.c b/misc/ss.c
index 99c06d31..ba1bfff6 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -110,6 +110,7 @@ static int resolve_services = 1;
 int preferred_family = AF_UNSPEC;
 static int show_options;
 int show_details;
+static int show_human_readable = 1;
 static int show_users;
 static int show_mem;
 static int show_tcpinfo;
@@ -2361,7 +2362,9 @@ static int proc_inet_split_line(char *line, char **loc, char **rem, char **data)
 
 static char *sprint_bw(char *buf, double bw)
 {
-	if (bw > 1000000.)
+	if (!show_human_readable)
+		sprintf(buf, "%.0f", bw);
+	else if (bw > 1000000.)
 		sprintf(buf, "%.1fM", bw / 1000000.);
 	else if (bw > 1000.)
 		sprintf(buf, "%.1fK", bw / 1000.);
@@ -4883,6 +4886,7 @@ static void _usage(FILE *dest)
 "       --tos           show tos and priority information\n"
 "   -b, --bpf           show bpf filter socket information\n"
 "   -E, --events        continually display sockets as they are destroyed\n"
+"   -X, --exact         show exact bandwidth values, instead of human-readable\n"
 "   -Z, --context       display process SELinux security contexts\n"
 "   -z, --contexts      display process and socket SELinux security contexts\n"
 "   -N, --net           switch to the specified network namespace name\n"
@@ -5031,6 +5035,7 @@ static const struct option long_opts[] = {
 	{ "no-header", 0, 0, 'H' },
 	{ "xdp", 0, 0, OPT_XDPSOCK},
 	{ "oneline", 0, 0, 'O' },
+	{ "exact", 0, 0, 'X' },
 	{ 0 }
 
 };
@@ -5046,7 +5051,7 @@ int main(int argc, char *argv[])
 	int state_filter = 0;
 
 	while ((ch = getopt_long(argc, argv,
-				 "dhaletuwxnro460spbEf:miA:D:F:vVzZN:KHSO",
+				 "dhaletuwxXnro460spbEf:miA:D:F:vVzZN:KHSO",
 				 long_opts, NULL)) != EOF) {
 		switch (ch) {
 		case 'n':
@@ -5097,6 +5102,9 @@ int main(int argc, char *argv[])
 		case 'x':
 			filter_af_set(&current_filter, AF_UNIX);
 			break;
+		case 'X':
+			show_human_readable = 0;
+			break;
 		case OPT_VSOCK:
 			filter_af_set(&current_filter, AF_VSOCK);
 			break;
-- 
2.21.0

