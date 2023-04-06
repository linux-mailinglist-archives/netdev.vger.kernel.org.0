Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26C66D9F60
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbjDFR7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDFR7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:59:34 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C6946B3
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:59:32 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A95BE60006;
        Thu,  6 Apr 2023 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680803970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WBNRc8AXcUbJdOV+GD8/113VfbB3bc5y89ep2ms3lAg=;
        b=kQGHeLgaO/aBAdGOKmwhF9oPgIsxxBJjTgVK2tP/13zO3rrAkDbbfyUMYcZ7fo3MTVq06N
        1kJYczvs/e0D2wv6dE3i6Y0CAx4Ifjc69I81omrpWVPS/NMoh1EfXo/y2SKk0b43T4yVcb
        1SZHHhyxdIMENSG0DhxERmXvn308muhOZ0Yu9NJ3lvLQAa65Uu9tNVBJIeZmhVs90DjK7G
        zxstyMSQPqT36EWgQ7Z01BuuLwmGi3OZstV/xtkqgOpUJkyLD/M1YoKJKqG+nNpCRdY61V
        kZ5AXt0DymK9JbsxlKrXnILiXBd/4Rh8VlK8YfId7SDB+Aw8bInxXdmDuIDbog==
Date:   Thu, 6 Apr 2023 19:59:27 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
        vladimir.oltean@nxp.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 0/5] net: Make MAC/PHY time stamping
 selectable
Message-ID: <20230406195927.4a65905f@kmaincent-XPS-13-7390>
In-Reply-To: <20230406173308.401924-1-kory.maincent@bootlin.com>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Apr 2023 19:33:03 +0200
K=C3=B6ry Maincent <kory.maincent@bootlin.com> wrote:

> From: Kory Maincent <kory.maincent@bootlin.com>
>=20
> Up until now, there was no way to let the user select the layer at
> which time stamping occurs.  The stack assumed that PHY time stamping
> is always preferred, but some MAC/PHY combinations were buggy.
>=20
> This series aims to allow the user to select the desired layer
> administratively.

Forgot to run the checkpatch script, sorry for that. There is few coding
style issues.

K=C3=B6ry
