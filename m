Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA5E2E770
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE2V3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:29:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42108 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2V3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:29:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC0CE136E16A9;
        Wed, 29 May 2019 14:29:10 -0700 (PDT)
Date:   Wed, 29 May 2019 14:29:10 -0700 (PDT)
Message-Id: <20190529.142910.1174070817897783016.davem@davemloft.net>
To:     muvarov@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v3 0/4] net: phy: dp83867: add some fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528100052.8023-1-muvarov@gmail.com>
References: <20190528100052.8023-1-muvarov@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 14:29:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Uvarov <muvarov@gmail.com>
Date: Tue, 28 May 2019 13:00:48 +0300

> v3: use phy_modify_mmd()
> v2: fix minor comments by Heiner Kallweit and Florian Fainelli

Series applied, thank you.
