Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A146F22A3ED
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733275AbgGWAzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWAzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:55:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746FBC0619DC;
        Wed, 22 Jul 2020 17:55:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F22B1126ABD98;
        Wed, 22 Jul 2020 17:39:04 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:55:49 -0700 (PDT)
Message-Id: <20200722.175549.1334326051003988959.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] lan743x: remove redundant initialization of
 variable current_head_index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722151221.957972-1-colin.king@canonical.com>
References: <20200722151221.957972-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:39:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed, 22 Jul 2020 16:12:21 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable current_head_index is being initialized with a value that
> is never read and it is being updated later with a new value.  Replace
> the initialization of -1 with the latter assignment.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thank you.
