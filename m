Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3006482655
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 03:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiAACa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 21:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiAACa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 21:30:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900CFC061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 18:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C3D9B8119C
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 02:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0A4C36AEC;
        Sat,  1 Jan 2022 02:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641004224;
        bh=uOdObBAZVC0OciqtcaVwY8rYYZi2rkc3D7X4jOD/h/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vE6lbQot8oD+TgV3swlQ9ke/f3gYio7Sro8R6o7mZ4fSF3uEoP2+Hoz8lvR8VtLcC
         H9V6XuynYHVc0oEvf+BG3EbKoyWe0/1SSCPU+ZLs8sXbW7Y1EDh2K015wOk9wy5jRv
         Ja9e9kO6tY+mMGZShr1hz7HyX/74i95DQksHDzSr0/j8FF2+7rx1LKBdwTxtNX5mYc
         jWmr/DRiWc0AW8d4oxNmdZsEGDGB7jeJk0F+jCosdK+JylSnXm56xDkW+N87X8gn00
         m7lFcysDss77aRoq1q23gLZUA7Ag+8JGgrUNjmXngjQrJwq5tybY9Zl3025LDbG2i6
         +HzUSxI4yokIA==
Date:   Fri, 31 Dec 2021 18:30:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next 00/13 v3] net: dsa: realtek: MDIO interface and
 RTL8367S
Message-ID: <20211231183022.316f6705@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211231043306.12322-1-luizluca@gmail.com>
References: <20211231043306.12322-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021 01:32:55 -0300 Luiz Angelo Daros de Luca wrote:
> Subject: [PATCH net-next 00/13 v3] net: dsa: realtek: MDIO interface and RTL8367S

Would you mind reposting with the subject fixed? It says 00/13 even
though there is only 11 patches. That confuses patchwork into expecting
13 patches and considering the series incomplete.
