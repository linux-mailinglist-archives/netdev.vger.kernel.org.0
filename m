Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB9963B3EA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiK1VGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiK1VFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:05:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8CB2EF18;
        Mon, 28 Nov 2022 13:05:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C36BE61451;
        Mon, 28 Nov 2022 21:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C30C433D6;
        Mon, 28 Nov 2022 21:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669669552;
        bh=HHhQNukD5ImmOXlQA8Ysq0q8imOTUDS3jWHGNp0yy58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I5chhGw9vJ+OGWhQr/Jsif+sdd5/wZSktrROlOuAdYIVHQ3DwOrmZvUo+JLM/X7Ex
         I3M/id7PfIGrW40Y+AIyNHMV3vxQhdwINwT6Vh1Ar7DN2agQs5u4AlRYVyaZLBPP5w
         6061CFFuLw5KSBnwH/pHXE8YG0+JPFJK2KcO/xQh1SVZKh4dW/1KBm17WRgS9s7osK
         Y1+vmpe9p3MtuqTTYYYV2WmP/+AyoZc1sV4VyQ7vSjSzd6yLaZUO78yCge1DGGKZ9K
         LIgS9t1n5HLCcaAl9BBWaYTiyRRGw46UfNlWH/q8IDalLJp50Z0mvFDZtU+WFELCmS
         06KAyLeNl6MIg==
Date:   Mon, 28 Nov 2022 13:05:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v1 00/26] net: dsa: microchip: stats64, fdb, error
Message-ID: <20221128130550.22162795@kernel.org>
In-Reply-To: <Y4S88w7BNWuWQLdh@lunn.ch>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
        <Y4S88w7BNWuWQLdh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 14:51:47 +0100 Andrew Lunn wrote:
> * don=E2=80=99t post large series (> 15 patches), break them up
>=20
> This seems like something which could easily be broken up.

And name the target tree in the subject tag. And make sure it applies
cleanly to that tree (last patch is to blame AFAICT). And don't repost
within 24 hours.
