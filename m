Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE01EAF71
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgFATGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgFATGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:06:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726C6C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:06:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36AC1120477C4;
        Mon,  1 Jun 2020 12:06:11 -0700 (PDT)
Date:   Mon, 01 Jun 2020 12:06:10 -0700 (PDT)
Message-Id: <20200601.120610.924904963948848960.davem@davemloft.net>
To:     viro@zeniv.linux.org.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] switch cmsghdr_from_user_compat_to_kern() to
 copy_from_user()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200531010655.GX23230@ZenIV.linux.org.uk>
References: <20200531010655.GX23230@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 12:06:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 31 May 2020 02:06:55 +0100

> no point getting compat_cmsghdr field-by-field
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks Al.
