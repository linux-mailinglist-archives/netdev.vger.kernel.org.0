Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1E1E322C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391841AbgEZWP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391457AbgEZWP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:15:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCCEC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:15:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6303120ED4BE;
        Tue, 26 May 2020 15:15:55 -0700 (PDT)
Date:   Tue, 26 May 2020 15:15:54 -0700 (PDT)
Message-Id: <20200526.151554.648203461285263253.davem@davemloft.net>
To:     michal.kalderon@marvell.com
Cc:     yuval.bason@marvell.com, ariel.elior@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] qed: Add EDPM mode type for user-fw
 compatibility
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526064120.750-1-michal.kalderon@marvell.com>
References: <20200526064120.750-1-michal.kalderon@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:15:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Tue, 26 May 2020 09:41:20 +0300

> From: Yuval Basson <yuval.bason@marvell.com>
> 
> In older FW versions the completion flag was treated as the ack flag in
> edpm messages. Expose the FW option of setting which mode the QP is in
> by adding a flag to the qedr <-> qed API.
> 
> Flag is added for backward compatibility with libqedr.
> This flag will be set by qedr after determining whether the libqedr is
> using the updated version.
> 
> Fixes: f10939403352 ("qed: Add support for QP verbs")
> Signed-off-by: Yuval Basson <yuval.bason@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Applied.
