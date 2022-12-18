Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0D564FD63
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 02:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiLRBcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 20:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLRBcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 20:32:20 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DA7DF09
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 17:32:19 -0800 (PST)
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 3948020037;
        Sun, 18 Dec 2022 09:32:12 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1671327133;
        bh=9yCmwl9eW62jRE+k0inHih/c5ukSLFkCAdQTPSuzX5Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=D/mYrGldjXHcPDPchfZsMvAWVlAAaunQSFQI4D0q7ENhSuueHqiqXcpqC9OSfZPkv
         txqCoxDn4ZNB48VmhJxQDi2V2FWTfp/54fg0siqCMdh8N71w4HXXYjeNxWrM59kYRG
         jSwlTwzk70D02XQ/X2//b+PQEj/UR6MnnU6qwqOx/Nid+271z15ak+mujmgDBRCGQb
         LtyiS1VWaCnRbOJqmGFsVghmDbkt4myvZ/zi1A2Z1UErsUIwmJTuf/C4D3XJ6Y5EzN
         7iubJ7W6J4iPw88yns9n3obGUJsAVr8WNrw884R81aMvxtoe4FqxGBm23qoBIkohPO
         wytcj2fp31v5g==
Message-ID: <ab74c9263f6cd2c20cab48b5d440ec15b69957e5.camel@codeconstruct.com.au>
Subject: Re: [PATCH net] mctp: serial: Fix starting value for frame check
 sequence
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Harsh Tyagi <harshtya@google.com>
Date:   Sun, 18 Dec 2022 09:32:11 +0800
In-Reply-To: <CAKgT0Ufb-PeuqH4+dLca8ANJ=Y7uhYCK-QLNz-Pjo991pJZ8Xw@mail.gmail.com>
References: <20221216034409.27174-1-jk@codeconstruct.com.au>
         <2eecaca2d1066d51d136a8d95b5cd2fd19e5e111.camel@gmail.com>
         <6d07e45e6237f24ec32a723e747dd070fb53bea7.camel@codeconstruct.com.au>
         <CAKgT0Ufb-PeuqH4+dLca8ANJ=Y7uhYCK-QLNz-Pjo991pJZ8Xw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

>=20
> > Yep, that would make sense if they're commonly used values, but I'm
> > not sure that would be suitable to include that in this fix, as it
> > would just add disruption to any backport work.
>=20
> Sorry, I didn't intend that for this patch. I was suggesting it as
> possible follow-on work.

Ah, cool! Yep, definitely a contender for a future change.

(this might be a good opportunity as a starter item for someone wanting
to get familiar with the development/review process, if you know of
anyone?)

Cheers,


Jeremy

