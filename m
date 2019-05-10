Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F1D1A522
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 00:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfEJWPC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 May 2019 18:15:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbfEJWPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 18:15:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1963A133E9747;
        Fri, 10 May 2019 15:15:02 -0700 (PDT)
Date:   Fri, 10 May 2019 15:15:01 -0700 (PDT)
Message-Id: <20190510.151501.1636787564971451909.davem@davemloft.net>
To:     ynezz@true.cz
Cc:     netdev@vger.kernel.org, matthias.bgg@gmail.com, andrew@lunn.ch,
        robh@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net 0/5] of_get_mac_address fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557480918-9627-1-git-send-email-ynezz@true.cz>
References: <1557480918-9627-1-git-send-email-ynezz@true.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 May 2019 15:15:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr ¦tetiar <ynezz@true.cz>
Date: Fri, 10 May 2019 11:35:13 +0200

> this patch series is hopefuly the last series of the fixes which are related
> to the introduction of NVMEM support into of_get_mac_address.
> 
> First patch is removing `nvmem-mac-address` property which was wrong idea as
> I've allocated the property with devm_kzalloc and then added it to DT, so then
> 2 entities would be refcounting the allocation.  So if the driver unbinds, the
> buffer is freed, but DT code would be still referencing that memory.
> 
> Second patch fixes some unwanted references to the Linux API in the DT
> bindings documentation.
> 
> Patches 3-5 should hopefully make compilers and thus kbuild test robot happy.

Series applied, thanks.
