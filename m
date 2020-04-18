Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7A41AF56D
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgDRWcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:32:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF62C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:32:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0371C1277689F;
        Sat, 18 Apr 2020 15:32:11 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:32:11 -0700 (PDT)
Message-Id: <20200418.153211.649575253431491187.davem@davemloft.net>
To:     lkml@sdf.org
Cc:     tung.q.nguyen@dektech.com.au, jmaloy@redhat.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tipc: Remove redundant tsk->published flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <202004160327.03G3RZLv012120@sdf.org>
References: <202004160327.03G3RZLv012120@sdf.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:32:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Spelvin <lkml@sdf.org>
Date: Thu, 16 Apr 2020 03:27:35 GMT

> @@ -3847,7 +3839,7 @@ int tipc_sk_dump(struct sock *sk, u16 dqueues, char *buf)
>  	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
>  	struct tipc_sock *tsk;
>  	struct publication *p;
> -	bool tsk_connected;
> +	bool tsk_connected, tsk_published;
>  

Please preserve the reverse christmas tree ordering of local variables
here.

Thank you.
