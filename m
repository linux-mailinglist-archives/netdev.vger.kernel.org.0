Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946F9DF47B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfJURpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:45:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJURpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:45:42 -0400
Received: from localhost (unknown [4.14.35.89])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98C4614047D0C;
        Mon, 21 Oct 2019 10:45:41 -0700 (PDT)
Date:   Mon, 21 Oct 2019 10:45:41 -0700 (PDT)
Message-Id: <20191021.104541.882166536642996591.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: marvell: support downshift as
 PHY tunable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <85961f9a-999c-743d-3fd2-66c10e7a219e@gmail.com>
References: <85961f9a-999c-743d-3fd2-66c10e7a219e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Oct 2019 10:45:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 19 Oct 2019 15:56:34 +0200

> So far downshift is implemented for one small use case only and can't
> be controlled from userspace. So let's implement this feature properly
> as a PHY tunable so that it can be controlled via ethtool.

Series applied, thanks.
