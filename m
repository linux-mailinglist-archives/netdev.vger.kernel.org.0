Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3511CE5E4
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731939AbgEKUnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731932AbgEKUnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:43:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20287C061A0C;
        Mon, 11 May 2020 13:43:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0FD3120ED540;
        Mon, 11 May 2020 13:43:10 -0700 (PDT)
Date:   Mon, 11 May 2020 13:43:09 -0700 (PDT)
Message-Id: <20200511.134309.870356538874716906.davem@davemloft.net>
To:     joe@perches.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] checkpatch: warn about uses of ENOTSUPP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c4c6fee41ceb2eb4b583df37ad0d659357cd81d8.camel@perches.com>
References: <20200511170807.2252749-1-kuba@kernel.org>
        <c4c6fee41ceb2eb4b583df37ad0d659357cd81d8.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 13:43:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 11 May 2020 10:16:34 -0700

> No worries here and it's not worth a respin, but
> typically the patch changelog goes below the --- line.

I ask people explicitly to keep the changelog in the commit message
proper, the more information we have in the GIT history the better.
