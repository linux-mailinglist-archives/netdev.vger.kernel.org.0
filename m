Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712934C2306
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiBXE1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiBXE1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:27:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F371EB322;
        Wed, 23 Feb 2022 20:27:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E24D7B823C6;
        Thu, 24 Feb 2022 04:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F3EC340E9;
        Thu, 24 Feb 2022 04:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645676837;
        bh=fbxCxOuFFyMb3y3/VvVkvZ7wvceN2/V5TgO9GkRoc6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dR2B0aPpPX8lcfae748FZ5gGCAR+7a/7pCaN4F/iE11TLTV+G+ToJUYPbjoHt7IKX
         Qo0RSuhUaQAT44JymKOpyvW9Yk/xUmC2vBmUCLXQX3ydG/gEJtqEll5zsJgZPx3yDQ
         87focREy0G7tHCA79DKRATBi8A5dSOJH5+jL8N1A2phNk8ncsoWip248jTDzBQ9hzT
         wdABF0cy+CIZzaIhcQG1pfWRwrQqLW92HR3fcOWNCU4ehLSqdE9OC2a6ryAZlWc+LN
         m5ltvWw9pI4HlYOYYixrysyMOVL8hhgrA0NAqiSvS0+lg5pOzbFKOeIazqMNTdd2Jr
         wyE9xC9CugBIg==
Date:   Wed, 23 Feb 2022 20:27:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 17/36] can: mcp251xfd: mcp251xfd_chip_sleep():
 introduce function to bring chip into sleep mode
Message-ID: <20220223202716.3c198594@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223224332.2965690-18-mkl@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
        <20220223224332.2965690-18-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 23:43:13 +0100 Marc Kleine-Budde wrote:
> This patch adds a new function to bring the chip into sleep mode, and
> replaces several occurrences of open coded variants.
>=20
> Link: https://lore.kernel.org/all/20220207131047.282110-5-mkl@pengutronix=
.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Build is broken between patch 17 and patch 18 :(

drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c: In function =E2=80=98mcp251=
xfd_chip_stop=E2=80=99:
drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c:644:1: error: no return stat=
ement in function returning non-void [-Werror=3Dreturn-type]
  644 | }
      | ^
