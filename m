Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FA6B05B5
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 00:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfIKWh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 18:37:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbfIKWh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 18:37:57 -0400
Received: from localhost (unknown [88.214.186.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E359154F89EB;
        Wed, 11 Sep 2019 15:37:55 -0700 (PDT)
Date:   Thu, 12 Sep 2019 00:37:54 +0200 (CEST)
Message-Id: <20190912.003754.663480494374990855.davem@davemloft.net>
To:     vitaly.gaiduk@cloudbear.ru
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com, mark.rutland@arm.com,
        andrew@lunn.ch, hkallweit1@gmail.com, tpiepho@impinj.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] net: phy: dp83867: Add SGMII mode type switching
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568049566-16708-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
References: <1568047940-14490-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
        <1568049566-16708-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 15:37:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
Date: Mon,  9 Sep 2019 20:19:24 +0300

> This patch adds ability to switch beetween two PHY SGMII modes.
> Some hardware, for example, FPGA IP designs may use 6-wire mode
> which enables differential SGMII clock to MAC.
> 
> Signed-off-by: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>

Applied.
