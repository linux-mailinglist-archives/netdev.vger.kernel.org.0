Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7092A194392
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgCZPw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:52:26 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53531 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbgCZPw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:52:26 -0400
Received: by mail-pj1-f67.google.com with SMTP id l36so2637237pjb.3;
        Thu, 26 Mar 2020 08:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Cu2h+YcrIqDJjOVWrcg9qh9LpRYfxDF53j5qt17OgDg=;
        b=ZpNCpuWZ1eSy5xaFqAzytGomXpY7T6zoCAEDuqCdM/QnB8FEHI+Np/oVS8KtCcplt6
         Nw3z8OSJ6Ns2Gxv+36EFFbxc7cdWM7+3MOLTvhCwvIFVryOst5CRoVr500EcYGcJn0GH
         EGoW3jmYYml74SyfKTAkCzs1vRup5X2cJHpiNUzuDnD+VRVG6V6IrPb4yN1Z18s3kFd9
         VzSAKjzG9Ex4qzgywFX+B1Ildm0SQDwLgRF4RyTg3DLTMDjjPPnsBLzYw9SxWjKo0U4n
         5Hx8+3QqWFNxUeYmEFGs/qpDWUWhbffJOPwzzD1/g76i7s2hwMO41+DBFtbTzjanUwk4
         t22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Cu2h+YcrIqDJjOVWrcg9qh9LpRYfxDF53j5qt17OgDg=;
        b=Yd7lRRh5Q6Z8gXT4/vhBNrhmVGdBpuVIsUzUupBEieadTaF3CXjcaaRKJhtQsFtty0
         kJHokwnY9DQMRoKCVzzqsiHkqPcaUHTzPxUX4bHiwlb0Ibdkep7L+3gzdLdcXbGZ7Bqe
         3O0LSu9P1MBGbcM647yLwKn/81OcUOOrUO7acmQQluiGbeaeJLuOPLDrFXO4qzmhkOVL
         7ox1PIsGXrOgSvNtBAJCMwUk/MKJedYiYv9GxsHyc+ZAmr9HrgDSNIgkAzdfKvzN20Q6
         JkGfKM2Utug0iYB/Zsm/LDvt06giJf3akzGuDfeAQSN4xFYvCiKwtqi9cYufdeEm9Jn1
         JDfg==
X-Gm-Message-State: ANhLgQ1wb+EdFBccXAk3fLarTZphbIuzJ58LFZaJD0NeexqA/WTOiY32
        DQJFkQ3m5zq5OqJ2tQc42Gc=
X-Google-Smtp-Source: ADFU+vvobQjrEUNfhNe6x6YveJ/MhPXKkPyTF2aUoNHOWe2uLqdm9w4HnO6hFY7KULhNtPblAlBe3Q==
X-Received: by 2002:a17:902:b40e:: with SMTP id x14mr8090137plr.319.1585237945470;
        Thu, 26 Mar 2020 08:52:25 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g30sm1956366pgn.40.2020.03.26.08.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 08:52:24 -0700 (PDT)
Date:   Thu, 26 Mar 2020 08:52:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e7ccfaf79433_65132acbbe7fc5c4eb@john-XPS-13-9370.notmuch>
In-Reply-To: <20200326062301.fvomwkz5grg3b5qb@ast-mbp>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
 <158507155667.15666.4189866174878249746.stgit@john-Precision-5820-Tower>
 <20200326062301.fvomwkz5grg3b5qb@ast-mbp>
Subject: Re: [bpf-next PATCH 05/10] bpf: verifier, return value is an int in
 do_refine_retval_range
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Mar 24, 2020 at 10:39:16AM -0700, John Fastabend wrote:
> > Mark 32-bit subreg region with max value because do_refine_retval_range()
> > catches functions with int return type (We will assume here that int is
> > a 32-bit type). Marking 64-bit region could be dangerous if upper bits
> > are not zero which could be possible.
> > 
> > Two reasons to pull this out of original patch. First it makes the original
> > fix impossible to backport. And second I've not seen this as being problematic
> > in practice unlike the other case.
> > 
> > Fixes: 849fa50662fbc ("bpf/verifier: refine retval R0 state for bpf_get_stack helper")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  kernel/bpf/verifier.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 6372fa4..3731109 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -4328,7 +4328,7 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
> >  	     func_id != BPF_FUNC_probe_read_str))
> >  		return;
> >  
> > -	ret_reg->smax_value = meta->msize_max_value;
> > +	ret_reg->s32_max_value = meta->msize_max_value;
> 
> I think this is not correct.
> These two special helpers are invoked via BPF_CALL_x() which has u64 return value.
> So despite having 'int' return in bpf_helper_defs.h the upper 32-bit will be correct.
> I think this patch should do:
> ret_reg->smax_value = meta->msize_max_value;
> ret_reg->s32_max_value = meta->msize_max_value;

OK, I missed the u64 in BPF_CALL_x(). Setting both smax and s32_max
looks correct.  My logic above is wrong so I'll fix that. Thanks.
