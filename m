Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACE15B4AE8
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 01:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiIJXns convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 10 Sep 2022 19:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIJXnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 19:43:47 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1AC4F69A
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 16:43:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 090D2141188;
        Sun, 11 Sep 2022 01:43:44 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id FAtUK90u4gp1; Sun, 11 Sep 2022 01:43:38 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id A3966141155;
        Sun, 11 Sep 2022 01:43:38 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 470376A8C8; Sun, 11 Sep 2022 01:43:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 4106E6A8C6;
        Sun, 11 Sep 2022 01:43:38 +0200 (CEST)
Date:   Sun, 11 Sep 2022 01:43:38 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Haye.Haehne@telekom.de, Sergey Ryazanov <ryazanov.s.a@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <CAHNKnsQGwV9Z9dSrKusLV7qE+Xw_4eqEDtHKTVJxuuy6H+pWRA@mail.gmail.com>
Message-ID: <cd3867e0-b645-c6cd-3464-29ffb142de5e@tarent.de>
References: <FR2P281MB2959684780DC911876D2465590419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <FR2P281MB2959EBC7E6CE9A1A8D01A01F90419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
 <CAHNKnsQGwV9Z9dSrKusLV7qE+Xw_4eqEDtHKTVJxuuy6H+pWRA@mail.gmail.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

> BTW, the stack backtrace contains only RTNL related functions. Does
> this warning appear when trying to reconfigure the qdisc? If so, then
> the error is probably somewhere in the qdisc configuration code. Such

good point. The qdisc is used in a mode where it’s reconfigured multiple
times per second, although I do not know if my colleague used it like
this or if the issue also happens when statically configuring.

@Haye: does it also crash for you if you don’t run the playlist but just
configure the qdisc with just the tc qdisc add … rate 20m command?

I did not have access to my test VM until today, so I’ll be able to look
into this more next week.

Thanks,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
