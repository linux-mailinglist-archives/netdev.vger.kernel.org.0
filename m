Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4275A564D
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 23:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiH2Vlv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Aug 2022 17:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiH2Vlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 17:41:50 -0400
Received: from x61w.mirbsd.org (2001-4dd7-7451-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de [IPv6:2001:4dd7:7451:0:21f:3bff:fe0d:cbb1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927D180F72
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 14:41:49 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 922DF247CB; Mon, 29 Aug 2022 23:41:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id E38AF24667;
        Mon, 29 Aug 2022 23:41:46 +0200 (CEST)
Date:   Mon, 29 Aug 2022 23:41:46 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
cc:     netdev@vger.kernel.org
Subject: Re: continuous REPL mode for tc(8)
In-Reply-To: <87mtbm69jb.fsf@toke.dk>
Message-ID: <328cb378-644c-313d-58d6-9e8b128ddc39@tarent.de>
References: <33c27582-9b59-60f9-3323-c661b9524c51@tarent.de> <87sfle6ad3.fsf@toke.dk> <ca46133-3cef-5027-2312-9ca5aef65a7@tarent.de> <87mtbm69jb.fsf@toke.dk>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Aug 2022, Toke Høiland-Jørgensen wrote:

> If you want to lower overhead even further, you can always use a netlink
> library and send the messages to the kernel directly...

I guessed so, but it’s a good thing I didn’t follow that direction
because there’s now two different (Java and Google-Issue9) clients
slash management tools for this, so having tc separate is better.
I’m just doing the low-level part ;-)

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
