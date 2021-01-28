Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4533070C6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 09:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhA1IMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhA1ILO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 03:11:14 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F41C06174A
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 00:10:31 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id h192so5187400oib.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 00:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W7li5Kz6qMNn1tlF3+MX15IskT1fdQtRmwGLGKIP23s=;
        b=oLn81LSzquz7fPAD/U1ueFO/oJeCryG1TWMtaQ5H8Sb79vDD/bv6bKWXVNkDR7XV95
         /o0X5/wFWmkv2sWFeib2xJa4hZjSrJJfkWchwP701zIZxhHwMZi663bFkrndEngrAZyI
         KfNiHb8xM70jpGUKCbsxu62WOqN9zjlDvY9gQNY+RXsEgUoxVyzXh0OLZxwBytDmXzSA
         HiFkHfvqUPG0H2UcWyPl9o6oNxsY9gIZHAno0h4bBWs2PQf4/pDcKpuZ1eRhDxVQfuGv
         r8aKjMUQKu2dtNbS9rXQwoeBZFsB+8/61pZtEl1N9SGkk0L388gJOPjJwnmYVjMVTegu
         GIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W7li5Kz6qMNn1tlF3+MX15IskT1fdQtRmwGLGKIP23s=;
        b=r+E4+b50HQ/uTOCT1l0vIPVTZdqWiAXVWwC2C/a09e+xLzCClbDzmtUxKQAnSGEqfH
         1p1ZpCS3doWoo+SzCNv+oKNVMBf3z4tlqdJFNVRdTahEfwn0hgHSMxZJBGaumeOReriY
         39oYP5RJCMr31uXozX/HEIjoe1VliglhIrl2GWhDRMDfkSHVOmkno6FPbfCkVSOPoG/w
         AgqPl1Omvt+xgL1/qt53Lf2Gz6n+qOM1iMorqZBPUktY+gozq8bIpGOppDz0CQdr5ntz
         N8+RzwtUkvz/7QeBp+5oHYn9X/v8T6haW4/pXbhOVnpPNmjRXpMa6vtyAo/Gvb0p7fdh
         nBPQ==
X-Gm-Message-State: AOAM530bHIvVlLN+z9J3Tl9H96uDKhu1zrcJ4Yccgk7CA32LcQMcP/gI
        3y+tFR0UTsgMKbyTm3ExQQIlSJ5L7QQCvg==
X-Google-Smtp-Source: ABdhPJwKmu0ckjesdZQH/RMFByMlwTSYgsYs4r48WwIdQ13dtj4gB8MPwuggfejGmna8NaUhLgK6fA==
X-Received: by 2002:aca:508f:: with SMTP id e137mr5811147oib.32.1611821431166;
        Thu, 28 Jan 2021 00:10:31 -0800 (PST)
Received: from tardis.. (c-67-182-242-199.hsd1.ut.comcast.net. [67.182.242.199])
        by smtp.gmail.com with ESMTPSA id 67sm854100ott.64.2021.01.28.00.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 00:10:30 -0800 (PST)
From:   Thayne McCombs <astrothayne@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Thayne McCombs <astrothayne@gmail.com>
Subject: [PATCH] Add documentation of ss filter to man page
Date:   Thu, 28 Jan 2021 01:10:18 -0700
Message-Id: <20210128081018.9394-1-astrothayne@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some documentation of the syntax for the FILTER argument to
the ss command to the ss (8) man page.

Signed-off-by: Thayne McCombs <astrothayne@gmail.com>
---
 man/man8/ss.8 | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index e4b9cdc..3da279f 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -440,6 +440,111 @@ states except for
 - opposite to
 .B bucket
 
+.SH EXPRESSION
+
+.B EXPRESSION
+allows filtering based on specific criteria.
+.B EXPRESSION
+consists of a series of predicates combined by boolean operators. The possible operators in increasing
+order of precedence are
+.B or
+(or | or ||),
+.B and
+(or & or &&), and
+.B not
+(or !). If no operator is between consecutive predicates, an implicit
+.B and
+operator is assumed. Subexpressions can be grouped with "(" and ")".
+.P
+The following predicates are supported:
+
+.TP
+.B {dst|src} [=] HOST
+Test if the destination or source matches HOST. See HOST SYNTAX for details.
+.TP
+.B {dport|sport} [OP] [FAMILY:]:PORT
+Compare the destination or source port to PORT. OP can be any of "<", "<=", "=", "!=",
+">=" and ">". Following normal arithmetic rules. FAMILY and PORT are as described in
+HOST SYNTAX below.
+.TP
+.B dev [=|!=] DEVICE
+Match based on the device the connection uses. DEVICE can either be a device name or the
+index of the interface.
+.TP
+.B fwmark [=|!=] MASK
+Matches based on the fwmark value for the connection. This can either be a specific mark value
+or a mark value followed by a "/" and a bitmask of which bits to use in the comparison. For example
+"fwmark = 0x01/0x03" would match if the two least significant bits of the fwmark were 0x01.
+.TP
+.B cgroup [=|!=] PATH
+Match if the connection is part of a cgroup at the given path.
+.TP
+.B autobound
+Match if the port or path of the source address was automatically allocated
+(rather than explicitly specified).
+.P
+Most operators have aliases. If no operator is supplied "=" is assumed.
+Each of the following groups of operators are all equivalent:
+.RS
+.IP \(bu 2
+= == eq
+.IP \(bu
+!= ne neq
+.IP \(bu
+> gt
+.IP \(bu
+< lt
+.IP \(bu
+>= ge geq
+.IP \(bu
+<= le leq
+.IP \(bu
+! not
+.IP \(bu
+| || or
+.IP \(bu
+& && and
+.RE
+.SH HOST SYNTAX
+.P
+The general host syntax is [FAMILY:]ADDRESS[:PORT].
+.P
+FAMILY must be one of the families supported by the -f option. If not given
+it defaults to the family given with the -f option, and if that is also
+missing, will assume either inet or inet6.
+.P
+The form of ADDRESS and PORT depends on the family used. "*" can be used as
+a wildcord for either the address or port. The details for each family are as
+follows:
+.TP
+.B unix
+ADDRESS is a glob pattern (see
+.BR fnmatch (3))
+that will be matched case-insensitively against the unix socket's address. Both path and abstract
+names are supported. Unix addresses do not support a port, and "*" cannot be used as a wildcard.
+.TP
+.B link
+ADDRESS is the case-insensitive name of an ethernet protocol to match. PORT
+is either a device name or a device index for the desired link device, as seen
+in the output of ip link.
+.TP
+.B netlink
+ADDRESS is a descriptor of the netlink family. Possible values come from
+/etc/iproute2/nl_protos. PORT is the port id of the socket, which is usually
+the same as the owning process id. The value "kernel" can be used to represent
+the kernel (port id of 0).
+.TP
+.B vsock
+ADDRESS is an integer representing the CID address, and PORT is the port.
+.TP
+.BR inet \ and\  inet6
+ADDRESS is an ip address (either v4 or v6 depending on the family) or a DNS
+hostname that resolves to an ip address of the required version. An ipv6
+address must be enclosed in "[" and "]" to disambiguate the port seperator. The
+address may addtionally have a prefix length given in CIDR notation (a slash
+followed by the prefix length in bits). PORT is either the numerical
+socket port, or the service name for the port to match.
+
 .SH USAGE EXAMPLES
 .TP
 .B ss -t -a
-- 
2.30.0

