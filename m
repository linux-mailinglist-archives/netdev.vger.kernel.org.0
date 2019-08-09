Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380198841E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfHIUhw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Aug 2019 16:37:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfHIUhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:37:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22AB014267DDC;
        Fri,  9 Aug 2019 13:37:51 -0700 (PDT)
Date:   Fri, 09 Aug 2019 13:37:50 -0700 (PDT)
Message-Id: <20190809.133750.175907926073350234.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, holger@applied-asynchrony.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: fix performance issue on RTL8168evl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <596f91ee-d5bf-52e9-94b6-011c707a15fb@gmail.com>
References: <596f91ee-d5bf-52e9-94b6-011c707a15fb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 13:37:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 9 Aug 2019 00:02:40 +0200

> From: Holger Hoffstätte <holger@applied-asynchrony.com>
> Disabling TSO but leaving SG active results is a significant
> performance drop. Therefore disable also SG on RTL8168evl.
> This restores the original performance.
> 
> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
