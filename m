Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AF81DFC05
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbgEWX5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388106AbgEWX5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:57:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBD3C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 16:57:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9054C12873760;
        Sat, 23 May 2020 16:57:19 -0700 (PDT)
Date:   Sat, 23 May 2020 16:57:18 -0700 (PDT)
Message-Id: <20200523.165718.1124885913264494628.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: propagate get_coalesce return value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1f4f887a-4339-1ece-b2aa-c9712e54bce3@gmail.com>
References: <1f4f887a-4339-1ece-b2aa-c9712e54bce3@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:57:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 23 May 2020 17:40:25 +0200

> get_coalesce returns 0 or ERRNO, but the return value isn't checked.
> The returned coalesce data may be invalid if an ERRNO is set,
> therefore better check and propagate the return value.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
