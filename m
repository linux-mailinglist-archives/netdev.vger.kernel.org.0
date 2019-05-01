Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D89910433
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfEAD1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:27:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54552 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfEAD1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:27:05 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 059B6136DFB9D;
        Tue, 30 Apr 2019 20:27:04 -0700 (PDT)
Date:   Tue, 30 Apr 2019 23:27:03 -0400 (EDT)
Message-Id: <20190430.232703.2048034719219578117.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8169: improve eri function handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a92562a3-1832-2fc2-179b-bb5230523688@gmail.com>
References: <a92562a3-1832-2fc2-179b-bb5230523688@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 20:27:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 28 Apr 2019 11:09:36 +0200

> This series aims at improving and simplifying the eri functions.
> No functional change intended.

Series applied, thanks.
