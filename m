Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED7B17891A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387535AbgCDDWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:22:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38680 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387454AbgCDDWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 22:22:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F43D15B1B794;
        Tue,  3 Mar 2020 19:22:45 -0800 (PST)
Date:   Tue, 03 Mar 2020 19:22:44 -0800 (PST)
Message-Id: <20200303.192244.404505901330996512.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] gianfar: remove unnecessary zeroing coalesce
 settings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304022612.602957-1-kuba@kernel.org>
References: <20200304022612.602957-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 19:22:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue,  3 Mar 2020 18:26:12 -0800

> Core already zeroes out the struct ethtool_coalesce structure,
> drivers don't have to set every field to 0 individually.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Looks good, applied, thanks Jakub.
