Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C6262593
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgIIDD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgIIDDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:03:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADF6C061573;
        Tue,  8 Sep 2020 20:03:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C0D711E3E4C3;
        Tue,  8 Sep 2020 19:47:06 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:03:52 -0700 (PDT)
Message-Id: <20200908.200352.381655597424220017.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     paul@paul-moore.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH net-next] cipso: fix 'audit_secid' kernel-doc warning
 in cipso_ipv4.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908135915.22039-1-wanghai38@huawei.com>
References: <20200908135915.22039-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:47:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Tue, 8 Sep 2020 21:59:15 +0800

> Fixes the following W=1 kernel build warning(s):
> 
> net/ipv4/cipso_ipv4.c:510: warning: Excess function parameter 'audit_secid' description in 'cipso_v4_doi_remove'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied.
