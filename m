Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D6A523A60
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344785AbiEKQb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344800AbiEKQbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:31:23 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01BC239D83
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:31:19 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id kj8so2469562qvb.6
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5AW0aZoxHCN1VcWSiLevVsA+4vTrs8hedKoXKC8swoo=;
        b=PeLfiEM2fdaGSYbtJQ/sHoHI/+L6Xi/cs5SHyHuC/SxKcebTKwmGKdh+4cqV5wbSFf
         oQ2ZNFFCCuTMZtRNOUp4GIVnzh0u64rEZXI5WIL7iXphKrgMdGVWPA+e0JyTQz6N50p9
         oTxSqjvYV4ZKuaTVTHUcSVX+Pcmcvz60odUTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5AW0aZoxHCN1VcWSiLevVsA+4vTrs8hedKoXKC8swoo=;
        b=1lJ8fo7XspttGvez9nMypdDSC/DQEtmTfD2mihYUyQj8MX0bKwV0050xOHBAV2MwyT
         gkTXlvy8t6318Q0+n6NQwB8YI0AKc0iBrACQAQFzQLTV+mi7SIEkk2DNEaCb7VyVrYhv
         ZtVvFz2fV7kWdC4wfzHXZPcguyci/NwHeiwPmFG1DythCkFsxK9G+UpuQ2S2/wdPO0zh
         PaghvaChIFDLSlSqjlWgNHrXv44oEFowctHYo5Luj/kgf+Js1n25Z8z3gAJutwvGAfFG
         hNeOUF7Sse7HmJ8MN8QMbmTivTPY8TfxQfJBTqXyfjrP7EzeocS8erjXTFaGuI0v2fq4
         mznw==
X-Gm-Message-State: AOAM532YQpu5+Pbi7sng6eboAgXiIf0M2sEFlt2X0hfGYxAUsD3QtjJ8
        FuKdNPRRlw5jmIDQ+zFH4OX0Rw==
X-Google-Smtp-Source: ABdhPJwCY37vGnZ+DMy0b1A6UZRgARNdpOdQuhqhLyeMoiUh4C59xvmwsBczXp7zrc+YeSQS3oD8Xg==
X-Received: by 2002:a05:6214:5008:b0:45b:82:6ef with SMTP id jo8-20020a056214500800b0045b008206efmr17026158qvb.87.1652286678916;
        Wed, 11 May 2022 09:31:18 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-127.dsl.bell.ca. [216.209.220.127])
        by smtp.gmail.com with ESMTPSA id k14-20020a05620a414e00b0069fc2a7e7a5sm1546889qko.75.2022.05.11.09.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 09:31:18 -0700 (PDT)
Date:   Wed, 11 May 2022 12:31:16 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <20220511163116.fpw2lvrkjbxmiesz@meerkat.local>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X>
 <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
 <20220511125140.ormw47yluv4btiey@meerkat.local>
 <87a6bo89w4.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a6bo89w4.fsf@mpe.ellerman.id.au>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 11:40:59PM +1000, Michael Ellerman wrote:
> > I think we should simply disambiguate the trailer added by tooling like b4.
> > Instead of using Link:, it can go back to using Message-Id, which is already
> > standard with git -- it's trivial for git.kernel.org to link them to
> > lore.kernel.org.
> 
> But my mailer, editor and terminal don't know what to do with a Message-Id.
> 
> Whereas they can all open an https link.
> 
> Making people paste message ids into lore to see the original submission
> is not a win. People make enough fun of us already for still using email
> to submit patches, let's not make their job any easier :)

Okay, I'm fine with using a dedicated trailer for this purpose, perhaps an
"Archived-At"? That's a real header that was proposed by IETF for similar
purposes. E.g.:

    Archived-at: https://lore.kernel.org/r/CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com

-K
