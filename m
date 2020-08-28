Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8D9255B8F
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgH1NtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgH1NtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:49:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E64C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 06:49:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A82C01283CC0B;
        Fri, 28 Aug 2020 06:32:21 -0700 (PDT)
Date:   Fri, 28 Aug 2020 06:49:03 -0700 (PDT)
Message-Id: <20200828.064903.1567465112289417515.davem@davemloft.net>
To:     andre.edich@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next v5 0/3] Add phylib support to smsc95xx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826111717.405305-1-andre.edich@microchip.com>
References: <20200826111717.405305-1-andre.edich@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 06:32:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Edich <andre.edich@microchip.com>
Date: Wed, 26 Aug 2020 13:17:14 +0200

> To allow to probe external PHY drivers, this patch series adds use of
> phylib to the smsc95xx driver.
 ...

Series applied, thank you.
