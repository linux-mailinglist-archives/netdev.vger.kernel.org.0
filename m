Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3DA577DFB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbiGRIvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGRIvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:51:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1BDE5B;
        Mon, 18 Jul 2022 01:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2A2AB8106E;
        Mon, 18 Jul 2022 08:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E09AC341C0;
        Mon, 18 Jul 2022 08:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658134269;
        bh=8OcSldP5MdP1ragykkXMMIrZpPvWJ7ED+acz8DAaOX8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=F4USemY0SFc+vfITUtHqCy72rC+SgZ4Lxr06fhi+c2gk2z04gr2BaY88n3YOwYsLv
         sZHwbnEpm1SLmOBgOifnIgjXlnPM4llRHnRErjY3GgNRfugo4ueRb8NnDKDXYkUqGM
         nJA/cBW6v0rxwhEGGJRHgeAkrTt2IXksSD1g6xb7lgTkWP8tHvYQeXe4cWF2TFZL/x
         oqvLEfGSswtObg+X7xtQvSz7aBA8kPYsXp9EFBxKefL0kdDiPgBTReC9uAM6VNa9jX
         sCX2rURrghIcmzPfRBy/ohI72DlE0cM3B90W9lwW5nuXDjVk7jtgGpWPZbX2z8DViw
         3PswjtAjbTHOw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Arend Van Spriel <aspriel@gmail.com>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/76] wifi: more MLO work
References: <20220713094502.163926-1-johannes@sipsolutions.net>
        <e9ecb9c8-cb5b-d727-38d6-ef5a0bf81cef@gmail.com>
        <3ac3c91120a128f66ca3806294f6a783e0f1131f.camel@sipsolutions.net>
Date:   Mon, 18 Jul 2022 11:51:04 +0300
In-Reply-To: <3ac3c91120a128f66ca3806294f6a783e0f1131f.camel@sipsolutions.net>
        (Johannes Berg's message of "Thu, 14 Jul 2022 10:30:19 +0200")
Message-ID: <87k08ast1j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2022-07-14 at 10:26 +0200, Arend Van Spriel wrote:
>> 
>> Just for my own patch submit process. What is the reason I am seeing the 
>> "wifi:" prefix being used with patches on linux-wireless list? Is there 
>> other wireless tech used, eg. "bt:" or so?
>> 
>
> Well, we had a discussion with Jakub, and he kind of indicated that he'd
> like to see a bit more generic prefixes to clarify things.
>
> We've kind of been early adopters to try it out and see what it looks
> like, he hasn't pushed it and wanted to have a discussion (e.g. at LPC
> or netdevconf) about it first, but it kind of makes sense since not
> everyone can know all the different drivers and components.

I have been supposed to document this in the wiki and announce it
properly, but as usual I was too busy before the vacation to do
anything. And now I'm on vacation and trying to enjoy the 13 C of
"warmth" here in Finland :D

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
