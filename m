Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0492A217558
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgGGRku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgGGRku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:40:50 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC5BC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 10:40:50 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 17so47392726wmo.1
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 10:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=LOio8vNKEJ0xg5YgLJAkeb7hoLWBcn3xl0FDpYc4wb0=;
        b=C5Z8D91trpg3Ch6xEJtis7CO8oZVueCwkpo/dfz3L+SnFjDwHn2I2VJOzCBbZXeu+F
         4koHb9nkpxO0PVdzQi3iUPhg+6pDZIsWQF/SNWTPuQySH3twQ0wJKE3AQ30kzPQOcS3g
         8Xk642MT7MU2rnmZSEHwYHrAIse+HNkq2/Dc0nezWvfdyVVSMucmusXPRFaQk5+XAtfW
         pIfLekJdx6ZuPQuoO5A87QhOi19m1A3TAB1Uu3K6ihy94+sOKYyx4SKOJe5Y6tnxiVuk
         STk8Z8HCJaywYnp/8bm5Ob3NFrgUKzJb9+FDhs1VDgr8DDH4MeCGE8id1eoKXH2lU5Zx
         bKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LOio8vNKEJ0xg5YgLJAkeb7hoLWBcn3xl0FDpYc4wb0=;
        b=DVXT4VmDi3c93/NkJGY/csP7xMPr7KJsYvnP0GxiVuCPmOIoeiQCeOlv82kn1Mr88I
         bUZoEPvOOpIg/aI4IxxXDJB0OuBxYRMpgk2SrqMhGmVm5u7Ve/oj7urkSCTmQIC66ant
         NLWX0gW4RFSB/b1etV6loZGZcohDiRQV0dBf5BUeduD1yFPacT3+Pld+4P3PTpx074X5
         phdfDLGDf8r6vGXPH3yxa8XLu0+mDIF1GEZrqVve0Ep9O8yLjGHE89icTI6BsMY1Zkqd
         AIWaKY1AS0vW4300f+i742NMz5MKP6hLVfHLGBCXKBfQKEKWUXbw71TeIWLFf5bFVf2y
         HPWA==
X-Gm-Message-State: AOAM531yBZNLtDHUdcp/EDE4ORfBGMD/0oSZEBKrGM+7IKO1yh/82RIH
        A4TnLt4sQ3/R2Y1jvbr43h+JjBoXtmOQdkpZJPVEF2RtRUU=
X-Google-Smtp-Source: ABdhPJwBrUU08fiJLLwy7TGgeAjxErZWgdkgMZKNkRS/LdLhDz1j8eE6B2lgB4Oe07qLoj1AQs5PYnTKp5r5RrC/Dyk=
X-Received: by 2002:a1c:81c1:: with SMTP id c184mr5213887wmd.120.1594143647926;
 Tue, 07 Jul 2020 10:40:47 -0700 (PDT)
MIME-Version: 1.0
From:   Evelyn Mitchell <efmphone@gmail.com>
Date:   Tue, 7 Jul 2020 11:40:37 -0600
Message-ID: <CABD0H0sKx14FoWthLAC9MijT4q7RYOdZhyW_x-JPHdFm+=ggXw@mail.gmail.com>
Subject: [PATCH iproute2] man: ip-rule.8: minor changes
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are grammatical and typographical fixes, with one wording change.

Evelyn Mitchell
tummy.com

---
--- ip-rule.8.orig      2020-07-07 11:17:00.609932807 -0600
+++ ip-rule.8   2020-07-07 11:25:48.247022637 -0600
@@ -88,7 +88,7 @@
 .SH DESCRIPTION
 .I ip rule
 manipulates rules
-in the routing policy database control the route selection algorithm.
+in the routing policy database to control the route selection algorithm.

 .P
 Classic routing algorithms used in the Internet make routing decisions
@@ -166,7 +166,7 @@

 .P
 Each RPDB entry has additional
-attributes. F.e. each rule has a pointer to some routing
+attributes. For example, each rule has a pointer to some routing
 table. NAT and masquerading rules have an attribute to select new IP
 address to translate/masquerade. Besides that, rules have some
 optional attributes, which routes have, namely
@@ -252,11 +252,11 @@

 .TP
 .BI sport " NUMBER | NUMBER-NUMBER"
-select the source port value to match. supports port range.
+select the source port value to match. Supports port range.

 .TP
 .BI dport " NUMBER | NUMBER-NUMBER"
-select the destination port value to match. supports port range.
+select the destination port value to match. Supports port range.

 .TP
 .BI priority " PREFERENCE"
@@ -276,7 +276,7 @@

 .TP
 .BI protocol " PROTO"
-the routing protocol who installed the rule in question.  As an
example when zebra installs a rule it would get RTPROT_ZEBRA as the
installing protocol.
+the routing protocol which installed the rule in question.  As an
example when zebra installs a rule it would get RTPROT_ZEBRA as the
installing protocol.

 .TP
 .BI suppress_prefixlength " NUMBER"
