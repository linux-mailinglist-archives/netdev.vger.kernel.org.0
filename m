Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3F2190489
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgCXEhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:37:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56294 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXEhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:37:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EEEC1577F513;
        Mon, 23 Mar 2020 21:37:08 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:37:08 -0700 (PDT)
Message-Id: <20200323.213708.224954591425289205.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: remove XCVR_DUMMY entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <44908ff8-22dd-254e-16f8-f45f64e8e98e@gmail.com>
References: <44908ff8-22dd-254e-16f8-f45f64e8e98e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:37:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 22 Mar 2020 14:14:20 +0100

> The transceiver dummy entries are not used any longer, so remove them.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

As this is UAPI we can't do this, as others have said.
