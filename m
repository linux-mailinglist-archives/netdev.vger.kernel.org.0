Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697D16176AC
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiKCGUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiKCGUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:20:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4DD11A13;
        Wed,  2 Nov 2022 23:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5D361D44;
        Thu,  3 Nov 2022 06:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8C5C433C1;
        Thu,  3 Nov 2022 06:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667456407;
        bh=1/ZTNSeHhw7KZLpujNODYcl9QDOvXgizgyblR1U3cD8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S4Z7ONY9cUPZGYaMJXhzIz2YJCelF5P5Pfl/zmJs0c0oMS8FTM8F1H+GqtWVSnPUi
         NQWH2ZueGu7l+Puz3/BoOz3mMDvZWkeARnLNNbC5JCquR0KfUgEqqxh0SoieUkc+dh
         gGcyWAzNc5PsQj8soJyY/DDmz4g/7WjMgyefKOVm1Gf9qxBmVI/tnZIZeWAIJapytx
         bJ0leI2q9hy/eFxj4SnETfDWTaU99+uXVLW1GW7e/MwyXIjPNbLRS0A2LQGd4Cklya
         r2sngcaEwvzhcQNVRRUbo6tOE7hEnF5KVGoSiME/r6MbPbRu4UFmXPyCq88ej2VfPQ
         eAJpM+o1tfa1g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ath11k (gcc13): synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
References: <20221031114341.10377-1-jirislaby@kernel.org>
        <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
        <833c7f2f-c140-5a0b-1efc-b858348206ec@kernel.org>
        <87bkprgj0b.fsf@kernel.org>
        <503a3b36-2256-a9ce-cffe-5c0ed51f6f62@infradead.org>
        <87tu3ifv8z.fsf@kernel.org>
        <1041acdb-2978-7413-5567-ae9c14471605@infradead.org>
Date:   Thu, 03 Nov 2022 08:20:00 +0200
In-Reply-To: <1041acdb-2978-7413-5567-ae9c14471605@infradead.org> (Randy
        Dunlap's message of "Tue, 1 Nov 2022 10:54:11 -0700")
Message-ID: <87cza4ftkf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

>>>> Yeah, using "wifi:" is a new prefix we started using with wireless
>>>> patches this year.
>>>>
>>>
>>> It would be nice if that was documented somewhere...
>> 
>> It is mentioned on our wiki but I doubt anyone reads it :)
>
> I think that you are correct. ;)
>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject
>> 
>> Do let me know if there are other places which should have this info.
>
> Ideally it would be in the subsystem's profile document as described in the
> MAINTAINERS file:
>
> 	P: Subsystem Profile document for more details submitting
> 	   patches to the given subsystem. This is either an in-tree file,
> 	   or a URI. See Documentation/maintainer/maintainer-entry-profile.rst
> 	   for details.
>
> although that seems to be overkill IMHO just to add a prefix: setting.
>
> You could just clone some other maintainer's Profile document and then modify it
> to anything that you would like to have in it as far as Maintaining and patching
> are concerned.

Ah, we should add that doc for wireless. Thanks for the idea, I added
that to my todo list.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
