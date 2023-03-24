Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B95D6C8808
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjCXWFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjCXWFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:05:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADD61EBDF;
        Fri, 24 Mar 2023 15:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22DFE62CC4;
        Fri, 24 Mar 2023 22:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C2BC433EF;
        Fri, 24 Mar 2023 22:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679695520;
        bh=bHtLSxf1+00+J1kjv0ObnAA8CG7DEK3gYRH0zPPL/3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r5lqPtnbqTtRkpxIz/PGgPe+Tr12ln9NCPVWJzeeSdHT5hK6hl89xsC/D4N+SfqGR
         qordnAiel56SmaNATY1w3gta1UWQ8frg06Un91AbdhEuyGuVH27pfTigaoh8PxtMfv
         YCEp2lTet1Iaf/z0kDV0x69HL7xoSsSbE/I666KORuP9YcpyP+SGwzt4q9aQOEo24B
         PvOiacYjDPk3NhhTNlhfNwhHkhlGMN+HnoUaIK1pwyT0AHp4n+BUNiPyjuD+eY5ugR
         eSWmhnJFW38jF/C4DOIGsM553fSLDY/FdkVTXtmldkK8fEm2IW+jEhq9NLo62hZ1Be
         3stdKAube8uqA==
Date:   Fri, 24 Mar 2023 15:05:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] net: dsa: b53: mdio: add support for BCM53134
Message-ID: <20230324150519.53b9cc4b@kernel.org>
In-Reply-To: <20230324084138.664285-1-noltari@gmail.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
        <20230324084138.664285-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 09:41:36 +0100 =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> This is based on the initial work from Paul Geurts that was sent to the
> incorrect linux development lists and recipients.
> I've simplified his patches by adding BCM53134 to the is531x5() block sin=
ce it
> seems that the switch doesn't need a special RGMII config.

In the future please don't send the new version in-reply to.
Makes it harder to organize patches that need review for maintainers.
Or at least IDK how to maintain a queue ordered by submission date=20
when people do this :\
