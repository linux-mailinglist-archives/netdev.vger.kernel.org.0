Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A7B1B52C1
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgDWCzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgDWCzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:55:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE71C03C1AA;
        Wed, 22 Apr 2020 19:55:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8BC3127AFC5F;
        Wed, 22 Apr 2020 19:55:16 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:55:16 -0700 (PDT)
Message-Id: <20200422.195516.1807680263283768229.davem@davemloft.net>
To:     carnil@debian.org
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        paul@paul-moore.com, kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlabel: Kconfig: Update reference for NetLabel Tools
 project
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422190753.2077110-1-carnil@debian.org>
References: <20200422190753.2077110-1-carnil@debian.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:55:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Salvatore Bonaccorso <carnil@debian.org>
Date: Wed, 22 Apr 2020 21:07:53 +0200

> The NetLabel Tools project has moved from http://netlabel.sf.net to a
> GitHub. Update to directly refer to the new home for the tools.
> 
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>

Applied.
