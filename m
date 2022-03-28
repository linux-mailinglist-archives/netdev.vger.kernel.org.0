Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63AF4E9932
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243738AbiC1OTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiC1OTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:19:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AC127B2E;
        Mon, 28 Mar 2022 07:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 795EBB81120;
        Mon, 28 Mar 2022 14:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D761C004DD;
        Mon, 28 Mar 2022 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648477078;
        bh=eaTXhf1qYpLaigtqnuzsS+jfI6S6R315R8J6y/idT9c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BMCIv86PYe9CKLSsXmv8emZs3/B+yfgoPHGYH5/GHBSHI5lPglIrQgmijWB4OwH+G
         LYbghOBTe1O8BATYD89pzfQupCg+uNDVwGWuJnwkUzpDMp95ntNTr1V+u1mFyxdwql
         Wo1JHynwfwvXV5u57uqzfciaOpplbrnIYoolu//CF/D3N8BLnNvL/gnpCyggIReF4O
         p39ijz3fm+HlI+4BGcOL54Rib9SGiJ7T8hzNZZncaNd9cQMwKWg+wAJ9vk+zXh76lW
         RRHhllS5bZDXIv2wqtAXT53Sbe/vw4OwqiYFOIWVN8QGOTfrOEx0wxwqp3q0Xcgt3U
         rroUlAZd2Y4kg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     trix@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: initialize arrays at compile time
References: <20220328130727.3090827-1-trix@redhat.com>
        <877d8eyz61.fsf@kernel.org> <87lewu5fw7.fsf@toke.dk>
Date:   Mon, 28 Mar 2022 17:17:53 +0300
In-Reply-To: <87lewu5fw7.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Mon, 28 Mar 2022 16:08:08 +0200")
Message-ID: <87pmm6xisu.fsf@kernel.org>
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

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Kalle Valo <kvalo@kernel.org> writes:
>
>> Hi,
>>
>> The content type on this email was weird:
>>
>> Content-Type: application/octet-stream; x-default=3Dtrue
>
> Hmm, I get:
>
> Content-Type: text/plain; charset=3D"US-ASCII"; x-default=3Dtrue

Heh, strange.

> Patchwork seems to have parsed the content just fine, but it shows *no*
> content-type, so maybe the issue is that the header is missing but
> different systems repair that differently?

Yeah, I'm using Gnus which is pretty exotic :) It might be choosing
octet-stream for me.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
