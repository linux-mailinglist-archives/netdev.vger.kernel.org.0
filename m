Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC668B54C
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfHMKUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:20:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33873 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfHMKUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:20:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id e8so739652wme.1
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 03:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mYbGNAbVxfg8sZIbwCbxi5At7Ar3E4jfEniJRUqCtIM=;
        b=NGqy/Zg/Ap4yIWDcvCYKoQ9JRKC/Oh5va9tdNcNGJcs/hiRByrV30/ZdGis3VNAyw9
         yI+Z2HoZtPylgGSuhQx2J2dvN3C48iBiRVrPidjqp0PcBsab7bYQQuIT2VjH547Bk2Wk
         BrnNKn4ov3dc3sGCIujGY0SrfbukdK1+09mXg78G2prPr1gXpbQbmVsIqMDGPqmHKkOW
         Ud1+fNpSk8xKuSZyxM6X6VBkdvwtycndY1BzCEIIR6Fl5xxeWtM/bDbs/0AiM2TKidzC
         8HW6Y4i7uwIg8MiQ0qM2sAPzgpeyvn1j66+N0hJFlMPNIGpoPgckcQXRcbo5GwFixE2E
         BJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mYbGNAbVxfg8sZIbwCbxi5At7Ar3E4jfEniJRUqCtIM=;
        b=cStZgdHn8tOTAaFOUj+oK9q07uKdOR/LK1hW3WHdw4mkV4RTxfKl3gKnVreW/f2ZBr
         CBDKtLu7h6BBrn8tJHsxVsG17suu1aS55j8XBTQbJOovz2owQMoIc5GOisVtFiz5KLmF
         Mf5zHZeYJmnaTDM3DeT7Rn+EWXnvGnrp/RIITvXwNhmOMM+XarQTkNX+CEEKOmWuheXJ
         taGsKBtmP5V+JFHwijWuxzI/+AD0/PYijQ2jmc77ibfMNbB+RYYoG+SEuAM6sryAxoNC
         KL7/3XGkYVsENBXbzU3sPYRKnt2uzGKcIXLhIY3slnqJhitfNt54Rv+x7cxWtWSHFWnn
         psFA==
X-Gm-Message-State: APjAAAVNt2fKROQ+hiIrAFqEktfN+SlY7rvaS/Q77Z6Z1ePQF5X/8VdE
        kFs65c+NkyPR04O4hQoTYxViaw==
X-Google-Smtp-Source: APXvYqyGD8Ydzc/VhLM38Lr/LoCimIQa1M+Rd7fk8Bknew4mUtfI+O5R6d/9W0BCUBWQ0EdGc7xn2g==
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr2281421wmi.91.1565691637926;
        Tue, 13 Aug 2019 03:20:37 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id g8sm1461011wmf.17.2019.08.13.03.20.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 03:20:37 -0700 (PDT)
Date:   Tue, 13 Aug 2019 12:20:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 4/4] devlink: Add man page for
 devlink-trap
Message-ID: <20190813102037.GP2428@nanopsycho>
References: <20190813083143.13509-1-idosch@idosch.org>
 <20190813083143.13509-5-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813083143.13509-5-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 10:31:43AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> man/man8/devlink-monitor.8 |   3 +-
> man/man8/devlink-trap.8    | 138 +++++++++++++++++++++++++++++++++++++
> man/man8/devlink.8         |  11 ++-
> 3 files changed, 150 insertions(+), 2 deletions(-)
> create mode 100644 man/man8/devlink-trap.8
>
>diff --git a/man/man8/devlink-monitor.8 b/man/man8/devlink-monitor.8
>index 13fe641dc8f5..fffab3a4ce88 100644
>--- a/man/man8/devlink-monitor.8
>+++ b/man/man8/devlink-monitor.8
>@@ -21,7 +21,7 @@ command is the first in the command line and then the object list.
> .I OBJECT-LIST
> is the list of object types that we want to monitor.
> It may contain
>-.BR dev ", " port ".
>+.BR dev ", " port ", " trap ", " trap-group .

Looks like "trap-group" is a leftover here, isn't it?


> 
> .B devlink
> opens Devlink Netlink socket, listens on it and dumps state changes.
>@@ -31,6 +31,7 @@ opens Devlink Netlink socket, listens on it and dumps state changes.
> .BR devlink-dev (8),
> .BR devlink-sb (8),
> .BR devlink-port (8),
>+.BR devlink-trap (8),
> .br
> 
> .SH AUTHOR
>diff --git a/man/man8/devlink-trap.8 b/man/man8/devlink-trap.8
>new file mode 100644
>index 000000000000..4f079eb86d7b
>--- /dev/null
>+++ b/man/man8/devlink-trap.8
>@@ -0,0 +1,138 @@
>+.TH DEVLINK\-TRAP 8 "2 August 2019" "iproute2" "Linux"
>+.SH NAME
>+devlink-trap \- devlink trap configuration
>+.SH SYNOPSIS
>+.sp
>+.ad l
>+.in +8
>+.ti -8
>+.B devlink
>+.RI "[ " OPTIONS " ]"
>+.B trap
>+.RI "{ " COMMAND " |"
>+.BR help " }"
>+.sp
>+
>+.ti -8
>+.IR OPTIONS " := { "
>+\fB\-v\fR[\fIerbose\fR] |
>+\fB\-s\fR[\fItatistics\fR] }

Not sure you need to put generic option here. But I don't mind much.

Otherwise this looks fine.
Acked-by: Jiri Pirko <jiri@mellanox.com>

[...]
