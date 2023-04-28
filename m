Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125616F1A84
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 16:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjD1OeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 10:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjD1OeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 10:34:15 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD3626A5
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 07:34:10 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3B16BE000A;
        Fri, 28 Apr 2023 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1682692449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CSfsgvjPu4T+RNHyd480XDhpg2hw9w+MlEBJ4P4ATso=;
        b=VuNiWclfgGaJiq7IaY1vMWsYk6DPI9EEx4Yt0KprcsdZquSOj7CNlIdGqO4j890if3wv/a
        kJgpFzFKc2FT7IYCpVFk2UtURpEtozeOaQ8cuXXi9B0OYCnteYH4kw6wRuu5+NqmhKDz+K
        3jWx1jzTvgZTRUoIBiRoOif/SQCQ2Fm0JHKYh8MCfmHN/j/dLiH9w9LKAsXUBhsFtxNlYx
        EuQ2j6sKtHw890PJiQCwKwAc9ZAxd7lYq6lmtfCSpjwqpUQuobyMhAy6U655cgnB1qsgTy
        DY4keKj/jX0a32VojCRJSHwwDBaIF3OuP5eR/G9Eny0Nd+vZORNDRWdnzswyEA==
Date:   Fri, 28 Apr 2023 16:34:06 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
Message-ID: <20230428163406.0a35dc22@kmaincent-XPS-13-7390>
In-Reply-To: <CAP5jrPH1=fw7ayEFuzQZKXSkcXeGfUy134yEANzDcSyvwOB-2g@mail.gmail.com>
References: <20230423032437.285014-1-glipus@gmail.com>
        <20230426165835.443259-1-kory.maincent@bootlin.com>
        <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
        <20230427102945.09cf0d7f@kmaincent-XPS-13-7390>
        <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
        <20230428101103.02a91264@kmaincent-XPS-13-7390>
        <CAP5jrPH1=fw7ayEFuzQZKXSkcXeGfUy134yEANzDcSyvwOB-2g@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Apr 2023 08:14:57 -0600
Max Georgiev <glipus@gmail.com> wrote:

> > Do you use git send-email?  
> 
> Yes, I use "git format-patch" to generate individual patch files for
> every patch in the
> stack, and then I use "git send-email" to send out these patches on-by-one.

I think here is the issue. Send your patch series in one "git send-email" go
not one-by-one.

