Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98A92CDDB1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgLCScg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgLCScf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:32:35 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826EDC061A4E;
        Thu,  3 Dec 2020 10:31:55 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h7so2465796pjk.1;
        Thu, 03 Dec 2020 10:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+tzV8UtTzNnOOEopInN4rCKTSSxJMVPmFjV1HZa30S4=;
        b=HBKSkdK48QtSJwqsilNsz4Pn6dUZ2VssLcMWW3zmYTUxtIAN3hR478Q6j9pSZ73c2c
         angjvNwZKHUSfNbSIRWEEJgTRtrwey0yzlFgyB0n9rojgRuH4D72KZVrZ5POxhNaw007
         94BvijAV7enqHb/0Yv6IOqII7ry8mdG9fmjE2efwFBgRd/Td82CTdEenx9wgxCIeXEou
         cF45/sOswbGfxe1QxSC3TgIM0gThDCgeZBkNu+WOs1WdBgBMzpM8BuXG2Xn7q5keBO3t
         QpAfsa/Q5ZOt6OfgvYEpxCDJzX9/imtTRmlUYJsDYJ6bqvDwP8zkaQdWieenXSYutM0a
         zoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+tzV8UtTzNnOOEopInN4rCKTSSxJMVPmFjV1HZa30S4=;
        b=QqgfT4L92vAFoVvRpJJTVVW19krTYNIACb912Henuh97kZpl4V3X7pPJp2pWzw62VY
         eRCS0W78daXPxPxdG8xu/Hd3LaLrq6/xLLH6Eiui+gcY0GDJnWmtTWPcth72eYEYuQWf
         fsgr7QJ8SHL2cyq3Y3luWiHvm9G6lgXknJz1irVTn4eFlrROK9QzPprbxQTdlbjY37O7
         E5HlMHx+7c4KYsij0O6nz87CFZayEDH627dsjI58GAu9oE5YB/54jS+rmdPlpNnjafWY
         B256V8aIs8Ft6ihstV+s/1edQqQmIVXAs+grgJdvc6x9PEz9h4bItzPTiMdCQssdb06H
         Z+Hw==
X-Gm-Message-State: AOAM53216JiRU3pYrA77uZPj2lKgxiIA0hfL12Xj5AAlJIz5iRrVQSGj
        slPQeFGNBTV4j7RzSYIXIRc=
X-Google-Smtp-Source: ABdhPJz9VAExBWizk9YFbLui4xj0gU97WXlN4X92U1vQIYm1Vn/C5JftazTDB2ATQ18jjidmm1ajlw==
X-Received: by 2002:a17:90b:3594:: with SMTP id mm20mr380615pjb.121.1607020314920;
        Thu, 03 Dec 2020 10:31:54 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:a629])
        by smtp.gmail.com with ESMTPSA id j10sm1786175pgc.85.2020.12.03.10.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 10:31:54 -0800 (PST)
Date:   Thu, 3 Dec 2020 10:31:52 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/3] bpftool: improve split BTF support
Message-ID: <20201203183152.eywr26oezaljvovv@ast-mbp>
References: <20201202065244.530571-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202065244.530571-1-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 10:52:40PM -0800, Andrii Nakryiko wrote:
> Few follow up improvements to bpftool for split BTF support:
>   - emit "name <anon>" for non-named BTFs in `bpftool btf show` command;
>   - when dumping /sys/kernel/btf/<module> use /sys/kernel/btf/vmlinux as the
>     base BTF, unless base BTF is explicitly specified with -B flag.
> 
> This patch set also adds btf__base_btf() getter to access base BTF of the
> struct btf.

Applied, Thanks
