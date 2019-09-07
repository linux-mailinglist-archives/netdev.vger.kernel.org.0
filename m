Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32BA9AC73E
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394720AbfIGPYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:24:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388430AbfIGPYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:24:51 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 458DA14AE7232;
        Sat,  7 Sep 2019 08:24:49 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:24:47 +0200 (CEST)
Message-Id: <20190907.172447.791462197681205913.davem@davemloft.net>
To:     vitaly.gaiduk@cloudbear.ru
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com, mark.rutland@arm.com,
        tpiepho@impinj.com, andrew@lunn.ch, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII
 mode type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
References: <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
        <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:24:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
Date: Thu,  5 Sep 2019 19:26:00 +0300

> +	- ti,sgmii-type - This denotes the fact which SGMII mode is used (4 or 6-wire).

You need to document this more sufficiently as per Andrew's feedback.
