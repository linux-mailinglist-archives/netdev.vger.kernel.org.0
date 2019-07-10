Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 806BB6466E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfGJMlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:41:13 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:36397 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbfGJMlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:41:11 -0400
Received: by mail-wm1-f53.google.com with SMTP id g67so2126775wme.1
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 05:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gr9HEsxvkhORqGpDxpOnjSaFaOUXWvJHYXoYUcexVM8=;
        b=PDLEZKRdFlS0oxZWcZt5HpmMM7U/gp7Mpbe6buV5/fR5q0x1Usoby2+Ymc9PdwEUSI
         kcbpzQffE7zcmo9ZabroZIzhIeIsc0NkcRMM1sZECkVn2KrKD462ZDJFG/Msea9qoXok
         6GwJrsPxaQevqsOFBG32d86SjaEg/IdSKxfNqjx6DaP/mTxvFCcWDXZPCDh5UlOb3P13
         tTJOftTtZiD9xHTpCpytlHcVi3BJBjq9WGEIvMS9tBfEkzr7c76pgBD7ixopW/PUx65u
         14TaGk50K8XIdQSwffClPA/LJjEY38WxbiLDKeV3HQABgZGGxH7IqKs9Hvmp3YNLAhOs
         epig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gr9HEsxvkhORqGpDxpOnjSaFaOUXWvJHYXoYUcexVM8=;
        b=t4DXJsbdXtOXrQxSrIJEBVI+O+Jve7qS+8tjVw0FycUWJfu3N1DhJj1tE8WuDU0ymI
         JqF0rzNqcFx8LFuPI3hs4H3FkojS7kKsCFOSk4doO3K2KSWKv0n7+XPdzeV6uWF+WSGd
         9/uIGslPF2fwfhNe8MghEkJdEwCn7I3N5YCz36YZrJn41En/SqBg/A3ghb/hJYQ6jhgR
         hTe4uXUex4tCPZ3R7v2nTbrYznJ3TV7SoaoQ2dI6PpWkR8EKSJtmftTJJuH4K7P5STzU
         X3HnuRsWQDQpyuBK1ls7sgn9UeBclF+usjvYQSibKaP2wU+g2s06ovOi1BXAG5DtBY/N
         082w==
X-Gm-Message-State: APjAAAXL3cIOpAaue94tCarudBDzbiW/iptctrZF60mtswUfXGK5/kqN
        A3mD2n7+S4NGgsvQ2HuV50R4PQnjpcU=
X-Google-Smtp-Source: APXvYqznQrPVQCyV2ImrTUJvwdAmMqoYeDXw2LkAX/GgKlAZrvdCHTH1yASDVKctaqmRfjdosup8aQ==
X-Received: by 2002:a1c:dc46:: with SMTP id t67mr4968493wmg.159.1562762468492;
        Wed, 10 Jul 2019 05:41:08 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id z5sm1406759wmf.48.2019.07.10.05.41.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 05:41:07 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        stephen@networkplumber.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH iproute2-next v2 3/3] man: update man pages for TC MPLS actions
Date:   Wed, 10 Jul 2019 13:40:40 +0100
Message-Id: <1562762440-25656-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
References: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a man page describing the newly added TC mpls manipulation actions.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 man/man8/tc-mpls.8 | 156 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)
 create mode 100644 man/man8/tc-mpls.8

diff --git a/man/man8/tc-mpls.8 b/man/man8/tc-mpls.8
new file mode 100644
index 0000000..84ef2ef
--- /dev/null
+++ b/man/man8/tc-mpls.8
@@ -0,0 +1,156 @@
+.TH "MPLS manipulation action in tc" 8 "22 May 2019" "iproute2" "Linux"
+
+.SH NAME
+mpls - mpls manipulation module
+.SH SYNOPSIS
+.in +8
+.ti -8
+.BR tc " ... " "action mpls" " { "
+.IR POP " | " PUSH " | " MODIFY " | "
+.BR dec_ttl " } [ "
+.IR CONTROL " ]"
+
+.ti -8
+.IR POP " := "
+.BR pop " " protocol
+.IR MPLS_PROTO
+
+.ti -8
+.IR PUSH " := "
+.BR push " [ " protocol
+.IR MPLS_PROTO " ]"
+.RB " [ " tc
+.IR MPLS_TC " ] "
+.RB " [ " ttl
+.IR MPLS_TTL " ] "
+.RB " [ " bos
+.IR MPLS_BOS " ] "
+.BI label " MPLS_LABEL"
+
+.ti -8
+.IR MODIFY " := "
+.BR modify " [ " label
+.IR MPLS_LABEL " ]"
+.RB " [ " tc
+.IR MPLS_TC " ] "
+.RB " [ " ttl
+.IR MPLS_TTL " ] "
+
+.ti -8
+.IR CONTROL " := { "
+.BR reclassify " | " pipe " | " drop " | " continue " | " pass " | " goto " " chain " " CHAIN_INDEX " }"
+.SH DESCRIPTION
+The
+.B mpls
+action performs mpls encapsulation or decapsulation on a packet, reflected by the
+operation modes
+.IR POP ", " PUSH ", " MODIFY " and " DEC_TTL .
+The
+.I POP
+mode requires the ethertype of the header that follows the MPLS header (e.g.
+IPv4 or another MPLS). It will remove the outer MPLS header and replace the
+ethertype in the MAC header with that passed. The
+.IR PUSH " and " MODIFY
+modes update the current MPLS header information or add a new header.
+.IR PUSH
+requires at least an
+.IR MPLS_LABEL ". "
+.I DEC_TTL
+requires no arguments and simply subtracts 1 from the MPLS header TTL field.
+
+.SH OPTIONS
+.TP
+.B pop
+Decapsulation mode. Requires the protocol of the next header.
+.TP
+.B push
+Encapsulation mode. Requires at least the
+.B label
+option.
+.TP
+.B modify
+Replace mode. Existing MPLS tag is replaced.
+.BR label ", "
+.BR tc ", "
+and
+.B ttl
+are all optional.
+.TP
+.B dec_ttl
+Decrement the TTL field on the outer most MPLS header.
+.TP
+.BI label " MPLS_LABEL"
+Specify the MPLS LABEL for the outer MPLS header.
+.I MPLS_LABEL
+is an unsigned 20bit integer, the format is detected automatically (e.g. prefix
+with
+.RB ' 0x '
+for hexadecimal interpretation, etc.).
+.TP
+.BI protocol " MPLS_PROTO"
+Choose the protocol to use. For push actions this must be
+.BR mpls_uc " or " mpls_mc " (" mpls_uc
+is the default). For pop actions it should be the protocol of the next header.
+This option cannot be used with modify.
+.TP
+.BI tc " MPLS_TC"
+Choose the TC value for the outer MPLS header. Decimal number in range of 0-7.
+Defaults to 0.
+.TP
+.BI ttl " MPLS_TTL"
+Choose the TTL value for the outer MPLS header. Number in range of 0-255. A
+non-zero default value will be selected if this is not explicitly set.
+.TP
+.BI bos " MPLS_BOS"
+Manually configure the bottom of stack bit for an MPLS header push. The default
+is for TC to automatically set (or unset) the bit based on the next header of
+the packet.
+.TP
+.I CONTROL
+How to continue after executing this action.
+.RS
+.TP
+.B reclassify
+Restarts classification by jumping back to the first filter attached to this
+action's parent.
+.TP
+.B pipe
+Continue with the next action, this is the default.
+.TP
+.B drop
+Packet will be dropped without running further actions.
+.TP
+.B continue
+Continue classification with next filter in line.
+.TP
+.B pass
+Return to calling qdisc for packet processing. This ends the classification
+process.
+.RE
+.SH EXAMPLES
+The following example encapsulates incoming IP packets on eth0 into MPLS with
+a label 123 and sends them out eth1:
+
+.RS
+.EX
+#tc qdisc add dev eth0 handle ffff: ingress
+#tc filter add dev eth0 protocol ip parent ffff: flower \\
+	action mpls push protocol mpls_uc label 123  \\
+	action mirred egress redirect dev eth1
+.EE
+.RE
+
+In this example, incoming MPLS unicast packets on eth0 are decapsulated and to
+ip packets and output to eth1:
+
+.RS
+.EX
+#tc qdisc add dev eth0 handle ffff: ingress
+#tc filter add dev eth0 protocol mpls_uc parent ffff: flower \\
+	action mpls pop protocol ipv4  \\
+	action mirred egress redirect dev eth0
+.EE
+.RE
+
+.SH SEE ALSO
+.BR tc (8)
-- 
2.7.4

