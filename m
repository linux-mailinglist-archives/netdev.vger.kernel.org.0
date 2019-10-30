Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8E3E9434
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfJ3Au2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:50:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33704 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJ3Au1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:50:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44D1113EDD647;
        Tue, 29 Oct 2019 17:50:27 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:50:26 -0700 (PDT)
Message-Id: <20191029.175026.2248664342058775956.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org,
        Chris.Healy@zii.aero
Subject: Re: [PATCH net-next 0/4] net: phy: marvell: fix and extend
 downshift support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:50:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 28 Oct 2019 20:51:27 +0100

> This series includes two fixes and two extensions for downshift
> support.

Series applied, thanks Heiner.
