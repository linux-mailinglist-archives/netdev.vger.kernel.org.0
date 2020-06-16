Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DA91FC02B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgFPUn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgFPUn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 16:43:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0C2C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 13:43:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E5A2128D4972;
        Tue, 16 Jun 2020 13:43:26 -0700 (PDT)
Date:   Tue, 16 Jun 2020 13:43:25 -0700 (PDT)
Message-Id: <20200616.134325.1729256105250536968.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: Re: [PATCH net] bareudp: Fixed configuration to avoid having
 garbage values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592286538-6895-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1592286538-6895-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jun 2020 13:43:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Tue, 16 Jun 2020 11:18:58 +0530

> From: Martin <martin.varghese@nokia.com>
> 
> Code to initialize the conf structure while gathering the configuration
> of the device was missing.
> 
> Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
> Signed-off-by: Martin <martin.varghese@nokia.com>

Applied, thank you.
