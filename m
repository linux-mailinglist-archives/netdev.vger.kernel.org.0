Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A602201C03
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389317AbgFSUJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389050AbgFSUJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:09:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D207C06174E;
        Fri, 19 Jun 2020 13:09:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC0871288116F;
        Fri, 19 Jun 2020 13:09:55 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:09:55 -0700 (PDT)
Message-Id: <20200619.130955.642068136124585412.davem@davemloft.net>
To:     f.suligoi@asem.it
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: ethernet: oki-semi: pch_gbe: fix spelling
 mistake
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619091811.28651-1-f.suligoi@asem.it>
References: <20200619091811.28651-1-f.suligoi@asem.it>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:09:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Flavio Suligoi <f.suligoi@asem.it>
Date: Fri, 19 Jun 2020 11:18:11 +0200

> Fix typo: "Triger" --> "Trigger"
> 
> Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>

Applied.
