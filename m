Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744F52CE38
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfE1SHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:07:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfE1SHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:07:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B266F12D6C929;
        Tue, 28 May 2019 11:07:53 -0700 (PDT)
Date:   Tue, 28 May 2019 11:07:53 -0700 (PDT)
Message-Id: <20190528.110753.377345658167716646.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: Switch to devm_alloc_etherdev_mqs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527190833.5955c851@xhacker.debian>
References: <20190527190833.5955c851@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 11:07:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You never even tried to compiled this patch.

