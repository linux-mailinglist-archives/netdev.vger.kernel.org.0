Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A9D5A55D9
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 23:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiH2VCF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Aug 2022 17:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiH2VCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 17:02:04 -0400
Received: from x61w.mirbsd.org (2001-4dd7-7451-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de [IPv6:2001:4dd7:7451:0:21f:3bff:fe0d:cbb1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667D77E300
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 14:02:03 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id E057324668; Mon, 29 Aug 2022 23:02:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id C912D24667;
        Mon, 29 Aug 2022 23:02:00 +0200 (CEST)
Date:   Mon, 29 Aug 2022 23:02:00 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
cc:     netdev@vger.kernel.org
Subject: Re: continuous REPL mode for tc(8)
In-Reply-To: <87sfle6ad3.fsf@toke.dk>
Message-ID: <ca46133-3cef-5027-2312-9ca5aef65a7@tarent.de>
References: <33c27582-9b59-60f9-3323-c661b9524c51@tarent.de> <87sfle6ad3.fsf@toke.dk>
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

> It already exists; see the '-b' option (RTF man page for details) :)

Ah. Thanks for pointing my nose on it… as I said I wasn’t the one
to dig into invoking the utility. I will tell them.

While not as nice, it will greatly reduce calling overhead.

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
