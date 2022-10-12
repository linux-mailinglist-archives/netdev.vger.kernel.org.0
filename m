Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FB15FCC66
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 22:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiJLUtD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Oct 2022 16:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJLUtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 16:49:01 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6CC140A5
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 13:49:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 26635141165;
        Wed, 12 Oct 2022 22:48:59 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id pq_8OGRTtt55; Wed, 12 Oct 2022 22:48:53 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id CCB80141056;
        Wed, 12 Oct 2022 22:48:53 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 711B661494; Wed, 12 Oct 2022 22:48:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 69D3A6138A;
        Wed, 12 Oct 2022 22:48:53 +0200 (CEST)
Date:   Wed, 12 Oct 2022 22:48:53 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <3660fc5b-5cb3-61ee-a10c-0f541282eba4@gmail.com>
Message-ID: <c18b3a75-95cc-a35c-7a2c-fb4ec0b18b84@tarent.de>
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de> <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com> <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de> <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de> <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de> <3660fc5b-5cb3-61ee-a10c-0f541282eba4@gmail.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022, Eric Dumazet wrote:

> This looks wrong (although I have not read your code)
> 
> I guess RTNL is not held at this point.
> 
> Use kfree_skb(skb) or __qdisc_drop(skb, to_free)

Ooh! Will try! That’s what I get for getting, ahem, inspiration
from other qdiscs.

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
