Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAE058F064
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiHJQ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 12:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHJQ0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:26:45 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BED6068D
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:26:44 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so3588255pjz.1
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc;
        bh=EZ+WBr0qGZVoZVLevihgiL8JBl1UPJEz+cHX75k2HQk=;
        b=J5KZp06pEfYjXfh/GYxStpebb24XWsHC0knDzmN0zgYu0L9CfLtC6EeouKWLUntucp
         53x5KgBwpHDSlXdaIfR0fTibSJIInvd1fwRqpDq2t29DqkRkrzRxrOJfRLDa6DeMEXzk
         a4yYYAScxbKSMLjKCL6B96jL7OnqynB1NH7ZGTfnYs/Si8Vg/c0Zjpj8vnW+FV8cESEc
         tRxcIeiB/gFqVTzHHb9ZUVlhDPGvpFXigcMyuwsCvvTElaEye6oGTP7zRCt9BpjcmvcT
         s44+W2wOy6JZfLLbZv9GnTr7LnesaSw3H2Ii65Fb6lJ+viyTOQzxKllS6Fxpcn+nmQpc
         QGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=EZ+WBr0qGZVoZVLevihgiL8JBl1UPJEz+cHX75k2HQk=;
        b=5izA0GnCrv42vLGC0avmoHLkhkCGKY2N2Vb0AceomLeVuDlm0BbNGOJe5jxmcsHsmy
         kK8P/7NhOU+DobcmyZZmxofr/7NPwcU0ejDPwCZ+wG2AjcbOoXlC3+45GILjslUDtDbt
         GXkRhdR5EpqQtdVkIzKU6ckXFF7Zh6mgOSEMeoU+c2JC34wba9ZhRE1LiZB+nrfRhKQX
         GN78FKv4PttYOQenVp87Z3o9YeutjbUEqqgHm7OIeuvh0o14vzyn2+WQuSA2ge3BPPNJ
         9MpLk+MV1/+TPKfgLf7ntkfWkd2ib0kccqrooTmvxgND/AtswzhBwWGBRWC3t7WcF1fI
         Gqlw==
X-Gm-Message-State: ACgBeo0B/Jrou7aIOxq/EzMgD3RuLlDxjfRtOaw43jj5lImBmzHY6XIg
        PDszFo3AzVW73Uf3kSgLzQE=
X-Google-Smtp-Source: AA6agR7t8BzosMSgoao7MH31NGxNbM+Ibqp61bcQ/V4fL342C2BPHLGXVMgDyOgbqD7wQWdkvNWPuQ==
X-Received: by 2002:a17:902:8543:b0:16d:ac6b:34f8 with SMTP id d3-20020a170902854300b0016dac6b34f8mr28617343plo.88.1660148804135;
        Wed, 10 Aug 2022 09:26:44 -0700 (PDT)
Received: from [192.168.254.16] ([50.39.168.145])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0016dc6279ab8sm12959446pld.159.2022.08.10.09.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 09:26:43 -0700 (PDT)
Message-ID: <d585f719af13d7a7194e7cb734c5a7446954bf01.camel@gmail.com>
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
From:   James Prestwood <prestwoj@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Wed, 10 Aug 2022 09:26:43 -0700
In-Reply-To: <0fc27b144ca3adb4ff6b3057f2654040392ef2d8.camel@sipsolutions.net>
References: <20220804174307.448527-1-prestwoj@gmail.com>
         <20220804174307.448527-2-prestwoj@gmail.com>
         <20220804114342.71d2cff0@kernel.org>
         <b6b11b492622b75e50712385947e1ba6103b8e44.camel@gmail.com>
         <f03b4330c7e9d131d9ad198900a3370de4508304.camel@gmail.com>
         <0fc27b144ca3adb4ff6b3057f2654040392ef2d8.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On Tue, 2022-08-09 at 21:04 +0200, Johannes Berg wrote:
> On Thu, 2022-08-04 at 12:49 -0700, James Prestwood wrote:
> > > > 
> > > > The semantics in wireless are also a little stretched because
> > > > normally
> > > > if the flag is not set the netdev will _refuse_ (-EBUSY) to
> > > > change
> > > > the
> > > > address while running, not do some crazy fw reset.
> > > 
> > > Sorry if I wasn't clear, but its not nl80211 doing the fw reset
> > > automatically. The wireless subsystem actually completely disallows
> > > a
> > > MAC change if the device is running, this flag isn't even checked.
> > > This
> > > means userspace has to bring the device down itself, then change
> > > the
> > > MAC.
> > > 
> > > I plan on also modifying mac80211 to first check this flag and
> > > allow
> > > a
> > > live MAC change if possible. But ultimately userspace still needs
> > > to
> > > be
> > > aware of the support.
> > > 
> 
> I'm not sure this is the right approach.
> 
> For the stated purpose (not powering down the NIC), with most mac80211
> drivers the following would work:
> 
>  - add a new virtual interface of any supported type, and bring it up
>  - bring down the other interface, change MAC address, bring it up
> again
>  - remove the interface added in step 1
> 
> though obviously that's not a good way to do it!
> 
> But internally in mac80211, there's a distinction between
> 
>  ->stop() to turn off the NIC, and
>  ->remove_interface() to remove the interface.
> 
> Changing the MAC address should always be possible when the interface
> doesn't exist in the driver (remove_interface), but without stop()ing
> the NIC.
> 
> However, obviously remove_interface() implies that you break the
> connection first, and obviously you cannot change the MAC address
> without breaking the connection (stopping AP, etc.)

> Therefore, the semantics of this flag don't make sense - you cannot
> change the MAC address in a "live" way while there's a connection, and
> at least internally you need not stop the NIC to change it. Since
> ethernet has no concept of a "connection" in the same way, things are
> different there.

There isn't a need for changing the MAC when connected/scanning, as
this doesn't make much sense. I guess "live" can be interpreted
differently, but my interpretation is simply changing the MAC when the
device isn't powered off. IFF_POWERED_ADDR_CHANGE, maybe, is better
suited.

> 
> Not sure how to really solve this - perhaps a wireless-specific way of
> changing the MAC address could be added, though that's quite ugly, or
> we
> might be able to permit changing the MAC address while not active in
> any
> way (connected, scanning etc.) by removing from/re-adding to the driver
> at least as far as mac80211 is concerned.

Ok, so this is how I originally did it in those old patches:

https://lore.kernel.org/linux-wireless/20190913195908.7871-2-prestwoj@gmail.com/

i.e. remove_interface, change the mac, add_interface. 

But before I revive those I want to make sure a flag can be advertised
to userspace e.g. NL80211_EXT_FEATURE_LIVE_ADDRESS_CHANGE. (or
POWERED). Since this was the reason the patches got dropped in the
first place.

> 
> johannes


