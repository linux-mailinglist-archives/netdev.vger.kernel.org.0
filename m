Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2045B6C8A27
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjCYCNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjCYCNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:13:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B93166ED;
        Fri, 24 Mar 2023 19:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C135B826CA;
        Sat, 25 Mar 2023 02:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEA1C433EF;
        Sat, 25 Mar 2023 02:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679710385;
        bh=pmf0kOPCteU34VKogneiwMLY+2uEZ+1uJChrJ77Sq5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I7UEn13y0KsywiclT8kpv6p6tQfxk5RtKw07wMavZaa7cJypulgZ4Y4Fn8Ar+hOxu
         tOpewiwAgY0udprFXlPXKb/WMKXqDFZ4S2N0sHiJaYGftbVKnMZ9bUxzBfJZXvEZj6
         qpdf9ivP0AQ35ZCvkLVzqPRKv/4CZ7SkgrRanHT0J1rXBiRMCSIJWurAgZnfGw2Ecs
         YnI6g3uaTk1XESnWkThETeSlBZuh9+uuWVPYAO8Cy4jmvo9ql7+dVBh7/hQwOhQjRw
         xH8Pqag7mBpq54tkGWybL4PL7b6uwKx3/DTFTbQPKsJs43mlKKd2iJavVTb96pypEE
         rQUN75LIrfqpw==
Date:   Fri, 24 Mar 2023 19:13:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     f.fainelli@gmail.com
Cc:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: b53: mmap: add phy ops
Message-ID: <20230324191304.4d956b58@kernel.org>
In-Reply-To: <20230323194841.1431878-1-noltari@gmail.com>
References: <20230323194841.1431878-1-noltari@gmail.com>
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

On Thu, 23 Mar 2023 20:48:41 +0100 =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> Implement phy_read16() and phy_write16() ops for B53 MMAP to avoid access=
ing
> B53_PORT_MII_PAGE registers which hangs the device.
> This access should be done through the MDIO Mux bus controller.
>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>

Hi Florian, ack? Would be good for the record..
