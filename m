Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C625FD78
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 21:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfGDTes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 15:34:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfGDTes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 15:34:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E66D2143B8014;
        Thu,  4 Jul 2019 12:34:47 -0700 (PDT)
Date:   Thu, 04 Jul 2019 12:34:47 -0700 (PDT)
Message-Id: <20190704.123447.693100990166600946.davem@davemloft.net>
To:     paweldembicki@gmail.com
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] net: dsa: Add Vitesse VSC73xx parallel mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190703171924.31801-1-paweldembicki@gmail.com>
References: <20190703171924.31801-1-paweldembicki@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jul 2019 12:34:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pawel Dembicki <paweldembicki@gmail.com>
Date: Wed,  3 Jul 2019 19:19:20 +0200

> Main goal of this patch series is to add support for parallel bus in
> Vitesse VSC73xx switches. Existing driver supports only SPI mode.
> 
> Second change is needed for devices in unmanaged state.

Please respin with the documentation description changes suggested
in the review for this series.

Thanks.
