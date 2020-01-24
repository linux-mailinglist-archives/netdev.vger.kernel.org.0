Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7D4148EE3
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391672AbgAXTvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:51:03 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44952 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388136AbgAXTvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 14:51:03 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so1636210pgl.11;
        Fri, 24 Jan 2020 11:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FTl3tMgOJleUeTXjL47OVwdU9mZx0RCQU/G9/ZS/7CA=;
        b=TmokgE0FYDDv1w1Aui2sIKy3k6viFhFjnTdPCyvT9tCC3fJgqNHP+DvuVnFhK235kh
         TDBMeMRoN4kUjHFpIqB9mTmKombLIFPreY2F9ZEuL4UV6s8gP4HbOPDDSWtVh5wMHXJw
         Fk+HlOdBmbPXuWsauAnhHOZXG51X3gpQnLKeLoBBajGpTUUIv0bHluqhSzjk5E7TrHgx
         LwcloEwWRwifEVPeOa8TuhYHeSxCTDIqsvELGdRL6/29xsXBfpWU++9HV7A94E/Pw43F
         xqh/V+bEIyFLRX/RrOPJQE2h5waZorGXm/kWCBXH801pixD1+/kLcmspqBvULV3zc0pb
         frDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FTl3tMgOJleUeTXjL47OVwdU9mZx0RCQU/G9/ZS/7CA=;
        b=rfxjrMHKAPcz7P87werCO622Q4ikxjKTNOb78cbTL9RvbbqudE3qDSiU7CyQm2P9+U
         Lju9pC2QozoNXZzpQYkRKJgsHcL3Vz/XrwRhiNgfuypPPvGKE37Dw3PYLYnBPnkX2yCj
         G2m2ZcD44eJSQNg+2+Z05HkNc9FTkpQNroxGAulNw417ctOwnDC3zeObCsl2d6I/CK+G
         AgytKxiMPMHgm/xPPKiczq8DMYQdSOik3uZLuNotpuuWjLtTp5pVqPyPn9SVEF7AGyv3
         rnXkV8RP9nj5+vI8yA6pWLwVprndrfNGr2r9XN5zQI1dzfH8SseOEMW+k5+ny/qJ/WeS
         gIKw==
X-Gm-Message-State: APjAAAXky0df7mUueXWks8ikJdk6fPL8MmW7D7sCv+i89JvKAGTKTjNL
        4W9Yqtp7UYmk3Jjueso1FD4=
X-Google-Smtp-Source: APXvYqzEDh92A+dPDJQzW9k9TeaoLrhM0SExEb29iTV6mc7e6uHUO3W+iaVNUiPvZBBpMiQRKwaGhQ==
X-Received: by 2002:a63:4303:: with SMTP id q3mr5809403pga.439.1579895462283;
        Fri, 24 Jan 2020 11:51:02 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e1sm7278157pfl.98.2020.01.24.11.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 11:51:01 -0800 (PST)
Date:   Fri, 24 Jan 2020 11:50:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin Lau <kafai@fb.com>, Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <5e2b4a9e2028_551b2aaf5fbda5b8e1@john-XPS-13-9370.notmuch>
In-Reply-To: <20200123183427.wsmwuheq3wcw3usm@kafai-mbp.dhcp.thefacebook.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-2-lmb@cloudflare.com>
 <20200123183427.wsmwuheq3wcw3usm@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf 1/4] selftests: bpf: use a temporary file in
 test_sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau wrote:
> On Thu, Jan 23, 2020 at 04:59:30PM +0000, Lorenz Bauer wrote:
> > Use a proper temporary file for sendpage tests. This means that running
> > the tests doesn't clutter the working directory, and allows running the
> > test on read-only filesystems.
> > 
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  tools/testing/selftests/bpf/test_sockmap.c | 15 +++++----------
> >  1 file changed, 5 insertions(+), 10 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
> > index 4a851513c842..779e11da979c 100644
> > --- a/tools/testing/selftests/bpf/test_sockmap.c
> > +++ b/tools/testing/selftests/bpf/test_sockmap.c
> > @@ -331,7 +331,7 @@ static int msg_loop_sendpage(int fd, int iov_length, int cnt,
> >  	FILE *file;
> >  	int i, fp;
> >  
> > -	file = fopen(".sendpage_tst.tmp", "w+");
> > +	file = tmpfile();
> >  	if (!file) {
> >  		perror("create file for sendpage");
> >  		return 1;
> > @@ -340,13 +340,8 @@ static int msg_loop_sendpage(int fd, int iov_length, int cnt,
> >  		fwrite(&k, sizeof(char), 1, file);
> >  	fflush(file);
> >  	fseek(file, 0, SEEK_SET);
> > -	fclose(file);
> >  
> > -	fp = open(".sendpage_tst.tmp", O_RDONLY);
> > -	if (fp < 0) {
> > -		perror("reopen file for sendpage");
> > -		return 1;
> > -	}
> > +	fp = fileno(file);
> It may be better to keep fp == -1 check here.
> It is not clear to me the original intention of reopen.
> I would defer to John for comment.
> 

Seeing fileno shouldn't fail seems OK to me.

> >  
> >  	clock_gettime(CLOCK_MONOTONIC, &s->start);
> >  	for (i = 0; i < cnt; i++) {



