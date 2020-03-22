Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDCB18E63B
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgCVDUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:20:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:20:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F88C15AC4293;
        Sat, 21 Mar 2020 20:20:17 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:20:16 -0700 (PDT)
Message-Id: <20200321.202016.815058339704760980.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     acelan.kao@canonical.com, nic_swsd@realtek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: only disable ASPM L1.1 support, instead of
 disabling them all
From:   David Miller <davem@davemloft.net>
In-Reply-To: <78aa4db2-6dec-e23c-03f4-f76577de756f@gmail.com>
References: <20200318014548.14547-1-acelan.kao@canonical.com>
        <78aa4db2-6dec-e23c-03f4-f76577de756f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:20:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 18 Mar 2020 12:09:14 +0100

> Having said that I'd prefer to keep ASPM an opt-in feature.

Agreed, too much stuff broke randomly and in hard to detect ways.
