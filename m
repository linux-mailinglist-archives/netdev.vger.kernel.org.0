Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6909370463
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 17:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfGVPrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 11:47:08 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39689 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfGVPrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 11:47:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so17849479pgi.6;
        Mon, 22 Jul 2019 08:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UburfzSa8dN3jNeThqJCOV70R7AHFz3PWQCFvj5qH9M=;
        b=f7JhvjFFg16BxpbAJu8Ngasb/EJmSC5s+uwGEilUyXecGwaaYWlubmHBpNYvfloWOe
         Xtx9wRVKPmsNeZd9cZohztZJOdYOPrmt6JmV/ZV/xUggVtjWJOvwT4n/UKpkBT490dKC
         GzH9kExUMNeCDXxnF3GfzZdSVR1Rgu3+mmJwDn/7yp6QrzIp76TqshjBFbmsPkPhRuyA
         +C+U/2BvvA8Kfdb2rG++wTZpN7kuIrV1sSI0dlu+Om8uUWXd10piIgUpIuS3xi/Vi/TN
         E2/UAOlERoll7iLk8fsPJlo8cfREmQpdXhDoBZOEr6yNdgF/ndh8CKci7OEfKzbPWiCx
         cbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UburfzSa8dN3jNeThqJCOV70R7AHFz3PWQCFvj5qH9M=;
        b=L3+kwOw8qqI0L6NisEtzeZsNDojn7zKFrMq/Lp2asjUYHeQpfC553HASsofaQbDLrO
         WmjZffzsNRHkmCpqRHPQ5+Rcsu7V5bbKwg7lVkXNyEScorNuwCfWGUOcpSOSfers1iPa
         PsiTlXhpJbyI/gfiyZYOI9g0xEvuJJvCeJaFPD8g9l4rYm6vYOGA6l1+G2JODjQkm0oZ
         0GIHf+mn7Re/mrvH5CCaLcoJ71dt+FewU7i4ouPcrAC7dz1OFiZpCkfXrpseE11mua3x
         YvHqIz3gRwqcYHp9w9M3BslqN+TZWQu5Qi6ADkzuzz9hIoXzor0/IKpRah4WnwRmyLnv
         WHFQ==
X-Gm-Message-State: APjAAAWPnm0iFDfN2IvI50ljBrsHXY5TCASqj9H2R+KDEMnUzevEnLiF
        JulH2zWzb8OaYI7sGe7Zr6A=
X-Google-Smtp-Source: APXvYqx5/tJg2zx/Ab2XmyCYd+9Hd5g3hQST91HYTfWgxk9zyMMhJmOjOxKS/t6prOssdyjBFZ5Iqg==
X-Received: by 2002:a62:ce07:: with SMTP id y7mr866403pfg.12.1563810427879;
        Mon, 22 Jul 2019 08:47:07 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s7sm34804662pjn.28.2019.07.22.08.47.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 08:47:07 -0700 (PDT)
Date:   Mon, 22 Jul 2019 08:46:59 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com
Message-ID: <5d35da7333e95_7cd82abccab905bcbc@john-XPS-13-9370.notmuch>
In-Reply-To: <20190719103721.558d9e7d@cakuba.netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
 <20190719103721.558d9e7d@cakuba.netronome.com>
Subject: Re: [PATCH bpf v4 00/14] sockmap/tls fixes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Fri, 19 Jul 2019 10:29:13 -0700, Jakub Kicinski wrote:
> > John says:
> > 
> > Resolve a series of splats discovered by syzbot and an unhash
> > TLS issue noted by Eric Dumazet.
> 
> Sorry for the delay, this code is quite tricky. According to my testing
> TLS SW and HW should now work, I hope I didn't regress things on the
> sockmap side.

I'll run it through our CI as well but looks good to me. Thanks a lot
for getting this finished up.

> 
> This is not solving all the issues (ugh), apart from HW needing the
> unhash/shutdown treatment, as discussed we may have a sender stuck in
> wmem wait while we free context underneath. That's a "minor" UAF for
> another day..

Agreed. But this should solve most of the syzbot issues and a few
crashes we saw in testing real workloads.

Thanks,
John
