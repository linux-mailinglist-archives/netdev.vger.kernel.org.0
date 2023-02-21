Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E4E69DDC0
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 11:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbjBUKTV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Feb 2023 05:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbjBUKTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 05:19:19 -0500
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E100023C51
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 02:19:09 -0800 (PST)
Received: by mail-wr1-f44.google.com with SMTP id o4so3820921wrs.4
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 02:19:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OWvmqJ7BcNQHLwnSMTWU0NnVm09+WHsU7hk7yAuCwEk=;
        b=xRVZ5AmSVSz0WA1ESUiDJC2dNG5dxJ1LGxL8gTI2n9ccsSIlvIY5ed5gdcgNQUJ1C7
         l98axs1bqkG7aMyTSHQTS7edWvSb8aF0lXcV99gGDami8Hkw23wene5FHGI9ZUUfFYrI
         dgbFlKfPBWH9o8RE7akbSJBAkzpAaK+5dGcEMHCvPTX7MSmuSl/kOteHYXD8d5Kb7pgn
         siHZEcmaY/W9/r6kjntzPKzeknCI8eV5UrkbLUF2aRpdSGmtHvuuHLeLIYqrKeBWMWRV
         6ud5kvG3zJFw+BNrCt3RGyjXd7rsVWM789iRiHkxFgdF24OX7DxUay6ydW0VX3q5y9Ln
         K1sQ==
X-Gm-Message-State: AO0yUKWLVCp/5vp7YPR4xrbVDYYaeQ5+wDq1Ii3rAH6s464E3BQOJ5h5
        kWDt7kOoqOBfg359dt3pbqClvt0MBwrbI33E
X-Google-Smtp-Source: AK7set/uGe/uQ0OYeP3KO+BiDqTVSqmCHvNy44cEV87YU5nMP49EfFB43gYhtBrQdUZNDs7XFPC0cg==
X-Received: by 2002:a5d:5f03:0:b0:2c5:4d35:5260 with SMTP id cl3-20020a5d5f03000000b002c54d355260mr3539996wrb.16.1676974748172;
        Tue, 21 Feb 2023 02:19:08 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id u3-20020adff883000000b002c703d59fa7sm1856433wrp.12.2023.02.21.02.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 02:19:07 -0800 (PST)
Message-ID: <4f07c0cb42ce191e8054fe816e7b8295425a16f2.camel@inf.elte.hu>
Subject: Re: [EXT] Re: [PATCH net-next] sandlan: Add the sandlan virtual
 network interface
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     netdev@vger.kernel.org
Date:   Tue, 21 Feb 2023 11:19:07 +0100
In-Reply-To: <CALHoRjcwnHGWKDLD_RO5W2yDSTBbmPUq+eEczk7v5FjuhKikLw@mail.gmail.com>
References: <20221116222429.7466-1-steve.williams@getcruise.com>
         <20221117200046.0533b138@kernel.org>
         <CALHoRjctagiFOWi8OWai5--m+sezaMHSOpKNLSQbrKEgRbs-KQ@mail.gmail.com>
         <Y30sfGrQ2lQN+CMY@lunn.ch>
         <CALHoRjcwnHGWKDLD_RO5W2yDSTBbmPUq+eEczk7v5FjuhKikLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steve!

On Tue, 2022-11-29 at 09:54 -0800, Steve Williams wrote:
> On Tue, Nov 22, 2022 at 12:09 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > 
> > On Mon, Nov 21, 2022 at 06:59:11PM -0800, Steve Williams wrote:
> > > I have had trouble with the veth driver not transparently passing
> > > the
> > > full ethernet packets unaltered, and this is wreaking havoc with
> > > the
> > > hanic driver that I have (and that I'm submitting separately).
> > > That,
> > > and veth nodes only come in pairs, whereas with sandlan I can
> > > make
> > > more complex LANs and that allows me to emulate more complex
> > > situations. But fair point, and I am looking more closely at
> > > figuring
> > > out exactly what the veth driver is doing to my packets.
> > 
> > If there is a real problem with veth, please describe it, so we can
> > fix the bugs. We don't add new emulators because of bugs in the
> > existing system.
> 
> In light of the feedback I received here, I revisited the issue; and
> was able to get the veth driver to work after all, at least for
> regression tests of the hanic driver. I can't seem to reproduce the
> issue I thought I was having. So that kills one motivation for the
> sandlan driver, at least for me.

Good to know. I noticed your sandlan/hanic patches just now, and just
also wanted to tell that veth good enough for pretty much all 802.1CB
use-cases I'm aware of. In fact I use 2 veth paris in my .1CB testings
as well.

> 
> -- 
> 
> Stephen Williams
> 
> Senior Software Engineer
> 
> Cruise
> 


Best,
Ferenc
