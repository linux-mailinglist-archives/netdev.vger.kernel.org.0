Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FE41BE45F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgD2Qxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726836AbgD2Qxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:53:42 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA9CC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:53:41 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id u13so3467840qtk.5
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:message-id:date:subject:from:to;
        bh=hxiBv9yrVqUMQBBkcYpJics8xDmceCI+NKzHLf78oM4=;
        b=UZJ1QOmv8gqAP3TL6WhlSy+pMIl36uLRqEQROQd9ClmrxfDbJt7SVI68WC7c3gMBq1
         2nDz7Wa2HWyj/wpG0DMEepNL1vE6xwKeB2d12CoZh2fL94sxbglbj8vdRWAFaDgGTYVK
         WJXXNbuK6zwtfLKVQIkGpG7r2i6rX2tBSMw756h5rzLAlpaQd+Pk7pcA8BiGzc6k7fRo
         sj51ZoXpnZC7G5PHMjygY9NKi9dtC9H8UVVnDt9vJ+3MCZTn0qSZ+fm3d5oO+eW5Z7O3
         W6QKcCiZ8QqHq5+OJEiOBmuRIx6SaUZ0LOOu/EVtPe/Tc3cXSQGs1hK0mcjvqEcA8TDQ
         BfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:message-id:date:subject:from:to;
        bh=hxiBv9yrVqUMQBBkcYpJics8xDmceCI+NKzHLf78oM4=;
        b=S5ZUrmzZx0LuzzHkDIlI7jO+hWUc4ErNXIDM14edNmpFUT2/CrjFKIv6L7ZHIK/NEk
         F2hkxujhg9vnT7EOKQqS67jhqY0bvxZ6zcPz5ACNJbHBTtN/BbCeHdfPsNhRqtIMJLDv
         nw0SoJPqaU1PJurEzbOHevgsPp8cCFtB5CNGzLo9VF7+4Nmx8B5J0kgJps34yotYWjzL
         FlKWyPJ3zhaunzSkfhtPar9IJHrdwPOn8algk29aWsz0mrxJrGbrE+t7gNG/4/5FgF73
         10id3WMbIhavn3IbetzgyQmYduqGSFA2BnIh0pWK6HvRZhU31DbCRKV/DRsiF8e2VGK4
         aMWg==
X-Gm-Message-State: AGi0PuZKxBLmZGfX3fagl0wHieqiAPg82CsWNEDpIUkEmkS5dnPnJSxL
        OoAqDV9xRSN9udzsTnlLLY0vvRM=
X-Google-Smtp-Source: APiQypKeG3ABWJ1wvWBY2PZ3h6VbgPHtde5vFD80OAAGiZTrlqoAW/rJLXNrsKizPsvQ59i/4g3Q+Po=
MIME-Version: 1.0
X-Received: by 2002:a0c:b604:: with SMTP id f4mr33399340qve.40.1588179220814;
 Wed, 29 Apr 2020 09:53:40 -0700 (PDT)
Message-ID: <0000000000004c3fe305a470ca38@google.com>
Date:   Wed, 29 Apr 2020 16:53:40 +0000
Subject: 
From:   sdf@google.com
To:     kafai@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Date: Wed, 29 Apr 2020 09:53:39 -0700
From: Stanislav Fomichev <sdf@google.com>
To: Martin KaFai Lau <kafai@fb.com>
Cc: netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
	ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf-next] bpf: bpf_{g,s}etsockopt for struct bpf_sock
Message-ID: <20200429165339.GA40941@google.com>
References: <20200428185719.46815-1-sdf@google.com>
  <20200429164550.xmlklvypzlcjagvw@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429164550.xmlklvypzlcjagvw@kafai-mbp>

On 04/29, Martin KaFai Lau wrote:
> On Tue, Apr 28, 2020 at 11:57:19AM -0700, Stanislav Fomichev wrote:
> > Currently, bpf_getsocktop and bpf_setsockopt helpers operate on the
> > 'struct bpf_sock_ops' context in BPF_PROG_TYPE_CGROUP_SOCKOPT program.
> > Let's generalize them and make the first argument be 'struct bpf_sock'.
> > That way, in the future, we can allow those helpers in more places.
> s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/

> Same for the other uses in the commit message and also
> the document comment in the uapi (and tools) bpf.h.

> Others LGTM.
Oops, good catch, will follow up with a v2, thanks!

> > BPF_PROG_TYPE_CGROUP_SOCKOPT still has the existing helpers that operate
> > on 'struct bpf_sock_ops', but we add new bpf_{g,s}etsockopt that work
> > on 'struct bpf_sock'. [Alternatively, for BPF_PROG_TYPE_CGROUP_SOCKOPT,
> > we can enable them both and teach verifier to pick the right one
> > based on the context (bpf_sock_ops vs bpf_sock).]
> >
> > As an example, let's allow those 'struct bpf_sock' based helpers to
> > be called from the BPF_CGROUP_INET{4,6}_CONNECT hooks. That way
> > we can override CC before the connection is made.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
