Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ECD28A65C
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 10:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgJKIem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 04:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgJKIem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 04:34:42 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CCBC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 01:34:42 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so14610777ior.2
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 01:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Kkztf4HxjBe3jVjhLu26l4MxkoXgID/MrQDwZTuaaS8=;
        b=a8EObZXXtXER9ElnYHp+exUq37jpFXWVXfEbBhZY7RTn50VQrnjhJeDQwlxRWBgHwx
         MU+45VAiSex4PUl43mynyQLZ5UqVJOxlrIClYk3lRMNPGeIyBgGpHYNOuaPuxjj0hNpO
         /TdrYyvpc4ulxM3Hp4/hYT8VdN54+8Y6lMbVuai2JSPF9+33dhjDMv7OOwr5H534pRWA
         I3oj6hmz5J+Pg0ytgM/926nvy88SXyoQmzkljtlxVrzKlSm2+pQcKRVs8OTRTvRLh3GO
         Io6xCBOAIvpf2jfdqzp2z0FrE645sx6wSIkyc8Qo1fqBaDPfrHUD3AaiVE2escITYMs0
         yhsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Kkztf4HxjBe3jVjhLu26l4MxkoXgID/MrQDwZTuaaS8=;
        b=T6M4vpPLZnQrH1BL3Bk931Z0cyJ6/9fJjunKEmcGMl3yfOXUlSxNfYeYQAYrsewTwH
         2avESvtlX5/jVGtnv1pbTxfwwJG3LWvqg0IDizL9Vz3OlpQgK8GORmg087BvrH/gia1O
         CmTb7J43bnXRMO0Kg/Xb855HfkrySIQCusX456+2hn9Ei6bt8ZAUsnbjAVEU4Og5fXCA
         6Ro7FYV0xXZKlW9WqPE9TWLD/QjWgmUhfHF811ViuBAJG4FKsSOhKrqKfTxrYKmPMF+e
         NLAikqabUwk9kDIbLWJgD53iL/lTxRcYMOpIUo5W+m6EW+EE02nm5G/NnK3CUp4nXrc5
         F4nw==
X-Gm-Message-State: AOAM530kw5swEtAEyMaUhHA3OeRjf/cTVJc0sDtU9bZWcn6Lc+SyyVsr
        OPurgDwJN4NW8HJHvGvWGsp+zVlg6PXIqR/ntEI8GJSTfTFRuw==
X-Google-Smtp-Source: ABdhPJwiqPAHlose+i4/3qbZI22ZipPtKsNO0gzvYVmDYt00aMig4vfqHxeyHStnGA5v3Bcc7OVWg9y11l5C9StUpZ4=
X-Received: by 2002:a05:6602:2fc2:: with SMTP id v2mr5019617iow.19.1602405281219;
 Sun, 11 Oct 2020 01:34:41 -0700 (PDT)
MIME-Version: 1.0
From:   Thayne <astrothayne@gmail.com>
Date:   Sun, 11 Oct 2020 02:34:30 -0600
Message-ID: <CALbpH+jhmunBMrBCf6L9US7xtOB-U-UZ4W2nuM5Dzz86vRqXVQ@mail.gmail.com>
Subject: [PATCH] Add documentation of fiter syntax to ss manpage
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the documentation currently referenced in the manpage no longer
exists.
---
 man/man8/ss.8 | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 3b2559ff..f9e629f6 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -401,7 +401,7 @@ Read filter information from FILE.  Each line of
FILE is interpreted
 like single command line option. If FILE is - stdin is used.
 .TP
 .B FILTER := [ state STATE-FILTER ] [ EXPRESSION ]
-Please take a look at the official documentation for details regarding filters.
+See below an explanation of STATE-FILTER and EXPRESSION.

 .SH STATE-FILTER

@@ -437,6 +437,79 @@ states except for
 - opposite to
 .B bucket

+.SH EXPRESSION
+
+The following simple expressions are supported:
+
+.TP
+.RB { \ src \ | \ dst \ } \ = \
\fR[\fIFAMILY\fB:\fR][\fIADDRESS\fR][\fB:\fIPORT\fR]
+Matches if the source or destination matches the host condition.
+Providing FAMILY is equivalent to passing the family with the -f option.
+ADDRESS and PORT are the family specific address (or hostname) and port (or
+service name) to match against. At least one of ADDRESS and PORT should be
+provided. Additionally, "*" may be used as a wildcard for either ADDRESS or
+PORT. Note that for some families, PORT is meaningless.
+
+For inet and inet6 addresses, if the address is numeric (not a hostname) a
+bitmask can be provided in CIDR notation (ex. 127.0.0.0/16) to match a range of
+addresses. If the address is provided as a hostname, all addresses returned by
+DNS for that hostname will match. The inet or inet6 address may be enclosed in
+"[" and "]".
+.TP
+.RB { \ sport \ | \ dport \ } "\fI OP \fR[\fIFAMILY\fB:\fR][\fB:\fR]\fIPORT"
+Matches if the source or destination port matches the comparison with the
+supplied port.  FAMILY and PORT are the same as above.  OP can  be any of "=",
+"!=", "<", ">", "<=", or ">=".
+.TP
+.BR dev \ { \ = \ | \ != \ }  \fI\ DEV
+Matches if it is on the specified device (or not). The device can be specified
+either by name or by index.
+.TP
+.BR fwmark \ { \ = \ | \ != \ } \ \fIMARK-MASK
+Matches if the firewall mark matches the supplied mask (or not). The
mask should
+be specified as an integer value optionally followed by a "/" and an integer
+mask. The integer may be hex-encoded if it begins with "0x" or "0X".
+.TP
+.BR cgroup \ { \ = \ | \ != \ } \ \fICGROUP
+Matches if it is part of the cgroup (or not).
+.B CGROUP
+should be the path for the desired cgroup.
+.TP
+.B autobound
+Matches if the local port is automatically bound (randomly assigned).
+
+.PP
+Each operator has equivalent aliases as follows:
+.IP
+"=" can be replaced with "==" or "eq"
+.IP
+"!=" can be replaced with "ne" or "neq"
+.IP
+">" can be replaced with "gt"
+.IP
+"<" can be replaced with "lt"
+.IP
+">=" can be replaced with "ge" or "geq"
+.IP
+"<=" can be replaced with "le" or "leq"
+
+Subexpressions can be combined into more complex expressions in the following
+ways:
+.TP
+.BI not \ EXPRESSION
+Negate the EXPRESSION. "!" can be used in place of of "not".
+.TP
+\fI EXPRESSION EXPRESSION \fR| \fIEXPRESSION \fBand \fIEXPRESSION
+Match only if both expressions match. "&" or "&&" can be used in
place of "and".
+.TP
+.IB EXPRESSION \ or \ EXPRESSION
+Match if either expression matches. "|" or "||" can be used in place of "or".
+.TP
+.BI ( \ EXPRESSION \ )
+Group EXPRESSION to change precedence of the above operators. The default
+precedence is "not", "and", "or".
+
+
 .SH USAGE EXAMPLES
 .TP
 .B ss -t -a
-- 
2.28.0
