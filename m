Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD071F00E7
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 22:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgFEUVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 16:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgFEUVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 16:21:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BCBC08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 13:20:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 917C0127B15C0;
        Fri,  5 Jun 2020 13:20:59 -0700 (PDT)
Date:   Fri, 05 Jun 2020 13:20:58 -0700 (PDT)
Message-Id: <20200605.132058.751437025187060374.davem@davemloft.net>
To:     palok@marvell.com
Cc:     netdev@vger.kernel.org, bhsharma@redhat.com, irusskikh@marvell.com
Subject: Re: [PATCH] net: qed: fixes crash while running driver in kdump
 kernel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200605163034.26879-1-palok@marvell.com>
References: <20200605163034.26879-1-palok@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jun 2020 13:20:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alok Prasad <palok@marvell.com>
Date: Fri, 5 Jun 2020 16:30:34 +0000

> This fixes a crash introduced by recent is_kdump_kernel() check.
> The source of the crash is that kdump kernel can be loaded on a
> system with already created VFs. But for such VFs, it will follow
> a logic path of PF and eventually crash.
> 
> Thus, we are partially reverting back previous changes and instead
> use is_kdump_kernel is a single init point of PF init, where we
> disable SRIOV explicitly.
> 
> Fixes: 37d4f8a6b41f ("net: qed: Disable SRIOV functionality inside kdump kernel")
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>

Applied.
