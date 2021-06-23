Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C7A3B144A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhFWHAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 03:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhFWHAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 03:00:08 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1063FC061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 23:57:50 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id t17so2408719lfq.0
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 23:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Li+V/nl0cjsmLCz3l8a0QSOYRkjhsF2wxz4QKN56JeA=;
        b=i5fK+QNObEpMsmez8iNU9Z7+pSSG5iVFOyr20YhUpBF/j/ptXb6Jl9lDNI9g4LPKf/
         j7vHCw4red5E2ujeVTez80m3wnMzA1xhbKuANkDeF6ePQasvLZBZpB2YUWCaN54JfwbY
         amBVPmqmKWeF+r2b6lMgrtY7CGPffoV8Ddds+dIZjtGiTZSYZbNRIbC42fZNAJU8rBTm
         +8TW9yfSd1M9Yx6f+TpPLvdsjDvDe2eqT8SYw5YSQgmXxNPtLG6CsigqhTFoSKc30gMR
         1fi4NSA24FGOfsPs/9CjSXdcSFkykXfGAj9S8w+0dQUwVGkNtPYN/mXdJDACkZHYG7b0
         9jNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Li+V/nl0cjsmLCz3l8a0QSOYRkjhsF2wxz4QKN56JeA=;
        b=EPtw5Ddr5/4JSg7K3aXNsYpW7NUSZQx3Im5aA/j2oGtxMEsGu+VQl8tJ0B0faxDmGC
         R/PBpBrGkDzm/geTprA+MvFJIkVkKnxABpTr2/QJx795yjEWYZxLObrsyW3Wlmm3h++W
         WKa0qneBUNjp7kQk+c19QCRjUSK+8xSTlmHS5nxsY+s35Tsj5JUxwDiR6mc4yZcYUJTw
         ODhwEYkfzAF5oyHD6oSfYz4jOJtslZ/Qv8UwP5dH67cH9jHcYL5DPKODexQVNwYUuSwz
         9/K/4ZQXZ4gEihmhpRX+j0Bb3gWfMI+DI7SKqYpRmEIQ2eDxpYzxqUScgBNTdBeGW8r6
         zioA==
X-Gm-Message-State: AOAM53364/XR1My4mx29VEvSI7PtqtE4+PNsuY5z8HK57v9en2zqqel7
        SJnhPF4FJq9FsH0b4rDIYudAxg==
X-Google-Smtp-Source: ABdhPJwh+g+jkKtyGUasqYD3sa5fnzHls6A7Kp/p8RCTaAEbbEXm6SoOV1s1BrRUZQUekxjrJrq0sQ==
X-Received: by 2002:a05:6512:320f:: with SMTP id d15mr6148126lfe.266.1624431468426;
        Tue, 22 Jun 2021 23:57:48 -0700 (PDT)
Received: from localhost ([45.137.113.63])
        by smtp.gmail.com with ESMTPSA id i26sm2311248lfv.164.2021.06.22.23.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 23:57:47 -0700 (PDT)
Date:   Wed, 23 Jun 2021 10:57:44 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Gary Lin <glin@suse.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin Loviska <mloviska@suse.com>
Subject: Re: [PATCH bpf] net/bpfilter: specify the log level for the kmsg
 message
Message-ID: <20210623065744.igawwy424y2zy26t@amnesia>
References: <20210623040918.8683-1-glin@suse.com>
 <CAADnVQLpN993VpnPkTUxXpBMZtS6+h4CVruH33zbw-BLWj41-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLpN993VpnPkTUxXpBMZtS6+h4CVruH33zbw-BLWj41-A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 09:38:38PM -0700, Alexei Starovoitov wrote:
> On Tue, Jun 22, 2021 at 9:09 PM Gary Lin <glin@suse.com> wrote:
> >
> > Per the kmsg document(*), if we don't specify the log level with a
> > prefix "<N>" in the message string, the default log level will be
> > applied to the message. Since the default level could be warning(4),
> > this would make the log utility such as journalctl treat the message,
> > "Started bpfilter", as a warning. To avoid confusion, this commit adds
> > the prefix "<5>" to make the message always a notice.
> >
> > (*) https://www.kernel.org/doc/Documentation/ABI/testing/dev-kmsg
> >
> > Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
> > Reported-by: Martin Loviska <mloviska@suse.com>
> > Signed-off-by: Gary Lin <glin@suse.com>
> > ---
> >  net/bpfilter/main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
> > index 05e1cfc1e5cd..291a92546246 100644
> > --- a/net/bpfilter/main.c
> > +++ b/net/bpfilter/main.c
> > @@ -57,7 +57,7 @@ int main(void)
> >  {
> >         debug_f = fopen("/dev/kmsg", "w");
> >         setvbuf(debug_f, 0, _IOLBF, 0);
> > -       fprintf(debug_f, "Started bpfilter\n");
> > +       fprintf(debug_f, "<5>Started bpfilter\n");
> >         loop();
> >         fclose(debug_f);
> >         return 0;
> 
> Adding Dmitrii who is redesigning the whole bpfilter.

Thanks. The same logic already exists in the bpfilter v1 patchset
- [1].

1. https://lore.kernel.org/bpf/c72bac57-84a0-ac4c-8bd8-08758715118e@fb.com/T/#mb36e20c4e5e4a70746bd50a109b1630687990214



-- 

Dmitrii Banshchikov
