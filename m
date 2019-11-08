Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D21F4DBF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 15:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbfKHOHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 09:07:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42044 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKHOHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 09:07:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id a15so7170434wrf.9
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 06:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DaPKJ8NqcPdGzR5ce3ffp8Me+bjSrimbm0a9F6gKRnQ=;
        b=nk/2oKOPVFnBefJOm36ISnmvoI2xhJXvmRp8KTWzil4Y1T0kXQR6WdnisDXH5BpuhX
         Btwxf8VYo6DgH5bXbQ8Zve3XAYpZqDd+gJOuj1BcMgt3Pupj0heGgRlMV2vq3WLPY0ts
         jW+6xwyESmEj8yxzVCZZkJud/dh3AcEsYS5fZjyZ9zNiQ19IRcbuyhXAiu4TfDfh8J3X
         dHji3UbzCnvme1rVLemsp6L7FGuI846zvPE73ioxGbV1C+tJ+x3aSCp7Fvh3FDHMiSlx
         TKsjAgnsz+agoiHvprlYfKrhHFkcYpdXsIar6094blfwFuF64/PzQlAS9rdKWyjut+VM
         +LxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DaPKJ8NqcPdGzR5ce3ffp8Me+bjSrimbm0a9F6gKRnQ=;
        b=MebFBPfDj+1te3nmgKtAjrinMgpSIItyAa7QLLzp1IFkcJcIt/p8LuIz10d0ZhvO4P
         D4kkLnwGAHOZVeEpnHpOR9dKx18h9J9sw63CdVdXCZLCcesvXWRE2B4ANbk/F9RYs/5p
         5kHAjS33b59zxpIqijgvTx3SZXSrsKrq5gQa1eJeyTXcioIW5aqneUWEKARMrMvmS5XS
         vCM44tu4wALhAYv4GzMWC0z7xhgzMqSAqHZ1vUhWHv+Fzp+om5SQn2ZH1JTAd68O8ZRj
         CtjCcVHFVW2O0np3C0Dxc+SImsOncN0X6klFho6M5rVruf6TqDPy3N5R+I54N/9/yZAU
         U32g==
X-Gm-Message-State: APjAAAVasqW7QfDnnVumle2h04SqdgOpwwkzQ1WTKBItQXcpq4pUAPso
        B6vKuctRR9+aU/rJ3ffCuwCJVrvaLjoI04ThowU=
X-Google-Smtp-Source: APXvYqwo+hYEASBpMyVMoH+rLxU/GobNxh92HPUDDJsNUym7VVkB2GspTwJZhhN6XN3xnVI8xTKuyqtZFslF5pEYkME=
X-Received: by 2002:adf:9dd0:: with SMTP id q16mr8524093wre.303.1573222063974;
 Fri, 08 Nov 2019 06:07:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573030805.git.lucien.xin@gmail.com> <20191106.211459.329583246222911896.davem@davemloft.net>
 <CADvbK_ePx7F62BR43UAFF5dmwHKJdkU6Tth06t5iirsH9_XgLg@mail.gmail.com> <c89c4f99-d37f-17c8-07e6-ee04351c8c36@gmail.com>
In-Reply-To: <c89c4f99-d37f-17c8-07e6-ee04351c8c36@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 8 Nov 2019 22:08:01 +0800
Message-ID: <CADvbK_dDVJs23x9Y-x3TNBRhoU6pQ5xH51B_nn0SuSws+C5QRA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] lwtunnel: add ip and ip6 options setting and dumping
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 12:18 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/7/19 3:50 AM, Xin Long wrote:
> > Now think about it again, nla_parse_nested() should always be used on
> > new options, should I post a fix for it? since no code to access this
> > from userspace yet.
>
> please do. All new options should use strict parsing from the beginning.
> And you should be able to set LWTUNNEL_IP_OPT_GENEVE_UNSPEC to
> .strict_start_type = LWTUNNEL_IP_OPT_GENEVE_UNSPEC + 1 in the policy so
> that new command using new option on an old kernel throws an error.
I'm not sure if strict_start_type is needed when using nla_parse_nested().

.strict_start_type seems only checked in validate_nla():

        if (strict_start_type && type >= strict_start_type)
                validate |= NL_VALIDATE_STRICT; <------ [1]

But in the path of:
  nla_parse_nested() ->
    __nla_parse() ->
      __nla_validate_parse() ->
        validate_nla()

The param 'validate' is always NL_VALIDATE_STRICT, no matter Code [1] is
triggered or not. or am I missing something here?
