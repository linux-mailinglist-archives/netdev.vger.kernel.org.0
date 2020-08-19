Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC87824A768
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHSUDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSUDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:03:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B228C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 13:03:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 239C911E45768;
        Wed, 19 Aug 2020 12:46:33 -0700 (PDT)
Date:   Wed, 19 Aug 2020 13:03:18 -0700 (PDT)
Message-Id: <20200819.130318.1094006073537508480.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     kuba@kernel.org, nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: use napi_complete_done return value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <18f0fcd2-919e-3580-979d-d0270c81a9ad@gmail.com>
References: <18f0fcd2-919e-3580-979d-d0270c81a9ad@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 12:46:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 19 Aug 2020 13:00:57 +0200

> Consider the return value of napi_complete_done(), this allows users to
> use the gro_flush_timeout sysfs attribute as an alternative to classic
> interrupt coalescing.

Series applied, thanks Heiner.
