Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FDD535A9E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346118AbiE0Hmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiE0Hmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:42:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40032580C2;
        Fri, 27 May 2022 00:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2DE4B82379;
        Fri, 27 May 2022 07:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B984C385A9;
        Fri, 27 May 2022 07:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653637360;
        bh=kvLjAhJUZwOT1jSXRhS7yxJi0KEXNe4QNcBlgYBEkCk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bfrpP6Z208UuGf0ZWRZOLe8jn9Had31vzTrUGj94sXAnL2AmRM8geJK1tNSzBe1S5
         /AohfMD6pJpkPRB9mGJqyIc6K12BTyqh1BViohz8l6zJNuKmb5i8b8uEp6bVbmqGx4
         s12M6Qc/TnI3fIfv/+KO0bcP1fBXIQoUEvUAo+FwHvXOFZqN0jSNopIZevDQ7MsbNc
         2cjm48JvpCvkVJUU3lRTqplybMnSMEuhBF00HjFx+rlimvOPRIoCTzgaI2ZTzLrJHe
         wEXNlN1P6+H+/ZXTlKHrSFLl/6c21I2XQE1xskvta1EF8eeXJgbxz2axvPx/aSgoux
         8SjkU2pG/FULw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     liuke94@huawei.com, davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH] mac80211: Directly use ida_alloc()/free()
References: <20220527074132.2474867-1-liuke94@huawei.com>
        <a3e0df04-fb94-ef38-c2dc-1c41e6c721d9@wanadoo.fr>
Date:   Fri, 27 May 2022 10:42:33 +0300
In-Reply-To: <a3e0df04-fb94-ef38-c2dc-1c41e6c721d9@wanadoo.fr> (Christophe
        JAILLET's message of "Fri, 27 May 2022 09:32:30 +0200")
Message-ID: <87czfzxvyu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:

> Le 27/05/2022 =C3=A0 09:41, keliu a =C3=A9crit=C2=A0:
>> Use ida_alloc()/ida_free() instead of deprecated
>> ida_simple_get()/ida_simple_remove() .
>>
>> Signed-off-by: keliu <liuke94-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Heh, this email address got me confused :) I guess you (Christophe) use
gmane and it's just some obfuscation done by gmane?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
