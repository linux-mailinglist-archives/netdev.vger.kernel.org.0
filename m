Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0D9256050
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 20:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgH1SPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 14:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1SPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 14:15:00 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1009DC061264;
        Fri, 28 Aug 2020 11:15:00 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d18so2308784iop.13;
        Fri, 28 Aug 2020 11:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uei2oX6+R5/bya0knk1RWjU3wT5D0mfsVI+rbrGek1E=;
        b=RYiNHPwxJXlh7AlH6vgL7jadjJxZAhq4gkMI8otSZ5k3wL/xN236LHimM8GrheJ+y8
         GyJbk2s+SfRhrLtagmZ9qWDEqzbLUeEPylMIl2i2QzCUFkZ46pTxc0D2I6waHrWJZFBN
         DYnJr0VWvxzBM7dI6jKw40o3eCYpuZ7IGwlOiO7N+ipbd9SczNCJeVcaLfCZ39NG+dOv
         QlONB4ou+zLz8EzYVQlunexeX+Iy7z7yWvxnRDBhw16HSrhumzWqJj3Hz0ufcAz/BLI7
         6NvbJncvYp1eDl0cWDolrb+lIX6+te9KSnpnp/QUK4gFIQsf8m/oPJngkvzxQdnqtdr3
         T0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uei2oX6+R5/bya0knk1RWjU3wT5D0mfsVI+rbrGek1E=;
        b=TjXpsfWilF42J68qvWsJY4XyHHYPTUgnvtNX7BGDbHxblPF3jqVAc+l7WhXwL7qHQO
         Qz4UuA+VmchFVluuC9lrD3KAvIjdBf6fQcmiE+UXPS0rRuq/H79u58giG6rsmtecL+sT
         /wjzbRmqnCQw4WNCcFPNB7lVwP+c2T1qsShpr51SpzmTQhllJk3szJN4qT7Txu/cUce1
         w+U46xQcrhc/8zc89HJmeYmmV6B4Lm/hdyRccN2/2AO6c4ChUurhg1dtDpW3ODDGRWDA
         dzeRzHtWf3CGZ5eY36Uf+TYXU6fPnMe84XfqW9ewt+WGVnU5LigZZQFbhAu+nPPC/sUU
         r+Gw==
X-Gm-Message-State: AOAM532LGYWPPNCnTs+9WaNePo8hhHhAuFtbizMvMN0YVWzDbYkZCfJ8
        k5Vg39oIcXE3BfUaYRgLrZz+LaYntXRKBtAYgKCvqVXyqZd0jw==
X-Google-Smtp-Source: ABdhPJxOHnbHhf2/pqdreiBeW/YR33ZJP33je5WQ4cFveTMQTRscKQl4+dYMnhS1+syZPFtIR7g94MaURuA3z9FVnyM=
X-Received: by 2002:a6b:c953:: with SMTP id z80mr2084073iof.178.1598638499277;
 Fri, 28 Aug 2020 11:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200815165030.5849-1-ztong0001@gmail.com> <20200828180742.GA20488@salvia>
In-Reply-To: <20200828180742.GA20488@salvia>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Fri, 28 Aug 2020 14:14:48 -0400
Message-ID: <CAA5qM4CUO47EkJ-4wRoi0wkReAXtB5isLbvBEUw045po_TY8Sw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix parsing error
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,
I'm not an expert in this networking stuff.
But from my point of view there's no point in checking if this
condition is always true.
There's also no need of returning anything from the
ct_sip_parse_numerical_param()
if they are all being ignored like this.

On Fri, Aug 28, 2020 at 2:07 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Is this are real issue in your setup or probably some static analysis
> tool is reporting?
>
> You are right that ct_sip_parse_numerical_param() never returns < 0,
> however, looking at:
>
> https://tools.ietf.org/html/rfc3261 see Page 161
>
> expires is optional, my understanding is that your patch is making
> this option mandatory.
