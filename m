Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E221BACC
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbfEMQMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:12:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39278 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbfEMQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:12:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89B0514E226DB;
        Mon, 13 May 2019 09:12:37 -0700 (PDT)
Date:   Mon, 13 May 2019 09:12:37 -0700 (PDT)
Message-Id: <20190513.091237.2207310474648188323.davem@davemloft.net>
To:     jbrunet@baylibre.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        khilman@baylibre.com, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        qi.duan@amlogic.com
Subject: Re: [PATCH net] net: meson: fixup g12a glue ephy id
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190512211237.24571-1-jbrunet@baylibre.com>
References: <20190512211237.24571-1-jbrunet@baylibre.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:12:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>
Date: Sun, 12 May 2019 23:12:37 +0200

> The phy id chosen by Amlogic is incorrectly set in the mdio mux and
> does not match the phy driver.
> 
> It was not detected before because DT forces the use the correct driver
> for the internal PHY.
> 
> Fixes: 7090425104db ("net: phy: add amlogic g12a mdio mux support")
> Reported-by: Qi Duan <qi.duan@amlogic.com>
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>

Applied.
