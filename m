Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C00917EE5E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgCJCH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:07:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34786 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgCJCH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:07:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA64C15A0A55D;
        Mon,  9 Mar 2020 19:07:57 -0700 (PDT)
Date:   Mon, 09 Mar 2020 19:07:57 -0700 (PDT)
Message-Id: <20200309.190757.92462581314172039.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] r8169: series with improvements to rtl_tx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
References: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 19:07:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 6 Mar 2020 23:53:43 +0100

> This series includes few improvements to rtl_tx().

Series applied, thanks Heiner.
