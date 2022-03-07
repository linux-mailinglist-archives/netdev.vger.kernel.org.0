Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1154D0025
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 14:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiCGNgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 08:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbiCGNgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 08:36:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844237CDC7;
        Mon,  7 Mar 2022 05:35:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22F1BB81243;
        Mon,  7 Mar 2022 13:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A20C340F6;
        Mon,  7 Mar 2022 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646660104;
        bh=o+SD1cUlsYrZv26Wn6nQ+JaPM+ZNKL19sVgBMH450zM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a6vgOPrc22ssJhNR/R2TvrMVz82ctGntauMqM18HVgmWudfpPhb15lQTebVYFF/ww
         gKAv72rD0CB77CDK44cnmG9awNUb3C0KjtkTOlU+bQNhXusETL7tlvrywpG+ZC7y6K
         eagWJ1rYYBuLqeAwD51lhoK/1KjFHXNuJZS1ktelNtnJyagcRuNAQtb1ZIBCXf2yGS
         LZ9kpRvFI5kjT+l7B3SpCv0Jnukcsx71Q0IAluQnD8M0kLEHEAWqwNXH8IOmZ+908l
         ZKmdDHh/fL1MSuuTzUnYlnEzjohV5NVQrnfDEd7dr1/pu+RJJVuSRtvPc+5qLre+n6
         JoeIvm/AScQXA==
Received: by mail-ej1-f42.google.com with SMTP id d10so31932971eje.10;
        Mon, 07 Mar 2022 05:35:04 -0800 (PST)
X-Gm-Message-State: AOAM531o+5lUN/Afb/mF8KUl4M+ru7ULabyuo/RHUzE17oRbhV4KsSIk
        ekPvNFyM9VXOH0autgdaRmIWHXJ0B9Dhx+OxSg==
X-Google-Smtp-Source: ABdhPJxptrtnZf/+9J2q0LL+bGJVCspIpX4l4HtvBxUxmFH6Wwcxw4rGqs98Gg9PPjVDwPXszI++IRx4tvIh7LtQSt0=
X-Received: by 2002:a17:906:a38e:b0:6da:a1f9:f9ee with SMTP id
 k14-20020a170906a38e00b006daa1f9f9eemr8679535ejz.27.1646660102959; Mon, 07
 Mar 2022 05:35:02 -0800 (PST)
MIME-Version: 1.0
References: <164659571791.547857.13375280613389065406@leemhuis.info>
 <CAHk-=wgYjH_GMvdnNdVOn8m81eBXVykMAZvv_nfh8v_qdyQNvA@mail.gmail.com> <4a28b83b-37ef-1533-563a-39b66c5ff158@leemhuis.info>
In-Reply-To: <4a28b83b-37ef-1533-563a-39b66c5ff158@leemhuis.info>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 7 Mar 2022 07:34:50 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLHun+X4jMwTbVMmjjETfbP73j52XCwWBj9MJCkpQ41mA@mail.gmail.com>
Message-ID: <CAL_JsqLHun+X4jMwTbVMmjjETfbP73j52XCwWBj9MJCkpQ41mA@mail.gmail.com>
Subject: Re: Linux regressions report for mainline [2022-03-06]
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Netdev <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 7, 2022 at 1:32 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> On 06.03.22 22:33, Linus Torvalds wrote:
> > On Sun, Mar 6, 2022 at 11:58 AM Regzbot (on behalf of Thorsten
> > Leemhuis) <regressions@leemhuis.info> wrote:
> >>
> >> ========================================================
> >> current cycle (v5.16.. aka v5.17-rc), culprit identified
> >> ========================================================
> >>
> >> Follow-up error for the commit fixing "PCIe regression on APM Merlin (aarch64 dev platform) preventing NVME initialization"
> >> ---------------------------------------------------------------------------------------------------------------------------
> >> https://linux-regtracking.leemhuis.info/regzbot/regression/Yf2wTLjmcRj+AbDv@xps13.dannf/
> >> https://lore.kernel.org/stable/Yf2wTLjmcRj%2BAbDv@xps13.dannf/
> >>
> >> By dann frazier, 29 days ago; 7 activities, latest 23 days ago; poked 13 days ago.
> >> Introduced in c7a75d07827a (v5.17-rc1)

Actually, it was introduced over a year ago in 6dce5aa59e0b. It was
fixed in c7a75d07827a for XGene2, but that *further* broke XGene1
which was just reported this cycle.

> > Hmm. The culprit may be identified, but it looks like we don't have a
> > fix for it, so this may be one of those "left for later" things. It
> > being Xgene, there's a limited number of people who care, I'm afraid.
> >
> > Alternatively, maybe 6dce5aa59e0b ("PCI: xgene: Use inbound resources
> > for setup") should just be reverted as broken?
>
> I don't care much, I just hope someone once again will look into this,
> as this (and the previous) regression are on my list for quite a while
> already and process once again seems to have slowed down. :-/

It's going to take some more debug patches from me as what's been
tried so far didn't work and I'm not ready to give up and revert this
cleanup.

Rob
