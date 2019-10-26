Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D719E580F
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 04:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfJZCZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 22:25:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39786 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfJZCZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 22:25:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 175FA14B7272C;
        Fri, 25 Oct 2019 19:25:07 -0700 (PDT)
Date:   Fri, 25 Oct 2019 19:25:06 -0700 (PDT)
Message-Id: <20191025.192506.1304179203606625698.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, nsekhar@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] net: phy: dp83867: enable robust auto-mdix
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023144846.1381-1-grygorii.strashko@ti.com>
References: <20191023144846.1381-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 19:25:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Wed, 23 Oct 2019 17:48:44 +0300

> Patch 1 - improves link detection when dp83867 PHY is configured in manual mode
> by enabling CFG3[9] Robust Auto-MDIX option.
> 
> Patch 2 - is minor optimization.

Series applied to net-next.
