Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0520D2738F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfEWAsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:48:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36876 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbfEWAsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:48:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 61D031457785D;
        Wed, 22 May 2019 17:48:13 -0700 (PDT)
Date:   Wed, 22 May 2019 17:48:12 -0700 (PDT)
Message-Id: <20190522.174812.569975023875840989.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        marex@denx.de
Subject: Re: [PATCH net-next 0/2] net: phy: T1 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522184704.7195-1-andrew@lunn.ch>
References: <20190522184704.7195-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:48:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 22 May 2019 20:47:02 +0200

> T1 PHYs make use of a single twisted pair, rather than the traditional
> 2 pair for 100BaseT or 4 pair for 1000BaseT. This patchset adds link
> modes for 100BaseT1 and 1000BaseT1, and them makes use of 100BaseT1 in
> the list of PHY features used by current T1 drivers.

Series applied.
