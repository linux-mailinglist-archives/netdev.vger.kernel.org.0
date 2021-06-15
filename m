Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6493F3A877D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 19:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhFORaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 13:30:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43638 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhFORaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 13:30:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 0A41D4D252312;
        Tue, 15 Jun 2021 10:28:30 -0700 (PDT)
Date:   Tue, 15 Jun 2021 10:28:26 -0700 (PDT)
Message-Id: <20210615.102826.2176657387367848458.davem@davemloft.net>
To:     mcroce@linux.microsoft.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, kuba@kernel.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, drew@beagleboard.org, kernel@esmil.dk
Subject: Re: [PATCH net-next] stmmac: align RX buffers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210615012107.577ead86@linux.microsoft.com>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
        <20210614.125111.1519954686951337716.davem@davemloft.net>
        <20210615012107.577ead86@linux.microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 15 Jun 2021 10:28:30 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thank you for the explanation, I have appplied this patch.

