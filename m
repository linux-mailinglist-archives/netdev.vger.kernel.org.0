Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD911AE771
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 23:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgDQVRR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Apr 2020 17:17:17 -0400
Received: from piie.net ([80.82.223.85]:47218 "EHLO piie.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgDQVRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 17:17:17 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2020 17:17:16 EDT
Received: from mail.piie.net (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (Client did not present a certificate)
        by piie.net (Postfix) with ESMTPSA id 0DEA6163C;
        Fri, 17 Apr 2020 23:11:25 +0200 (CEST)
Mime-Version: 1.0
Date:   Fri, 17 Apr 2020 21:11:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.11.3
From:   "=?utf-8?B?UGV0ZXIgS8Okc3RsZQ==?=" <peter@piie.net>
Message-ID: <0db3b33479eea6508a0d1136158aa31e@piie.net>
Subject: Re: [RFC 0/8] Stop monitoring disabled devices
To:     "Andrzej Pietrasiewicz" <andrzej.p@collabora.com>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>
Cc:     "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org, "Zhang Rui" <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        "Len Brown" <lenb@kernel.org>, "Jiri Pirko" <jiri@mellanox.com>,
        "Ido Schimmel" <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Darren Hart" <dvhart@infradead.org>,
        "Andy Shevchenko" <andy@infradead.org>,
        "Support Opensource" <support.opensource@diasemi.com>,
        "Amit Kucheria" <amit.kucheria@verdurent.com>,
        "Shawn Guo" <shawnguo@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "Allison Randal" <allison@lohutok.net>,
        "Enrico Weigelt" <info@metux.net>,
        "Gayatri Kammela" <gayatri.kammela@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
In-Reply-To: <fc166e0f-91ec-67d5-28b0-428f556643a4@collabora.com>
References: <fc166e0f-91ec-67d5-28b0-428f556643a4@collabora.com>
 <20200407174926.23971-1-andrzej.p@collabora.com>
 <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <aeec2ce8-8fb9-9353-f3dd-36a476ceeb3b@collabora.com>
 <CGME20200415104010eucas1p101278e53e34a2e56dfc7c82b533a9122@eucas1p1.samsung.com>
 <dc999149-d168-0b86-0559-7660e0fdec77@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

17. April 2020 18:23, "Andrzej Pietrasiewicz" <andrzej.p@collabora.com> schrieb:

[...]

> I've just sent a v3. After addressing your and Daniel's comments my series
> now looks pretty compact. Let's see if there's more feedback. Is your work on
> reviving the above mentioned 2018 series ready?

I agree, v3 looks pretty good, I will test it within next 2 days for acerhdf.  Thanks for your work!

-- 
--peter;
