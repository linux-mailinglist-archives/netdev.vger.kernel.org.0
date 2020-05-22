Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF061DF2E0
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbgEVXUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731223AbgEVXUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:20:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAA0C061A0E;
        Fri, 22 May 2020 16:20:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9D5A12751C31;
        Fri, 22 May 2020 16:20:07 -0700 (PDT)
Date:   Fri, 22 May 2020 16:20:07 -0700 (PDT)
Message-Id: <20200522.162007.703955779701480867.davem@davemloft.net>
To:     wu000273@umn.edu
Cc:     kuba@kernel.org, hkallweit1@gmail.com, jonathan.lemon@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kjlu@umn.edu
Subject: Re: [PATCH] net: sun: fix missing release regions in
 cas_init_one().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522215027.4217-1-wu000273@umn.edu>
References: <20200522215027.4217-1-wu000273@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:20:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wu000273@umn.edu
Date: Fri, 22 May 2020 16:50:27 -0500

> From: Qiushi Wu <wu000273@umn.edu>
> 
> In cas_init_one(), "pdev" is requested by "pci_request_regions", but it
> was not released after a call of the function “pci_write_config_byte” 
> failed. Thus replace the jump target “err_write_cacheline” by 
> "err_out_free_res".
> 
> Fixes: 1f26dac32057 ("[NET]: Add Sun Cassini driver.")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>

Applied, thank you.
