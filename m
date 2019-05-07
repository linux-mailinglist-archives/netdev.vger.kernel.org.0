Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D9D16B40
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfEGTYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:24:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGTYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:24:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 323F914B7666F;
        Tue,  7 May 2019 12:24:07 -0700 (PDT)
Date:   Tue, 07 May 2019 12:24:06 -0700 (PDT)
Message-Id: <20190507.122406.1487189733829957696.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     jiri@resnulli.us, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        pieter.jansenvanvuuren@netronome.com, jiri@mellanox.com
Subject: Re: [PATCH net-next] net/sched: remove block pointer from common
 offload structure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190507002421.32690-1-jakub.kicinski@netronome.com>
References: <20190507002421.32690-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:24:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon,  6 May 2019 17:24:21 -0700

> From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> 
> Based on feedback from Jiri avoid carrying a pointer to the tcf_block
> structure in the tc_cls_common_offload structure. Instead store
> a flag in driver private data which indicates if offloads apply
> to a shared block at block binding time.
> 
> Suggested-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
