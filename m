Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1800F4F134D
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358205AbiDDKvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358102AbiDDKvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A090B245A2;
        Mon,  4 Apr 2022 03:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47A5360A6B;
        Mon,  4 Apr 2022 10:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C73C2BBE4;
        Mon,  4 Apr 2022 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649069366;
        bh=Tg/7nsozYJMVjYgrbfpH7tAtgVHE6SnY/UIB0mnrigY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SwhWMfyydbmJp2hY+ZZ4j6WF7IybX5d8/wpSryAk7HBA6VniYnIfkHipsat5tvMRt
         mdqoG4M5YuEXX2LN0zK1/bVPX05KQEDf4m0dz9FDK9KU3JJi3V0VJPCQ+IDLXXDmhj
         mGdYVry69ZBmAp+0KtlaM4W4QcRY+2zvFqnbUilZ6lQrCzyHY98lsuf0SzFNR+gBY9
         GAefiwHpJiCbt4HRlPtBXMTksimSY4JxS6U7Pqlt6gGwUO0RRzMY5dtvEpni00J+uQ
         M9+otsDu3HNoY1dlWCYHVoiDmYWFYgsgX1G+1UKYleh4H55h/srbAk3iHWmUwO/wPk
         22zf7J/RHPYvA==
From:   Kalle Valo <kvalo@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
        <YhojjHGp4EfsTpnG@kroah.com> <87wnhhsr9m.fsf@kernel.org>
        <5830958.DvuYhMxLoT@pc-42>
Date:   Mon, 04 Apr 2022 13:49:18 +0300
In-Reply-To: <5830958.DvuYhMxLoT@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Mon,
        04 Apr 2022 11:31:23 +0200")
Message-ID: <878rslt975.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
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

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Saturday 26 February 2022 14:15:33 CEST Kalle Valo wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>=20
>> > That sounds great to me, let's plan on that happening after 5.18-rc1 is
>> > out.
>>=20
>> Very good, we have a plan then. I marked the patch as deferred in
>> patchwork:
>>=20
>> https://patchwork.kernel.org/project/linux-wireless/patch/20220226092142=
.10164-2-Jerome.Pouiller@silabs.com/
>>=20
>> Jerome, feel free to remind me about this after v5.18-rc1 is released.
>
> v5.18-rc1 is released :)

Thanks for the reminder :) Once we open wireless-next I'll start
preparing the branch.

Dave&Jakub, once you guys open net-next will it be based on -rc1? That
would make it easier for me to create an immutable branch between
staging-next and wireless-next.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
