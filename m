Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2183ABB7
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 21:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbfFIT4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 15:56:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfFIT4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 15:56:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B352114DEB0EC;
        Sun,  9 Jun 2019 12:55:59 -0700 (PDT)
Date:   Sun, 09 Jun 2019 12:55:59 -0700 (PDT)
Message-Id: <20190609.125559.2049293229840348873.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     ssantosh@kernel.org, richardcochran@gmail.com, robh+dt@kernel.org,
        nsekhar@ti.com, m-karicheri2@ti.com, w-kwok2@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 00/10] net: ethernet: ti: netcp: update and
 enable cpts support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606163047.31199-1-grygorii.strashko@ti.com>
References: <20190606163047.31199-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 12:56:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Thu, 6 Jun 2019 19:30:37 +0300

> I grouped all patches in one series for better illustration of the changes,
> but in general Pateches 1-4 are netdev matarieal (first) and other patches
> are platform specific.

Patch 1-4 applied to net-next.
