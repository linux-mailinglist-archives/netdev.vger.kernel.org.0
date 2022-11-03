Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB2161832C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiKCPoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiKCPoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:44:04 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A2E65DD
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:44:02 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-13bd19c3b68so2586403fac.7
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 08:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jyi7kddwY824pPpQokNOgMXLwnia/FN5Ke8YFyXNTvI=;
        b=jMbi75qkrKSkJsn/sY+LoqEx3SL5qSrXl+o86foMD1tYG0DUj++mxp3LOOmDdTFk0T
         9gvs1sLTYl+BlOd+I+FuIcr5FrKpj1fSX1I6K1mCXqMVsWBuaNLUz+QGmdsQQrM0V2tm
         t3QPwU7z6oZk026+ZeLKOPQQlni5IOD2KF/7jc06CN4DKXgBEgmJHHDeBSBRN9dBB3Fn
         bNsDZGjbsJoJNBKJqLxnOjWc0Yw5LZ0A4Pc1JKTF8932jiGrwGDfiKX9uLPswVTpGTAE
         QIHS6xODUe517Bj9y/V4D1v01xRUNu3eRJCjq5Ts/TyhCRhHhz0RsVlNVtr+wSjbRfDQ
         LAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jyi7kddwY824pPpQokNOgMXLwnia/FN5Ke8YFyXNTvI=;
        b=PR5/ToVSBeUvaSG4IEKvPqszYJCY1trH8mwCYVFT2M+gWVZFGg94R38ym1WEyW6GwP
         aDjZ8qZ0a7bf5JxMIoTsmsc1/9Tkiuze+ccyH3sBixb44H29Wrt1i6zK/vKkSUm7eeSq
         i5/PxBretJIWsH91LsXv6qxsAp3BCFyHW3xIZEVhkz5z1nEI/5oIhWuQ1FgqWPTaV8vo
         L6xHAmDNVD4I8QK8FqbKqEWM0BG7f7Qm2Y864Smx5Xy+UO/tdF6Srp7GsU72V7GaLJbx
         WvQXxlP5Yf4S3DU7nhIE8DGboWGaPmyJYbS5IZ/g0k8wx7bqSTXZ+RDTRfJ/hwu36csK
         q43w==
X-Gm-Message-State: ACrzQf3kYIguMTcKTKgubdigXxewF9n9wzekHLw1N5e3jbKHexJOGJva
        ldgYRrgkB9w2HOnGEyZKVKM1CnLaJSo45GPwYFk=
X-Google-Smtp-Source: AMsMyM5bwzCm6+mnOORkfy06xmJ1D2JAPDF0uG/LrCO9rewiQFpmyvzS+G1F03jRClSjT0HSt6GTCOEubYiKIQbO8pk=
X-Received: by 2002:a05:6870:523:b0:131:2d50:e09c with SMTP id
 j35-20020a056870052300b001312d50e09cmr28724388oao.129.1667490240674; Thu, 03
 Nov 2022 08:44:00 -0700 (PDT)
MIME-Version: 1.0
References: <Y2OmQDjtHmQCHE7x@pevik>
In-Reply-To: <Y2OmQDjtHmQCHE7x@pevik>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 3 Nov 2022 11:43:36 -0400
Message-ID: <CADvbK_cA=7czAvftMu9tn+SkDp9-NpdyxeKsf70U8WO7=0i22g@mail.gmail.com>
Subject: Re: ping (iputils) review (call for help)
To:     Petr Vorel <pvorel@suse.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 7:30 AM Petr Vorel <pvorel@suse.cz> wrote:
>
> Hi,
>
> I'm sorry to bother you about userspace. I'm preparing new iputils release and
> I'm not sure about these two patches.  As there has been many regressions,
> review from experts is more than welcome.
>
> If you have time to review them, it does not matter if you post your
> comments/RBT in github or here (as long as you keep Cc me so that I don't
> overlook it).
>
> BTW I wonder if it make sense to list Hideaki YOSHIFUJI as NETWORKING
> IPv4/IPv6 maintainer. If I'm not mistaken, it has been a decade since he was active.
>
> * ping: Call connect() before sending/receiving
> https://github.com/iputils/iputils/pull/391
> => I did not even knew it's possible to connect to ping socket, but looks like
> it works on both raw socket and on ICMP datagram socket.
The workaround of not using the PING socket is:

# sysctl -w net.ipv4.ping_group_range="1 0"

>
> * ping: revert "ping: do not bind to device when destination IP is on device
> https://github.com/iputils/iputils/pull/396
> => the problem has been fixed in mainline and stable/LTS kernels therefore I
> suppose we can revert cc44f4c as done in this PR. It's just a question if we
> should care about people who run new iputils on older (unfixed) kernels.
cc44f4c has also caused some regression though it's only seen in the
kselftests, and that is why I made the kernel fix. I don't know which
regression is more serious regardless of the patch's correctness. :-).
or can we put some changelog to say that this revert should be
backported together with the kernel commit?

Thanks.
