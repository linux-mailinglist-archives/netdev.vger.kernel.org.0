Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAD520A89A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407697AbgFYXK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404432AbgFYXK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:10:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD62EC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:10:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BA1C153D4BCC;
        Thu, 25 Jun 2020 16:10:58 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:10:57 -0700 (PDT)
Message-Id: <20200625.161057.432393500274958536.davem@davemloft.net>
To:     briana.oursler@gmail.com
Cc:     sbrivio@redhat.com, dcaratti@redhat.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jhs@mojatatu.com, mrv@mojatatu.com,
        jiri@mellanox.com
Subject: Re: [PATCH net] tc-testing: avoid action cookies with odd length.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624192913.2802-1-briana.oursler@gmail.com>
References: <20200624192913.2802-1-briana.oursler@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:10:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Briana Oursler <briana.oursler@gmail.com>
Date: Wed, 24 Jun 2020 12:29:14 -0700

> Update odd length cookie hexstrings in csum.json, tunnel_key.json and
> bpf.json to be even length to comply with check enforced in commit
> 0149dabf2a1b ("tc: m_actions: check cookie hexstring len") in iproute2.
> 
> Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
> Reviewed-by: Davide Caratti <dcaratti@redhat.com>

Applied, thank you.
