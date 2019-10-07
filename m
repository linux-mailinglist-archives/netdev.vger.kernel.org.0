Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273CDCE3E5
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfJGNjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:39:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52796 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfJGNjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:39:00 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6B54140C368E;
        Mon,  7 Oct 2019 06:38:59 -0700 (PDT)
Date:   Mon, 07 Oct 2019 15:38:58 +0200 (CEST)
Message-Id: <20191007.153858.1676506174832561154.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: use helper skb_ensure_writable in
 more places
From:   David Miller <davem@davemloft.net>
In-Reply-To: <26c7f285-1923-5f09-6ea5-24fd8a5c78b6@gmail.com>
References: <26c7f285-1923-5f09-6ea5-24fd8a5c78b6@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 06:39:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 6 Oct 2019 18:52:43 +0200

> Use helper skb_ensure_writable in two more places to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Looks good, applied.
