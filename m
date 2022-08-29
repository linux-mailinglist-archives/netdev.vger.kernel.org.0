Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E8A5A55F5
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 23:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiH2VK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 17:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiH2VKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 17:10:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401AE5072F
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 14:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C596B811F8
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 21:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E1EC433D6;
        Mon, 29 Aug 2022 21:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661807420;
        bh=2/kxATGuVxmZfHHMGZlMaEcdN5a30TTWXSimCgKX8SM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=m7kAm6Ng6OyONXqqm4zsU3B+vM7l2eqtMjEbx2XTEG7x+hib+TSRTcumV+zz2M1v6
         jT1OmXgwtq4uU/bsIs65qvvTAUGTBXZmb6ubn5NjrSHN6gNFR42Tw56HaQvv/i4bFx
         2ZpCPTIXdZVsEtWs3DIz+lF4I4siykYOnMBzpDkz9jkOCTO4tmhFYMxApvhc6cAeEd
         L9wDPSxsPCy9q7rkixs71sMsk9XBE15LbY3PlidZlI09fGdXlsLQOSQWyAG684pJUe
         1g3iMKYJw3+MEJ0pkX/U3kGL/4dLjBhXQST+Hjn86t9SSqWA1OdbvzZM+T3SKB7hjZ
         9hGV3Nxj4bCGQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EB87D588819; Mon, 29 Aug 2022 23:10:16 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     netdev@vger.kernel.org
Subject: Re: continuous REPL mode for tc(8)
In-Reply-To: <ca46133-3cef-5027-2312-9ca5aef65a7@tarent.de>
References: <33c27582-9b59-60f9-3323-c661b9524c51@tarent.de>
 <87sfle6ad3.fsf@toke.dk> <ca46133-3cef-5027-2312-9ca5aef65a7@tarent.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Aug 2022 23:10:16 +0200
Message-ID: <87mtbm69jb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thorsten Glaser <t.glaser@tarent.de> writes:

> On Mon, 29 Aug 2022, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> It already exists; see the '-b' option (RTF man page for details) :)
>
> Ah. Thanks for pointing my nose on it=E2=80=A6 as I said I wasn=E2=80=99t=
 the one
> to dig into invoking the utility. I will tell them.

You're welcome :)

> While not as nice, it will greatly reduce calling overhead.

If you want to lower overhead even further, you can always use a netlink
library and send the messages to the kernel directly...

-Toke
