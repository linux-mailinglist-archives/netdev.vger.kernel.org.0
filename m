Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C6E63FC30
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 00:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiLAXoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 18:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiLAXoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 18:44:03 -0500
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29166BE4F8;
        Thu,  1 Dec 2022 15:44:02 -0800 (PST)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1441d7d40c6so3962508fac.8;
        Thu, 01 Dec 2022 15:44:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBjMeuRLVfB0Q1K91g+RhzJYDgpvITGQ3Wa0hVWnVFA=;
        b=QR+eBVOa+h/Ko5Z+PKePSgK9D9Moh/PqSqvHfSsKToivzZ65TT8BA9M0HaUstzxN9P
         43AvRjQvAoCa+CkTc4KSoXQrGDbgXw8J9zYKps7dDCOtSVh/mBi38TOcwX5myjX3xEiE
         iuFJSgmmoK+k5o6IUFGhGhiSlsFNZqEvHh8p+pPZppDiaYdBbgbrpGF6YgRo/diRBZVo
         pvRI+yi328/vWai5o07AmOSxw4uo4G/J6DrzwznFpXhYpiv92yD5WjcJ+xklK6zuZMUi
         enKNs3hVDugFM+zWKjsKA4KWKhLgQulEYcQhffpxJ6EB2zPQKPgOZc2PuSVI5NQ/5B+K
         7VAw==
X-Gm-Message-State: ANoB5pnijfcQgnys4Rams0W1KAfg0wMWlk5IL03JIvjp0OQ9v6XMSBNx
        Nvo8DZVfGQ68YeQXiRnQsTn2pSMGXQ==
X-Google-Smtp-Source: AA0mqf4pknopJGrWOequ2EqipgdRgXWSNsM2LgM3UzqF3aEUNXODvGWLmMXX/V+42xajku68ybLwaA==
X-Received: by 2002:a05:6870:3c0f:b0:143:53aa:5813 with SMTP id gk15-20020a0568703c0f00b0014353aa5813mr21218698oab.161.1669938241401;
        Thu, 01 Dec 2022 15:44:01 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r81-20020aca5d54000000b0035b99bbe30bsm2344462oib.54.2022.12.01.15.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:44:00 -0800 (PST)
Received: (nullmailer pid 1700884 invoked by uid 1000);
        Thu, 01 Dec 2022 23:44:00 -0000
Date:   Thu, 1 Dec 2022 17:44:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH 5/5] powerpc: dts: remove label = "cpu" from DSA
 dt-binding
Message-ID: <20221201234400.GA1692656-robh@kernel.org>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <20221130141040.32447-6-arinc.unal@arinc9.com>
 <87a647s8zg.fsf@mpe.ellerman.id.au>
 <20221201173902.zrtpeq4mkk3i3vpk@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221201173902.zrtpeq4mkk3i3vpk@pali>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 06:39:02PM +0100, Pali Rohár wrote:
> On Thursday 01 December 2022 21:40:03 Michael Ellerman wrote:
> > Arınç ÜNAL <arinc.unal@arinc9.com> writes:
> > > This is not used by the DSA dt-binding, so remove it from all devicetrees.
> > >
> > > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > > ---
> > >  arch/powerpc/boot/dts/turris1x.dts | 2 --
> > >  1 file changed, 2 deletions(-)
> > 
> > Adding Pali to Cc.
> > 
> > These were only recently updated in commit:
> > 
> >   8bf056f57f1d ("powerpc: dts: turris1x.dts: Fix labels in DSA cpu port nodes")
> > 
> > Which said:
> > 
> >   DSA cpu port node has to be marked with "cpu" label.
> > 
> > But if the binding doesn't use them then I'm confused why they needed to
> > be updated.
> > 
> > cheers
> 
> I was told by Marek (CCed) that DSA port connected to CPU should have
> label "cpu" and not "cpu<number>". Modern way for specifying CPU port is
> by defining reference to network device, which there is already (&enet1
> and &enet0). So that change just "fixed" incorrect naming cpu0 and cpu1.
> 
> So probably linux kernel does not need label = "cpu" in DTS anymore. But
> this is not the reason to remove this property. Linux kernel does not
> use lot of other nodes and properties too... Device tree should describe
> hardware and not its usage in Linux. "label" property is valid in device
> tree and it exactly describes what or where is this node connected. And
> it may be used for other systems.
> 
> So I do not see a point in removing "label" properties from turris1x.dts
> file, nor from any other dts file.

Well, it seems like a bit of an abuse of 'label' to me. 'label' should 
be aligned with a sticker or other identifier identifying something to a 
human. Software should never care what the value of 'label' is.

Rob
