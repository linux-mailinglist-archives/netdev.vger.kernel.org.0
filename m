Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4250638FF
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 18:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfGIQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 12:00:15 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:52972 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfGIQAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 12:00:14 -0400
Received: by mail-wm1-f51.google.com with SMTP id s3so3652125wms.2
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 09:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gr9HEsxvkhORqGpDxpOnjSaFaOUXWvJHYXoYUcexVM8=;
        b=r0oFSqyk51SZW4w/uPeJuKX36gmTQmB9nJL0rA6AFZGIY337kGia/aaheSTzy05ZUW
         vzStVW64WEzOO386DhsJd0LZj3EUrGBkzKKEaCKP8QgIaKNJZSbSSYVfKpaX61FHIIBe
         /Ji4ROeMVNZeDQMkUgyQgUD5NCNgX7cU9lATfGLCBliMSviHoPYuBIQ9ryHKVobBs95A
         zAObS0KOf80GZ9KHd80vBUhFL3rBrTwvWwjnTMIosQBfNaipiAyJyWmfZgITQRPjVQEC
         kd6RrHxwJYpz3YkWhCUW3GQ/DRKwat2wMUVxiSsP8UBjR6JthmoC/zPt9sW0JcPC+eOw
         vvcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gr9HEsxvkhORqGpDxpOnjSaFaOUXWvJHYXoYUcexVM8=;
        b=f4CHBZ3QWGXrDHLEtb6wPiqLctItQKZ747asRV0G5JPjDws1E4PAJNc7v6WGvRMKVo
         oIPifW17z4h2WDjdBXbELj/GoqomYWQiMHA+XhWfOaInEfzZnZN56Kl9NuV4zgfQ9RGc
         NoP7Dd9T3KR6xhXjQEFKEZ557LZua0YqI35vKjroWs4YjmXL3ZBpiraOOXc6iXIpae8+
         n+lq2ve/iNvauVu8IuIA5wSIkf58Jmye6FjZ0QHi9+JNIm7sLmikOnqr18I0facOe/LQ
         COSwMZdZXwpvTOu2QPXMx96VhFYvOUtBKOG0IM6/vFoyR2PRnnKTFQLMCYrC57RuMUVf
         o9WQ==
X-Gm-Message-State: APjAAAUrGLJe0pGB1aRE1jhGtv36/4i3Q9kf0UHOUt863N6sjKXsrFgx
        dsrv75d835aZ08pL5Fhvj76k93fGo/A=
X-Google-Smtp-Source: APXvYqzBMUUbYOc7QhFTrstdwXTC80rDqk4El/fFMkMCy6SNSlhermpSo5zpE0p0TDVwuDJAo+dZpg==
X-Received: by 2002:a1c:e715:: with SMTP id e21mr663006wmh.16.1562688011101;
        Tue, 09 Jul 2019 09:00:11 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t6sm3725900wmb.29.2019.07.09.09.00.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 09 Jul 2019 09:00:10 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH iproute2-next 3/3] man: update man pages for TC MPLS actions
Date:   Tue,  9 Jul 2019 16:59:32 +0100
Message-Id: <1562687972-23549-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
References: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
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

