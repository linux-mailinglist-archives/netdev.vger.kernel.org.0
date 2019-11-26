Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33C910A3EB
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 19:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfKZSJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 13:09:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKZSJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 13:09:43 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00CE014C25D3A;
        Tue, 26 Nov 2019 10:09:42 -0800 (PST)
Date:   Tue, 26 Nov 2019 10:09:42 -0800 (PST)
Message-Id: <20191126.100942.402030780937576711.davem@davemloft.net>
To:     mparab@cadence.com
Cc:     andrew@lunn.ch, antoine.tenart@bootlin.com,
        nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, dkangude@cadence.com,
        pthombar@cadence.com
Subject: Re: [PATCH 0/3] net: macb: cover letter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574759354-102696-1-git-send-email-mparab@cadence.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 10:09:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You need to say something better than "cover letter", state what the overall
series is doing at a high level, in the most concise way.
