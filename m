Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF701F9216
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgFOIql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728522AbgFOIqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 04:46:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745E5C061A0E;
        Mon, 15 Jun 2020 01:46:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d6so6816820pjs.3;
        Mon, 15 Jun 2020 01:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PoQuDBLVerIFsyeOrRYivdKprTNwZdkziJjAXlvOpHs=;
        b=uGemWnUr5a+aV+QRa5R7JLUWuM6IeW1O4Oj5dyoTI5Ukvd1OxUt06TySfw1R8WB1+c
         kPKr+UiTGmsRqUmVlpLSjS09nHvIz+LnQa+rYHhPsx9Paii6X8QHBFmVOycdyLdRap+f
         H5+MCSjUHed5Zkor1NpVB2g3Q4zsOZnfWXmZ5JpWVu0f05PC+HWOeXoWRMrzHHT+a7Fy
         dhyGnWRsq7zyyBuhsIEqD7AvvCQJ8wFIn/C64TCI2+ZrvxgjEzz0iFQLmO5hTzjVOo2q
         SZ7BsxX7f3SASYZr9HT4NV8+t+T5hiT6Lvi3KHZxP+Nn9Xm2Hdgkxd8lG8x+sz05MDuS
         5suQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PoQuDBLVerIFsyeOrRYivdKprTNwZdkziJjAXlvOpHs=;
        b=XqHDgH6tgfyHF7j0c9/bEgQiSc22wc9Yr/utRe5uMEdZfksjSnEgtSFLE34TiJTjRA
         Uz7oWz3wlVdrMHk/aJ2k/mMnpx91Ul3XcgpAZJaVl4vriUZq3WYSRuQIbUtm5R/MTlQ+
         ALTsNavWba3R1AL1DwNLJHNUKqm1TCc3P/sYG7g2Vi1aUN3Vd2n/jDu/MBsmYOC5+FmC
         fiUHDrHMaoAdcIQVABOZn56+Ura/OXGL3yqhq9WYZ+6LjcyQqFFACYLGQ/xTKRwwJ4Y0
         MNqNC3qY4gctO0I3xb9rSwvDVgg4MuUS+I8rjWz/UdU8qa+bxEpZkqbBcgd9bgv/PH7T
         aFSw==
X-Gm-Message-State: AOAM531E7agq6oMyIJ8097XQ51AoYT4Lj/uk4rpmdyUaGamclollaoKz
        BziarfnJqkiAiD8aMXTZ8OgK8XFg/WQ=
X-Google-Smtp-Source: ABdhPJxxQ+KSm/w/7fwle3f0igl0C8/pwR1U3EUmiS3lGr9sGh0pVd5PtmcyeW9hycCCc2VixFd3Cg==
X-Received: by 2002:a17:90a:f694:: with SMTP id cl20mr11418607pjb.141.1592210798043;
        Mon, 15 Jun 2020 01:46:38 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id l63sm13544430pfd.122.2020.06.15.01.46.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 01:46:37 -0700 (PDT)
Date:   Mon, 15 Jun 2020 16:44:25 +0800
From:   Geliang Tang <geliangtang@gmail.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: unify MPTCP_PM_MAX_ADDR and MPTCP_PM_ADDR_MAX
Message-ID: <20200615084425.GA29964@OptiPlex>
References: <463f48a4f92aa403453d30a801259c68fda15387.1591939496.git.geliangtang@gmail.com>
 <2638593d-82bd-73be-8ff1-3a4a7d4d5968@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2638593d-82bd-73be-8ff1-3a4a7d4d5968@tessares.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 07:33:11PM +0200, Matthieu Baerts wrote:
> Hi Geliang,
> 
> On 12/06/2020 07:27, Geliang Tang wrote:
> > Unify these two duplicate macros into 8.
> 
> Thank you for this new patch!
> 
> (...)
> 
> > diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> > index 809687d3f410..86d265500cf6 100644
> > --- a/net/mptcp/protocol.h
> > +++ b/net/mptcp/protocol.h
> > @@ -135,7 +135,7 @@ static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
> >   		     ((nib & 0xF) << 8) | field);
> >   }
> > -#define MPTCP_PM_MAX_ADDR	4
> > +#define MPTCP_PM_ADDR_MAX	8
> 
> I think it would be better to drop MPTCP_PM_MAX_ADDR and keep
> MPTCP_PM_ADDR_MAX in pm_netlink.c where it is used. Each PM can decide
> what's the maximum number of addresses it can support.
> 
> MPTCP_PM_MAX_ADDR seems to be a left over from a previous implementation of
> a PM that has not been upstreamed but replaced by the Netlink PM later.
> 
> Also, please always add "net" or "net-next" prefix in the subject of your
> email to help -net maintainers. Do not hesitate to look at the netdev FAQ
> for more details.
> 
> Here this patch looks like a fix so you should have [PATCH net] and a
> "Fixes" tag. I guess for this patch you can use:
> 
>   Fixes: 1b1c7a0ef7f3 ("mptcp: Add path manager interface")
> 
> That's where MPTCP_PM_MAX_ADDR has been introduced. It was already not used
> and never used later.
> 
> Cheers,
> Matt
> -- 
> Tessares | Belgium | Hybrid Access Solutions
> www.tessares.net

Hi Matt,

Thanks for your reply.
I have already resend patch v2 to you.

-Geliang
