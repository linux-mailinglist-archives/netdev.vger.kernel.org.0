Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A421B83AF8
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfHFVUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:20:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50028 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfHFVUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:20:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84A5112B8C6FF;
        Tue,  6 Aug 2019 14:20:44 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:20:44 -0700 (PDT)
Message-Id: <20190806.142044.992357683509037716.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: add helper r8168_mac_ocp_modify
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dc905b86-2852-86c2-be14-22164bd4a06d@gmail.com>
References: <dc905b86-2852-86c2-be14-22164bd4a06d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:20:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 4 Aug 2019 09:47:51 +0200

> Add a helper for MAC OCP read-modify-write operations.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
