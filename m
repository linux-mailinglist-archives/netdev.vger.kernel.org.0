Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F1E96DAF
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfHTXW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:22:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35059 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfHTXW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 19:22:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so184977pgv.2;
        Tue, 20 Aug 2019 16:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7q77S2d0XkJTsvieSIJBD7HqwVZVOkVs4YFNfBSPmG0=;
        b=C7fnNTjlLwKJclqKABnQf3bM/Xwqa2xmx0q4o8iXOtAz6+TDAQqB1nzn+1B+LKRcHe
         CPNlg8ofGhEmXvZRCY3Xh4t8AyNdgDHB7MZLG8y1/AoUMoGT4E5khjwY+xGKnqhsyoK9
         tJdbcfa6+4nZu5BEAaHrR0a/+ZJys3dqFmtRarQJL0tEq9LyPmtTLfS2g8QCSKWgmb5r
         2zAA9YiJ4C+MPxaV/0BSFjpJx8yAgkwLHNg5RcLrt8KqDAET5F6V0YBBsBmhM8bXeEGg
         Psxn6Otmy3LXPL8OS/8IQqCWpl1lzUVfRXQm5OflOK8nunH28n7FF3VOgBAmbGJbAjum
         gqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7q77S2d0XkJTsvieSIJBD7HqwVZVOkVs4YFNfBSPmG0=;
        b=s2RXb2X8B2yPBtMPbdpmdB3gQQDiqNc+wTfgg3/DVzpX6nMpawhxDTk1XmSzBJpRx1
         R83k3D/H+VecRV2znyHYwDp0ABp7+JgrSQev2d4JxAgt4Ur6W7SY1LTV/2rYP3i2mHr+
         +DnRdzbYzbMWJGC/K7pt79gAqSW4vQV1S2CRsKyCtTuCexKuKjbKW88oLCwfISY8dSuS
         WBvJ4JISMkYwJBWViqX8JsKqWfnwDKO46gw6if9MoaDzRJ+NMjw1KKJoF9OBQuVIZgWc
         6ST1slNpp7Ko9e2NJPo1jvwZ125Ng0AEgL8u5g8JqM4E5+tV9A77i/WViloof+D8rS0N
         lhGQ==
X-Gm-Message-State: APjAAAUicK9UUc/7goacY7cu8VeOrF5gvgmEb56bUs4qevq3X9KGgMt3
        iiWZbyUyIgZJoj4lBbKf9WCP+AWK
X-Google-Smtp-Source: APXvYqxqKkAcWA6UVU5MSq/7uhV7kKsWVbCmpTYiCC+Wd258Zqt7anKn/r/WDLw22xA/lStvSiBuuA==
X-Received: by 2002:a65:4489:: with SMTP id l9mr27523695pgq.207.1566343345156;
        Tue, 20 Aug 2019 16:22:25 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3efc])
        by smtp.gmail.com with ESMTPSA id t4sm36281050pfq.153.2019.08.20.16.22.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 16:22:24 -0700 (PDT)
Date:   Tue, 20 Aug 2019 16:22:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Peter Wu <peter@lekensteyn.nl>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 3/4] bpf: clarify when bpf_trace_printk discards lines
Message-ID: <20190820232221.vzxemergvzy3bg4j@ast-mbp>
References: <20190820230900.23445-1-peter@lekensteyn.nl>
 <20190820230900.23445-4-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820230900.23445-4-peter@lekensteyn.nl>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 12:08:59AM +0100, Peter Wu wrote:
> I opened /sys/kernel/tracing/trace once and kept reading from it.
> bpf_trace_printk somehow did not seem to work, no entries were appended
> to that trace file. It turns out that tracing is disabled when that file
> is open. Save the next person some time and document this.
> 
> The trace file is described in Documentation/trace/ftrace.rst, however
> the implication "tracing is disabled" did not immediate translate to
> "bpf_trace_printk silently discards entries".
> 
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  include/uapi/linux/bpf.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 9ca333c3ce91..e4236e357ed9 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -575,6 +575,8 @@ union bpf_attr {
>   * 		limited to five).
>   *
>   * 		Each time the helper is called, it appends a line to the trace.
> + * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
> + * 		open, use *\/sys/kernel/debug/tracing/trace_pipe* to avoid this.

that's not quite correct.
Having 'trace' file open doesn't discard lines.
I think this type of comment in uapi header makes more confusion than helps.

