Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E159A14425
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfEFEr3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 May 2019 00:47:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFEr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:47:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9CABB12D8E1E4;
        Sun,  5 May 2019 21:47:27 -0700 (PDT)
Date:   Sun, 05 May 2019 21:47:27 -0700 (PDT)
Message-Id: <20190505.214727.1839442238121977055.davem@davemloft.net>
To:     ynezz@true.cz
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        matthias.bgg@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, frowand.list@gmail.com,
        srinivas.kandagatla@linaro.org, maxime.ripard@bootlin.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v4 00/10] of_net: Add NVMEM support to
 of_get_mac_address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1556893635-18549-1-git-send-email-ynezz@true.cz>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:47:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr ¦tetiar <ynezz@true.cz>
Date: Fri,  3 May 2019 16:27:05 +0200

> this patch series is a continuation of my previous attempt[1], where I've
> tried to wire MTD layer into of_get_mac_address, so it would be possible to
> load MAC addresses from various NVMEMs as EEPROMs etc.
 ...

Series applied, thank you.
