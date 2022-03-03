Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE154CC929
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiCCWiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiCCWiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:38:19 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD7CD7E
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:37:28 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id t19so2517851plr.5
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 14:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XTxejs+EG+vExahjrOm2Pw4EsNeEa32DLvLgX1Nv9vc=;
        b=xXG5EjKh8EEQ7KVl9NPyczg5bF1+6LR+U4C88bY10+9PLQUjtKNyn591Ijpb7G3684
         Hc5KZlqi4tTdST1r507h9BmguI3HZK9gQkTm7HvLsb/ghtFh/Jg1HhrcoLuRugwWNjne
         Sehz7ggHpFOEj3CovPpfge0YS3j6t14pgJ+31v1rJdQVmAE/QhfRYBFAfwzPH+YvlvK0
         gYcNKyZdSv7gNCJ1AacZC2qt6esjCRUlyI8gTXryyRuTE90qroVioa70FS9ABegdOJFf
         nBIm2b5g0COhucpbBaWzmp8+6sVGJ0HdIFynHYsModRJg/eeybaBk4MmdaC+c6yQbv01
         Y9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XTxejs+EG+vExahjrOm2Pw4EsNeEa32DLvLgX1Nv9vc=;
        b=hSKQDKKfqMm4VCz1bD+VarNjtoErwmsbBbTNg94Z0cnXdaX69ug8tqpipMsOiG3Q77
         XT2OoV6hXceuzYwXoo2S4Psnq4JxQxLVCnMgzGfd+NfbEWbzMkGk2gnPeZ0rBbZbs9hN
         rvXBBP7P0k86/i0mNH7OK+I5D0mkBhmfUAcmStWG7jET0Op5WTsRXniKfTbjkG3NtjYS
         7IotPAICa0lxldp+WiJyE1txxyQ6E7Jdi1atmTVK5j/PLTyJ1gULjNzR5UUim/Xk03UO
         VkJOVuDJg0utliuJmkKJ5ktZogH/ljHiEMqykrh2IdYe9ABuXeRtu/S8EyKZHomEEov9
         ft/A==
X-Gm-Message-State: AOAM531TfiEiJgtJkSG3g47JiE3HOgnWj0Q2Gr4F+l8qpmb4T58LyOjx
        MmbeLq6NDptb4rJ5CK71PLirvg==
X-Google-Smtp-Source: ABdhPJwAHH1r/bn/1Ke76IhAqBLP3og73SuNY96pUxm03BSoFt8AEk3xPueSocQjlWoemaZCuSYDeA==
X-Received: by 2002:a17:903:2342:b0:151:6dbc:9c5f with SMTP id c2-20020a170903234200b001516dbc9c5fmr21403392plh.81.1646347048025;
        Thu, 03 Mar 2022 14:37:28 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id a12-20020a056a000c8c00b004e1a76f0a8asm3524910pfv.51.2022.03.03.14.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:37:27 -0800 (PST)
Date:   Thu, 3 Mar 2022 14:37:24 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     maxime.deroucy@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ipaddress: remove 'label' compatibility
 with Linux-2.0 net aliases
Message-ID: <20220303143724.1dd71f20@hermes.local>
In-Reply-To: <f0215a333fd80102cfab9c560fc2872e8eddb079.camel@gmail.com>
References: <f0215a333fd80102cfab9c560fc2872e8eddb079.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Mar 2022 23:14:55 +0100
maxime.deroucy@gmail.com wrote:

> As Linux-2.0 is getting old and systemd allows non Linux-2.0 compatible
> aliases to be set, I think iproute2 should be able to manage such
> aliases.
> ---
> =C2=A0ip/ipaddress.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 16 ----------------
> =C2=A0man/man8/ip-address.8.in |=C2=A0 3 ---
> =C2=A02 files changed, 19 deletions(-)

Agree that iproute2 shouldn't enforce restrictions that kernel does not.
