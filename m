Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76F05812EB
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbiGZMO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiGZMO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:14:26 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB78B33A0E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 05:14:24 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b16so9839078lfb.7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 05:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JSI3fstLoaSfTHtz4CWJBKNvtmx7kMrfr48Gh9Ol0TQ=;
        b=TsFmCxgmvQsod+IwsLbWbfb1opLHnzXLtlD3ojDopwudHQF35HTFuSQ8tXiUK+utAk
         H4Sxf89oATVd7Yufd3uHAqXJUqWK8jp5f9eLo0lTKylDHw8yJo0Kjb0E1EAql0AVZ8S0
         ZYPE9dkdjxYsuLgiVmyJNdIdCDXY986c+5uW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JSI3fstLoaSfTHtz4CWJBKNvtmx7kMrfr48Gh9Ol0TQ=;
        b=f8AseQ/HSC6lrQaRKrr/uWXy+zeS4mihoPIlgfh0g/A+HUrRU/gnNaZNadu6HocD3C
         LA7lGA2bb9liG0q6QgiHQ2I9sI1gzDXMFtc5tvJWYxqGP39rHziZoZH3hcsRpOgNatQU
         NRG3THcMyJ147Ds+7rXeNvDybFkGVDaoS/5uQnYwrm2FYh3ai/DCPIn8nF7DS/u8777o
         PK60slZR1HBFym9CqW5/jKGw46v6XKdEWqTmzCZrm2pJbeedDHSK+bG2eK9wPNFYi3fs
         kchi8k3pUnQm7Yig0V/eUfWCRCTauwDRtr26euRfqikr/48CAFX4HRTSAUPnjgBmfO1e
         l3xQ==
X-Gm-Message-State: AJIora/OKp/BuWcqDVAZzvZsKxFKMCxMpzxdWSFeNebvgOlCQUYlDMoB
        EJxp8aDRBXM832diMPDpIIuqnJLtqyM+1sVWBFE3Tg==
X-Google-Smtp-Source: AGRyM1stIwcyq2/Jzo91Z3IR3QJF3vlSX1yPftVAV2G0gU1V/jlIKyA9ek2dBHemm+ULO1qfTwr4uQxZgsk90oIBHHU=
X-Received: by 2002:a05:6512:3503:b0:48a:6060:5ebb with SMTP id
 h3-20020a056512350300b0048a60605ebbmr5902220lfs.429.1658837663080; Tue, 26
 Jul 2022 05:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com> <20220725132514.h3iva4xi4sdncus6@pengutronix.de>
In-Reply-To: <20220725132514.h3iva4xi4sdncus6@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Tue, 26 Jul 2022 14:14:12 +0200
Message-ID: <CABGWkvpQ_5Yz=B0Q=qJGd1vkysntV=449wbv43opvO6=UDrAJw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] can: slcan: extend supported features (step 2)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Mon, Jul 25, 2022 at 3:25 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 25.07.2022 08:54:13, Dario Binacchi wrote:
> > With this series I try to finish the task, started with the series [1],
> > of completely removing the dependency of the slcan driver from the
> > userspace slcand/slcan_attach applications.
> >
> > The series, however, still lacks a patch for sending the bitrate setting
> > command to the adapter:
> >
> > slcan_attach -b <btr> <dev>
> >
> > Without at least this patch the task cannot be considered truly completed.
> >
> > The idea I got is that this can only happen through the ethtool API.
> > Among the various operations made available by this interface I would
> > have used the set_regs (but only the get_regs has been developed), or,
> > the set_eeprom, even if the setting would not be stored in an eeprom.
> > IMHO it would take a set_regs operation with a `struct ethtool_wregs'
> > parameter similar to `struct ethtool_eeprom' without the magic field:
>
> This doesn't feel right.
>
> > struct ethtool_wregs {
> >       __u32   cmd;
> >       __u32   offset;
> >       __u32   len;
> >       __u8    data[0];
> > };
> >
> > But I am not the expert and if there was an alternative solution already
> > usable, it would be welcome.
>
> Have a look at the get/set_tunable() callback:
>
> | https://elixir.bootlin.com/linux/latest/source/include/linux/ethtool.h#L575
>
> You probably have to add a new tunable. Here you'll find the people and
> commits that changed the tunable:
>
> | https://github.com/torvalds/linux/blame/master/include/uapi/linux/ethtool.h#L229
>
> It's usually worth including them in an RFC patch series where you add a
> new tunable and make use of it in the slcan driver.

Thank you very much for the suggestions.
Regards,

Dario
>
> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
