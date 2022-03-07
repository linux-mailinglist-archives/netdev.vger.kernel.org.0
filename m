Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8730F4D0517
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243660AbiCGRTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239963AbiCGRTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:19:22 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CEA32989
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 09:18:27 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id u3so4985904ljd.0
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 09:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PytMAvERvamFaZa2mj5LMYSOqi/GBoG5kLYBTiktqF4=;
        b=T+dSeMWfcde2IMq2WUbaYuLqzEIakHQTrdFu/RiI3mChnzXdpRv+55gHKXnNrQ7OTQ
         h9aCbBjLij3fFFlTaUgAPBZ+hfgXAUSpJGn8ZEcHmsG7BrWcjhUyAgSAbr71oFbd7ihM
         ezjO8fkfFFAJOqGQZOIsPnGT7/ZRa9s3eGn4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PytMAvERvamFaZa2mj5LMYSOqi/GBoG5kLYBTiktqF4=;
        b=hrmL1tcC5S4py/H3Ar5tqW51QSEUP0O+H7PqFaV4AbsiF2XR+VOxGmHfAsSsgBBVEz
         2JDzAmevniutcc0f+FeJgn8/vOKllYxpvSFztJ5l/0ZGr5PW4fNZFiKk0Hv/UIgYJSg3
         SlUdUV2jVM9YQQxJpQMxpAjfdVQnGxR+FUUMyZSCs8mJ76yylxrWgkSgipT5fZ5uF1ZE
         Yhycjc3/QzfRnm6AAQxrNmVothUM+3tJKNpLndMO0NBoTIn2rWooFzqzfLHGUTkwrL6+
         HjtK92FwLr97Lyt+1KeAUwiBV07ZG4W+GyMjq4fo5MWQ/XmrjTvtIxcNkcTe1DF3ItGM
         PbVQ==
X-Gm-Message-State: AOAM5325dak5Ap9bb0L6tF18S9aWFqVRsd79XVTdez9iWGopxxsn+na0
        +MV0upWHpqLLB0yw1yJ4F3cSPYpCiFVFmYnLwl01lQ==
X-Google-Smtp-Source: ABdhPJzeDulbdEBe1aXrA3wisAoL7vLDU4NWEToPGu7WCSEho7enCbGd/lemy+S0Y+Yp1jhMoep5A9rr8ih9oTxIJKg=
X-Received: by 2002:a2e:90cb:0:b0:22e:5363:95f0 with SMTP id
 o11-20020a2e90cb000000b0022e536395f0mr8195637ljg.210.1646673502736; Mon, 07
 Mar 2022 09:18:22 -0800 (PST)
MIME-Version: 1.0
References: <20220307214539.473d7563@canb.auug.org.au>
In-Reply-To: <20220307214539.473d7563@canb.auug.org.au>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Mon, 7 Mar 2022 09:18:10 -0800
Message-ID: <CAOkoqZkCN9SiG41MmaD+Qv-zvTftz=MDJeiuDJfV2Ws+ezBS_g@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 7, 2022 at 2:45 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc
> allmodconfig) failed like this:
>
> ERROR: modpost: ".local_memory_node" [drivers/net/ethernet/fungible/funeth/funeth.ko] undefined!

I will take a look at this.

> Caused by commits
>
>   ee6373ddf3a9 ("net/funeth: probing and netdev ops")
>   db37bc177dae ("net/funeth: add the data path")
>
> --
> Cheers,
> Stephen Rothwell
