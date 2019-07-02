Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D74F5C996
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfGBGyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 02:54:03 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.2]:40623 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfGBGyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 02:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nordea.com;
        s=nordeacom201804dpqlbrw; t=1562050439; i=@nordea.com;
        bh=WTQs46mDfQo975o+yQUW9sLknr3u1FwEI/DDFxJ3/q0=;
        h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=YfsgG+pVU9ceIqxR/QXu0vWnwPPjfkp5arKpDB21Ol8JUwMqqmjUgOkxZ59f3GeU8
         ABtesZ1OUvIk4CqOj1qxX0SN/vDU23t4IvXrrA6fD6HsV9vPJpeCa+O1IFdZMOVtI0
         NjT7bu05fEHNCz7iP9e/cASNfz2a+hWlR67pJwPDYJLgcvZ3GM9UFBy9Jke9KIjjsc
         SsY/5TLXq20czNzG1oPo+Ood3CMMFSt7Yw+yektWUDfqxlYyLdhbNMbl9Y6CX19tCA
         53Z6i2T7mZ4sZiFYhnoVK3TfbJrASW+Rm9qd19cJqiqGKUb+EoY81lRbNFfeNVN/cs
         ZJQy/xmy6OS4g==
Received: from [85.158.142.100] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-central-1.aws.symcld.net id 1F/AF-11093-78FFA1D5; Tue, 02 Jul 2019 06:53:59 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRWlGSWpSXmKPExsVy8NUOMd32/1K
  xBhuuCVls3fuGxeLYAjEHJo+ds+6ye3zeJBfAFMWamZeUX5HAmvFw2XHmghWcFVenzGJsYLzD
  3sXIycEmoCNxo205I4gtIiAuMX95J1icWcBF4knfJlYQW1jAQ+L2nQVMIDaLgIrE3hW9LCA2r
  4CNxMKOeWA1EgLyEj9XbALr5RSwlZj86xJbFyMHhxBQzYvpyhDlghInZz5hgRgvL9G8dTYzhC
  0hcfDFCzBbCGj8xQn/2SBGKkicWvSdBcJOkLg4awbzBEb+WUhGzUIyahaSUQsYmVcxWiYVZaZ
  nlOQmZuboGhoY6BoaGusCSRMjvcQq3US91FLd5NS8kqJEoKxeYnmxXnFlbnJOil5easkmRmDQ
  phQy9O1gfDLrjd4hRkkOJiVR3rmfJGOF+JLyUyozEosz4otKc1KLDzHKcHAoSfDu+CcVKyRYl
  JqeWpGWmQOMIJi0BAePkgjvQpA0b3FBYm5xZjpE6hSjMceCrUsWMXOs3Q4khVjy8vNSpcR5U0
  BKBUBKM0rz4AbBIvsSo6yUMC8jAwODEE9BalFuZgmq/CtGcQ5GJWHeT3+BpvBk5pXA7XsFdAo
  T0Cny+WCnlCQipKQamNoLLsmnFO80k0p9v3D5LqZi95l+n5fblrgoNPzfGbGzvrjP0OhJ/cym
  H75PvN5NO33K8+uV7RPVl11vMrh2bWlonjAn85wD2mLuCzI6n6f9a5l39WPqiRfq0w39fra2B
  by8OlHrp5zYSrf7HkqbM+WPJk77eCzztkgMZ4Ko7opnWQHpl2xfCxdr3dYLu7t02r9p/Ec9Lz
  7KWKjztvzwi/RUceXNtflW7hMTV6tzJk+9qJN34ShXhH+v6KuZk0R6/x7/VHedoWvBxeKEd9Z
  OW0/7Ja/LPjZpu/y3CXftPfJnnc64YpB9I/jPzwlz3FdYXpaoqDbtsv1zO7LJIrmpKKPwlrpX
  bkTAPYvXdstWVymxFGckGmoxFxUnAgCRB1fNZwMAAA==
X-Env-Sender: Tomasz.Torcz@nordea.com
X-Msg-Ref: server-11.tower-225.messagelabs.com!1562050438!212179!1
X-Originating-IP: [193.234.184.22]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.43.9; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 28159 invoked from network); 2 Jul 2019 06:53:59 -0000
Received: from unknown (HELO mx5.nordea.com) (193.234.184.22)
  by server-11.tower-225.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 2 Jul 2019 06:53:59 -0000
From:   Tomasz Torcz <tomasz.torcz@nordea.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, Tomasz Torcz <tomasz.torcz@nordea.com>
Subject: [PATCH] ss: in --numeric mode, print raw numbers for data rates
Date:   Tue, 2 Jul 2019 08:53:39 +0200
Message-ID: <20190702065339.18735-1-tomasz.torcz@nordea.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <13d80225-8b36-3990-4718-aafbb9602d7d@gmail.com>
References: <13d80225-8b36-3990-4718-aafbb9602d7d@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.152.4.132]
X-ClientProxiedBy: VDD1MS0132.oneadr.net (10.158.1.228) To
 VDD1MS0135.oneadr.net (10.158.0.245)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  ss by default shows data rates in human-readable form - as Mbps/Gbps etc.
 Enhance --numeric mode to show raw values in bps, without conversion.

  Signed-of-by: Tomasz Torcz <tomasz.torcz@nordea.com>
---
 man/man8/ss.8 | 2 +-
 misc/ss.c     | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 9054fab9..f428e60c 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -28,7 +28,7 @@ Suppress header line.
 Print each socket's data on a single line.
 .TP
 .B \-n, \-\-numeric
-Do not try to resolve service names.
+Do not try to resolve service names. Show exact bandwidth values, instead of human-readable.
 .TP
 .B \-r, \-\-resolve
 Try to resolve numeric address/ports.
diff --git a/misc/ss.c b/misc/ss.c
index 99c06d31..3d9d1d8f 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2361,7 +2361,9 @@ static int proc_inet_split_line(char *line, char **loc, char **rem, char **data)
 
 static char *sprint_bw(char *buf, double bw)
 {
-	if (bw > 1000000.)
+	if (!resolve_services)
+		sprintf(buf, "%.0f", bw);
+	else if (bw > 1000000.)
 		sprintf(buf, "%.1fM", bw / 1000000.);
 	else if (bw > 1000.)
 		sprintf(buf, "%.1fK", bw / 1000.);
-- 
2.21.0

