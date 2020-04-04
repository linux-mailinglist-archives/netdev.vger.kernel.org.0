Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17119E668
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgDDQQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51233 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgDDQQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id z7so10313709wmk.1
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P0kvQBSh7np6PpLmymeMPLo1raL61bIXK5mvkI3ym84=;
        b=I2TV/nMABFpzx4mSiKJlaIcC+QIwNTdYXBrcc7kPuKHiL9wzDRBp8N39DL/L6sEdnn
         eB64Ld8HgX8XoalqvDMWbiAB1hivwclfluWiMqOKT10KaY3T6tNNwZf8gOQk+bRzFdF6
         j2Kwc/Kuj/6PQ/aQtZpbozuw6OGZidde7NHKRvb2R1K5EJn2D2oIMkNo8IccmckQvZZa
         tYRG5Lv4zyC0NNlzFeJAQKuDgFcjIij6lFQom8/KE+GwLDlHwa0HnYcldSNK071QW6b8
         GTovmeOyEgfW60u79wSJl29AXM3TqEULy4KOKOkkppHTQ38g+Wq0PZeCutSloRr59X68
         c1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P0kvQBSh7np6PpLmymeMPLo1raL61bIXK5mvkI3ym84=;
        b=GvDic3fLH3vQK/Ph/c/64HP1G42BAmaroJZsboGZfuZxI/1CB7XPV6Qpkh65uAZvwT
         GcUJSd2K/4ozYr+ZTixDjJ4FWMGoayTaJ4FLfKS69s1V8K6AVaxsovIk+1yiVxs8757n
         cN9W0OAlFCsJ+z69S8swFvHp79tRPWb5PNSBqbtSJeLYxFIyFKr5ejIlzE0biwVsF54Y
         Yx0EI+pJmDXMRXt3gA5kqeUb5o6y8jFWNLF6jKM6Zp3iAa2wzIs2a066qsrzM3a4Y3+h
         RMNwY7Ny/VGprMdHYl5wbKlAhRMS8hjzQwbfzpGg0dKvxxmK/YyAxt14ACBAej6hArDH
         LASg==
X-Gm-Message-State: AGi0PuZVN5ShqYtKyf0NvkC3aCD0mRgNRUQT3vFpByyB3ww52uhXYMEo
        Hv4AIhbLdHXhgmnjbQ/LwndAodK3434=
X-Google-Smtp-Source: APiQypKtzY705FCohMD/Ge1D9+TcQ98mJQpH/qYde+mn+6mod8mkLlrcPG91a77jAS40oPZj+hcq6w==
X-Received: by 2002:a7b:c3da:: with SMTP id t26mr13543875wmj.3.1586016992174;
        Sat, 04 Apr 2020 09:16:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z129sm16483023wmb.7.2020.04.04.09.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 8/8] man: add man page for devlink dpipe
Date:   Sat,  4 Apr 2020 18:16:21 +0200
Message-Id: <20200404161621.3452-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200404161621.3452-1-jiri@resnulli.us>
References: <20200404161621.3452-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add simple man page for devlink dpipe.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 man/man8/devlink-dpipe.8 | 100 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)
 create mode 100644 man/man8/devlink-dpipe.8

diff --git a/man/man8/devlink-dpipe.8 b/man/man8/devlink-dpipe.8
new file mode 100644
index 000000000000..00379401208e
--- /dev/null
+++ b/man/man8/devlink-dpipe.8
@@ -0,0 +1,100 @@
+.TH DEVLINK\-DPIPE 8 "4 Apr 2020" "iproute2" "Linux"
+.SH NAME
+devlink-dpipe \- devlink dataplane pipeline visualization 
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B devlink
+.RI "[ " OPTIONS " ]"
+.B dpipe
+.RB "{ " table " | " header " }"
+.RI "{ " COMMAND " | "
+.BR help " }"
+.sp
+
+.ti -8
+.IR OPTIONS " := { "
+\fB\-V\fR[\fIersion\fR] }
+
+.ti -8
+.BI "devlink dpipe table show " DEV
+.R [
+.BI name " TABLE_NAME "
+.R ]
+
+.ti -8
+.BI "devlink dpipe table set " DEV
+.BI name " TABLE_NAME "
+
+.ti -8
+.BI "devlink dpipe table dump " DEV
+.BI name " TABLE_NAME "
+
+.ti -8
+.BI "devlink dpipe header show " DEV
+
+.ti -8
+.B devlink dpipe help
+
+.SH "DESCRIPTION"
+.SS devlink dpipe table show - display devlink dpipe table attributes
+
+.TP
+.BI name " TABLE_NAME"
+Specifies the table to operate on.
+
+.SS devlink dpipe table set - set devlink dpipe table attributes
+
+.TP
+.BI name " TABLE_NAME"
+Specifies the table to operate on.
+
+.SS devlink dpipe table dump - dump devlink dpipe table entries
+
+.TP
+.BI name " TABLE_NAME"
+Specifies the table to operate on.
+
+.SS devlink dpipe header show - display devlink dpipe header attributes
+
+.TP
+.BI name " TABLE_NAME"
+Specifies the table to operate on.
+
+.SH "EXAMPLES"
+.PP
+devlink dpipe table show pci/0000:01:00.0
+.RS 4
+Shows all dpipe tables on specified devlink device.
+.RE
+.PP
+devlink dpipe table show pci/0000:01:00.0 name mlxsw_erif
+.RS 4
+Shows mlxsw_erif dpipe table on specified devlink device.
+.RE
+.PP
+devlink dpipe table set pci/0000:01:00.0 name mlxsw_erif counters_enabled true
+.RS 4
+Turns on the counters on mlxsw_erif table.
+.RE
+.PP
+devlink dpipe table dump pci/0000:01:00.0 name mlxsw_erif
+.RS 4
+Dumps content of mlxsw_erif table.
+.RE
+.PP
+devlink dpipe header show pci/0000:01:00.0
+.RS 4
+Shows all dpipe headers on specified devlink device.
+.RE
+
+.SH SEE ALSO
+.BR devlink (8),
+.BR devlink-dev (8),
+.BR devlink-monitor (8),
+.br
+
+.SH AUTHOR
+Jiri Pirko <jiri@mellanox.com>
-- 
2.21.1

