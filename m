Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136113A10DE
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238622AbhFIKKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:10:31 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:45831 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbhFIKK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:10:29 -0400
Received: by mail-wm1-f50.google.com with SMTP id v206-20020a1cded70000b02901a586d3fa23so3801242wmg.4
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b8u0rX97Dk3flLWGHgE6c+hxtXn+4S8L4WYFaY8AsBg=;
        b=vssOc5YtJYTHeRdhthPCbYwqfK7uNexQqjWMeTrBTd40usYVAEHdr+kiZUbCrlHiEs
         XIVu1n1wCTa+YiqkbdN6VpO5XrOb1CqcIV4HLuqLGjCYetkTKi1ohTauGWq9AbAZvUAn
         NOos3y6x8N6POBHT71y/QTeWczi6ruWS3n+ZGzqeS1gO3Lg8AjZygs1eoF2bl/60pF3k
         mlTViN2A3dsVUegVc0TGrjKEEgK5ucpDeZyyXprUCxirMQJRtzq/UmCGdHx5I7e9uHzT
         p9rnkN/3cl7rFsNC0lBjhe4LEMfHITquVsEnxczVGFf7r0wkRg/m0RPoC9ICpI/05u8t
         LQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b8u0rX97Dk3flLWGHgE6c+hxtXn+4S8L4WYFaY8AsBg=;
        b=p0J9AiRfbZF3fmogIt111RvpDLLcKgnJonBQPEVaUWSgUQ04RYnOYYVq9epOx4Ywsf
         94PjRCLeGG5liYv0F4zk+8Y39AD/I7xJ7wzgq60hOddVW5kM24l8STTNeX+Qxvfeo34f
         6gO0YFVj44uXa8uglZRlqFcqbzK+t1oA0ARsbCpxlHVSGgf2P7tvEIwgitZgN1WqrlS+
         qJRP/nOFZ2+aCZop3QDyeTLAPZOtvSowYKizVIKZ47v7DX9gEkac4Trygns7S327vQU+
         Qgf0sepwtW9as3echboJ+TE4xjM9x8TV9Wzzvm1EVuVX7KesiGIn13sGYae7EsD3+r+f
         aZyw==
X-Gm-Message-State: AOAM5327rZIgBjDM7j0LUc0wUYo8ekXv6IButByTRTDdng5MVQnK6+kb
        sVncV5grGUDQhhzEnyF9XesRzQ==
X-Google-Smtp-Source: ABdhPJxci5LtQsbf5Fv5OYnzv9ecWERntUMRflc0/hs3X0mxwABcseXkCO/wtjKt77STUODGO6GjOA==
X-Received: by 2002:a7b:c193:: with SMTP id y19mr27303560wmi.172.1623233253922;
        Wed, 09 Jun 2021 03:07:33 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id v16sm23017717wrr.6.2021.06.09.03.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:07:33 -0700 (PDT)
Date:   Wed, 9 Jun 2021 14:07:29 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, davem@davemloft.net,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, rdna@fb.com
Subject: Re: [PATCH bpf-next v1 03/10] tools: Add bpfilter usermode helper
 header
Message-ID: <20210609100729.2bsn47jvsg4s77z4@amnesia>
References: <20210603101425.560384-1-me@ubique.spb.ru>
 <20210603101425.560384-4-me@ubique.spb.ru>
 <6cced642-6342-4711-9f04-636e6903d60b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cced642-6342-4711-9f04-636e6903d60b@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 09:20:12AM -0700, Yonghong Song wrote:
> 
> 
> On 6/3/21 3:14 AM, Dmitrii Banshchikov wrote:
> > The header will be used in bpfilter usermode helper test infrastructure.
> > 
> > Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> > ---
> >   tools/include/uapi/linux/bpfilter.h | 179 ++++++++++++++++++++++++++++
> >   1 file changed, 179 insertions(+)
> >   create mode 100644 tools/include/uapi/linux/bpfilter.h
> > 
> > diff --git a/tools/include/uapi/linux/bpfilter.h b/tools/include/uapi/linux/bpfilter.h
> > new file mode 100644
> > index 000000000000..8b49d81f81c8
> > --- /dev/null
> > +++ b/tools/include/uapi/linux/bpfilter.h
> > @@ -0,0 +1,179 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_LINUX_BPFILTER_H
> > +#define _UAPI_LINUX_BPFILTER_H
> > +
> > +#include <linux/if.h>
> > +#include <linux/const.h>
> > +
> > +#define BPFILTER_FUNCTION_MAXNAMELEN    30
> > +#define BPFILTER_EXTENSION_MAXNAMELEN   29
> > +
> > +#define BPFILTER_STANDARD_TARGET        ""
> > +#define BPFILTER_ERROR_TARGET           "ERROR"
> > +
> > +
> > +#define BPFILTER_ALIGN(__X) __ALIGN_KERNEL(__X, __alignof__(__u64))
> 
> The difference between include/uapi/linux/bpfilter.h and
> tools/include/uapi/linux/bpfilter.h is the above "define".
> Can we put the above define in include/uapi/linux/bpfilter.h as well
> so in the commit message we can say tools/include/uapi/linux/bpfilter.h
> is a copy of include/uapi/linux/bpfilter.h?

Actually it seems that it is possible to drop this define as
XT_ALIGN is used now instead of BPFILTER_ALIGN.
I will remove the define and reword the message.
Thank you.

> 
> > +
> > +enum {
> > +	BPFILTER_IPT_SO_SET_REPLACE = 64,
> > +	BPFILTER_IPT_SO_SET_ADD_COUNTERS = 65,
> > +	BPFILTER_IPT_SET_MAX,
> > +};
> > +
> [...]

-- 

Dmitrii Banshchikov
