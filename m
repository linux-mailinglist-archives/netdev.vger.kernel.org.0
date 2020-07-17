Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848D72237E7
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 11:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGQJLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 05:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgGQJLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 05:11:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A20C061755;
        Fri, 17 Jul 2020 02:11:22 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j19so6371213pgm.11;
        Fri, 17 Jul 2020 02:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ezXQf/TJN6LBMDm8b99XbeEZAEal6UOCFS75KoG6QGY=;
        b=dMVBiXyTIEly/bsgLGmfm58X7ypBv+VPVB2iIKHySNnwGYKlTiZ0FCmu1jrnYa4kg9
         WQFtlkY8wrN3vP7ykedPdP7OleglFUvs79fUrqjAWEBKLlWWLFd8HMJwZUYOBQ+DkZhX
         cwKN/Ux2HqI37MslHMlji3B5ZZTRiIW/tfoL0+O2Lk5pTIdQcdj9XXeiAJV/73ZLFDn1
         4v6T3VHCZmhSS/TDg5DhhVxm5/oVUPkI6sp9kUZXajmPEmhCCotNA6xIE1080LznM97Y
         IHlCrScEzGbjDQy1vZCKIVVCA7CbIOjgsh692c75YjkuLHxXbSkuSx04RiJLE/MIPp2d
         HD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ezXQf/TJN6LBMDm8b99XbeEZAEal6UOCFS75KoG6QGY=;
        b=LV2FDFHow4bECT4xf1GvqNgJDb1UC73CmgjVvqF4RiiBZiZBLEp809Ikk6RPXATGZL
         X2LujWpHdhHl45tHsZDRi0lfqzkjqWIG1sbEUVxiPCTLUjYvPHaop1+POXynkMzpzm4o
         J6IeDPLzgTK70tpq1WxBBaBzW/Fa60aRq2yBMhVeb+i9+0HqNgNXOAZ4ZCaG5VP3sRDK
         COZhpWn2jnRP+1myZ150NDOzuk0UIRuMI7KTGCXi0jaqcaIx9V+esyN/rGXBivZXzSne
         zF0Gm5VISKH6cQ0WrMEWI6RjQk7BWyWAebynlwwkzYhj7OAJs8D3674TwYNhfj0GxetW
         d4/w==
X-Gm-Message-State: AOAM532orxQgWbEIdarrl1ml21rf+1f87GNkJHATqhIXMfsWxmIhwZH4
        6HEzQXdM6+4zMsKriN5pZDc=
X-Google-Smtp-Source: ABdhPJx//EszmOXWM7tfBJxFn8OLFCe87yHCBp7Xw5uXaHmNZ0NfGySDeOSqS0dD7tcGwzSg58Lygw==
X-Received: by 2002:a65:6447:: with SMTP id s7mr8002774pgv.320.1594977082288;
        Fri, 17 Jul 2020 02:11:22 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nh14sm2130174pjb.4.2020.07.17.02.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 02:11:21 -0700 (PDT)
Date:   Fri, 17 Jul 2020 17:11:11 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, ast@kernel.org
Subject: Re: [PATCH bpf-next] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
Message-ID: <20200717091111.GJ2531@dhcp-12-153.nay.redhat.com>
References: <20200715070001.2048207-1-liuhangbin@gmail.com>
 <67a68a77-f287-1bb1-3221-24e8b3351958@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67a68a77-f287-1bb1-3221-24e8b3351958@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 12:28:16AM +0200, Daniel Borkmann wrote:
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index c67c88ad35f8..9d4dbef3c943 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -253,6 +253,7 @@ enum bpf_arg_type {
> >   	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
> >   	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
> >   	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
> > +	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
> >   };
> In combination with the set, this also needs test_verifier selftests in order to
> exercise BPF insn snippets for the good & [expected] bad case.

Hi Daniel,

I just come up with a question, how should I test it without no bpf
helper using it? Should I wait until the XDP multicast patch set merged?

Thanks
Hangbin
