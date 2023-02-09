Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAB7690E80
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBIQkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjBIQkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:40:35 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFE0643F4
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:40:34 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id be8so3430985plb.7
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 08:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zgAupUTIUkcGTHXl4vF3SgLDWPJy334zwFh3M73bvWg=;
        b=naMche/TBdM9CDveyMdduQVBthjDu4YtPASV1RTKIyW0Gu0ltpThtBOf9kDShNez+D
         Rk1MiDaOSUxb9TZBU2pvp1CBOC40YTU28bT/tcgPBXIkQmSjKpDymfgw75jaruYeXR7A
         BW3QuDBkNrl4oGG2ZPyLBxZXyQyPbjFy0fwWftB8gBo6qRZSJg4fjvOvwRhuBzkCKnOm
         jwafKSw+FBKuHJ15m+r1MTgUYj9SVOSBHiI3qXuRiVO4IqT5tcO4wgq2MyasDgKFWBOP
         kmYnadY4OFWVJi19w2p42RP5hur5nvAZRBhrOhPbq15cXOmwzOt6iFvuFxBtnPjzB3Fr
         dvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zgAupUTIUkcGTHXl4vF3SgLDWPJy334zwFh3M73bvWg=;
        b=bl0t1aNgtpDRS702ASNZ1FAOus0VmxTcUrgWkd9wj9XGwfTIG8/oQfH6MMzNeT9WPl
         ch3rpvpNSptALgWA6kP39e9kuZcT2Mk5K8g6PouxJ/c3jh0rOKxgC1027foCP8OiV6/A
         jti1LyckCbfmJVRRhWtfqOaLD1u8iH+sF3AEFvWCeNL+fuqp4ngvHL6BopBGT76GTFaz
         cS3neKefH4sLuxW2hXOuztungkZFmd8/6bCGTPVG5+T+Quv4yotzu4fYoEnDgsgfIvNF
         VDgbeb+VKcv0qg/NuT90I73ADpp3lGw2wM2GROa4zJk8x2tZr4q3jQiAlabXMqXcz5bb
         p+SA==
X-Gm-Message-State: AO0yUKUvCXJFyN8cy+RRKae3PaMcMVwiQ4KLBtPc/RWXQLpNzG+htmmc
        YTPkD6INw4yFj8maXvvlDes=
X-Google-Smtp-Source: AK7set8qzl2JaCzGDjNuTg8vDdGRYdot+l8y3emjcgzBNLm1PvshVhesSFB3mfjbPelp2xCL4E4c7g==
X-Received: by 2002:a17:902:e1d3:b0:199:547c:912f with SMTP id t19-20020a170902e1d300b00199547c912fmr3122617pla.19.1675960834185;
        Thu, 09 Feb 2023 08:40:34 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id ja11-20020a170902efcb00b0019a66bec0d0sm729376plb.188.2023.02.09.08.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 08:40:33 -0800 (PST)
Message-ID: <ac6f253c096c5b6101542d5bbb0e14ddc309ec7d.camel@gmail.com>
Subject: Re: [PATCH net-next v2] net: dsa: realtek: rtl8365mb: add change_mtu
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com
Date:   Thu, 09 Feb 2023 08:40:32 -0800
In-Reply-To: <20230207171557.13034-1-luizluca@gmail.com>
References: <20230207171557.13034-1-luizluca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-07 at 14:15 -0300, Luiz Angelo Daros de Luca wrote:
> rtl8365mb was using a fixed MTU size of 1536, probably inspired by
> rtl8366rb initial packet size. Different from that family, rtl8365mb
> family can specify the max packet size in bytes and not in fixed steps.
> Now it defaults to VLAN_ETH_HLEN+ETH_DATA_LEN+ETH_FCS_LEN (1522 bytes).
>=20
> DSA calls change_mtu for the CPU port once the max mtu value among the
> ports changes. As the max packet size is defined globally, the switch
> is configured only when the call affects the CPU port.
>=20
> The available specs do not directly define the max supported packet
> size, but it mentions a 16k limit. However, the switch sets the max
> packet size to 16368 bytes (0x3FF0) after it resets. That value was
> assumed as the maximum supported packet size.
>=20
> MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
> (where rtl8367s is stacked) can go.
>=20
> There is a jumbo register, enabled by default at 6k packet size.
> However, the jumbo settings does not seem to limit nor expand the
> maximum tested MTU (2018), even when jumbo is disabled. More tests are
> needed with a device that can handle larger frames.
>=20
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>=20
> v1->v2:
> - dropped jumbo code as it was not changing the behavior (up to 2k MTU)
> - fixed typos
> - fixed code alignment
> - renamed rtl8365mb_(change|max)_mtu to rtl8365mb_port_(change|max)_mtu
>=20
>  drivers/net/dsa/realtek/rtl8365mb.c | 43 ++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 4 deletions(-)
>=20

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

