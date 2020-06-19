Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AE6201C02
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388522AbgFSUJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733249AbgFSUJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:09:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B0CC06174E;
        Fri, 19 Jun 2020 13:09:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 504121288116E;
        Fri, 19 Jun 2020 13:09:48 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:09:47 -0700 (PDT)
Message-Id: <20200619.130947.1424530956757272343.davem@davemloft.net>
To:     f.suligoi@asem.it
Cc:     jdmason@kudzu.us, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        wei.zheng@vivo.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 1/1] net: ethernet: neterion: vxge: fix spelling mistake
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619090204.27503-1-f.suligoi@asem.it>
References: <20200619090204.27503-1-f.suligoi@asem.it>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:09:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Flavio Suligoi <f.suligoi@asem.it>
Date: Fri, 19 Jun 2020 11:02:04 +0200

> Fix typo: "trigered" --> "triggered"
> 
> Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>

Applied.
