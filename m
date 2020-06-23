Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BC42065EF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393439AbgFWVfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393613AbgFWVfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:35:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93CAC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 14:35:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 77C04129428AE;
        Tue, 23 Jun 2020 14:35:25 -0700 (PDT)
Date:   Tue, 23 Jun 2020 14:35:24 -0700 (PDT)
Message-Id: <20200623.143524.525836474946314391.davem@davemloft.net>
To:     acassen@gmail.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com,
        nikolay@cumulusnetworks.com, idosch@mellanox.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net-next,v2] rtnetlink: add keepalived rtm_protocol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623083345.30842-1-acassen@gmail.com>
References: <20200623083345.30842-1-acassen@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 14:35:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandre Cassen <acassen@gmail.com>
Date: Tue, 23 Jun 2020 10:33:45 +0200

> Keepalived can set global static ip routes or virtual ip routes dynamically
> following VRRP protocol states. Using a dedicated rtm_protocol will help
> keeping track of it.
> 
> Changes in v2:
>  - fix tab/space indenting
> 
> Signed-off-by: Alexandre Cassen <acassen@gmail.com>

Applied, thank you.
