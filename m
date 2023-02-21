Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5DE69E5DB
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbjBURWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbjBURWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:22:50 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3EE2ED66
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:22:36 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id s22so6577564lfi.9
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qtT5hlg+/zC4hXH3H1IGc+jG9+X5kax+Az1cVRZz7sA=;
        b=JuVb3HrEF7XAO5m1HiEPAHKpNSvsgyl6feJwt8zMcG+YgxopwHWfnfkpkuOWztddEk
         l/P5NPjzMvO/ckGYobYNUipMpAaZTd3AeT2rp4DkQsBPp0UCJvmpuWhnJUcRhcLxLfJf
         Svnpwd/saTUHjrS/llRi7kzz7le7VHYqHtuV7GFekOj5ov4vGRzrHW0ntO+Lqnp3TjhP
         96iM5IU5Uu8cu4HUMhm7ddhPJVtUtJb76s8nZCksVUY8NO9uz2DJJyfvNyVYWcRJTAjF
         cGxT93SBWpWHQo4IgSl4tZn8SMfFyNLk5lq7iEQFXGXWiK/1Ep1pftii8qZy0Mu4IycJ
         l4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qtT5hlg+/zC4hXH3H1IGc+jG9+X5kax+Az1cVRZz7sA=;
        b=yCkeyq8cTPKbNsF4g1ZX4S1cEWqFboQ3avTRIerBrvjQ2Ic4KHD+BdfsK7uVbrPKYD
         0g5OTZeLlSHXGVyBgtunR9vcXkfUlCCBLGYeoIaLtWJvhDWubl4J1uye6mWfl7xqEQYv
         GKdZpogF3b3juUjycN5nP9zttEwCf7osGRiLe6uZ+KrD3Zez8DbyhN5tIjIB+m4o20qH
         vCWJbZZMdeznqReNU2yimj9TttQHsTyPtr+28HKXEoobq3bYbAPX+KeExoPritH1+ZGf
         VTpiVRj5jVHj40QDLZPFpELlwJInJ+0ep1WjxoP8NKeBw5za8pqDsTQzL9fg14iAs5R9
         kC8Q==
X-Gm-Message-State: AO0yUKVHN3Q+DFOZ2Uj2qx35FKjC+GWgSrfFljnQQAiQfQ/QCh07UXaH
        hihhGiJ6ZmOv7cSw+zE/2Yh34t+oiSeRuDz2MdX6rQ==
X-Google-Smtp-Source: AK7set+KdhF45hWyHg8ZBJ/+kClV9+ACFxSG/TGyjfXFlzAtNI/SuNRpZaShduJOZVKOMcAIA1az6xKMY5DlrM0TfRw=
X-Received: by 2002:a19:ee06:0:b0:4db:3ab2:896e with SMTP id
 g6-20020a19ee06000000b004db3ab2896emr2015400lfb.6.1677000154581; Tue, 21 Feb
 2023 09:22:34 -0800 (PST)
MIME-Version: 1.0
References: <20230217222130.85205-1-ilias.apalodimas@linaro.org> <20230221091458.7d026652@kernel.org>
In-Reply-To: <20230221091458.7d026652@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Tue, 21 Feb 2023 19:21:58 +0200
Message-ID: <CAC_iWjJO6-C+v5dRHxqvpCy_miwhG7g6J2=o8YzfumfMHiKZ0Q@mail.gmail.com>
Subject: Re: [PATCH v3] page_pool: add a comment explaining the fragment
 counter usage
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, alexander.duyck@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Feb 2023 at 19:15, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 18 Feb 2023 00:21:30 +0200 Ilias Apalodimas wrote:
> > When reading the page_pool code the first impression is that keeping
> > two separate counters, one being the page refcnt and the other being
> > fragment pp_frag_count, is counter-intuitive.
> >
> > However without that fragment counter we don't know when to reliably
> > destroy or sync the outstanding DMA mappings.  So let's add a comment
> > explaining this part.
>
> I discussed with Paolo off-list, since it's just a comment change
> I'll push it in.

Fair enough. Thanks Jakub.

Regards
/Ilias
