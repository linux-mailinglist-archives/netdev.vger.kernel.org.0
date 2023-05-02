Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807A36F3FE4
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 11:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbjEBJNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 05:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbjEBJNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 05:13:15 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153154237
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 02:13:13 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6B7BA100003;
        Tue,  2 May 2023 09:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1683018792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cTsiNdQARo/z9CMsBoYCeGv0nTsLesfw9gMpci+Ue0I=;
        b=aebRvkA+jKs8ng2kCrdYpQhnqKBThs9ansbOycCByzxjmJZ07Vijvuue6Z45z92YhRHa/r
        tCDDyi3SExBbOQNqb/y5Ly0gB0CtltdDy8kcpoI0xQ7HibpPZv8NrPggQgvV5fbSJc0+Me
        r8B1GeftYynANsc7UisnK0ILaNmAbVLzFk1Oy5bcF4R7OJ19ZmULjCXZFCZhAqdpekPsam
        P+Fh0445OFIYmIVCq9XhYKv6J9bipghlXj3zqrPp7G8ffq3BARxNNvx1ATn+kKjR1eJ8kn
        kCnAgzMtbilu7qWUL6f7Bcq29Scgpyvd/k6Y+K1/5xd8+8toVuP1/30Mlgp7OQ==
Date:   Tue, 2 May 2023 11:13:09 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Vadim Fedorenko <vadim.fedorenko@linux.dev>, kuba@kernel.org,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vladimir.oltean@nxp.com, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
Message-ID: <20230502111309.0f533510@kmaincent-XPS-13-7390>
In-Reply-To: <CAP5jrPH1Xn5Sja8wqB_oybrv6mubaP+nhpOjRHN8TCDW2=Auhw@mail.gmail.com>
References: <20230423032437.285014-1-glipus@gmail.com>
        <20230426165835.443259-1-kory.maincent@bootlin.com>
        <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
        <20230427102945.09cf0d7f@kmaincent-XPS-13-7390>
        <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
        <20230428101103.02a91264@kmaincent-XPS-13-7390>
        <CAP5jrPH1=fw7ayEFuzQZKXSkcXeGfUy134yEANzDcSyvwOB-2g@mail.gmail.com>
        <4c27d467-95a3-fb9a-52be-bcb54f7d1aaf@linux.dev>
        <CAP5jrPE8rriDGVrXwszj8DrrGvmRaqnbRzWuCTfhpt4g9G9FLw@mail.gmail.com>
        <CAP5jrPH1Xn5Sja8wqB_oybrv6mubaP+nhpOjRHN8TCDW2=Auhw@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 May 2023 22:44:22 -0600
Max Georgiev <glipus@gmail.com> wrote:
 
> Is it better this time?
> https://lore.kernel.org/netdev/20230502043150.17097-1-glipus@gmail.com/

Yes it is, thanks!
