Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75DC2CE21
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfE1SAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:00:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfE1SAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:00:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09783122CA807;
        Tue, 28 May 2019 11:00:42 -0700 (PDT)
Date:   Tue, 28 May 2019 11:00:42 -0700 (PDT)
Message-Id: <20190528.110042.807042977833322022.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, jonathanh@nvidia.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Do not output error on deferred probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527105251.11198-1-thierry.reding@gmail.com>
References: <20190527105251.11198-1-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 11:00:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Mon, 27 May 2019 12:52:51 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> If the subdriver defers probe, do not show an error message. It's
> perfectly fine for this error to occur since the driver will get another
> chance to probe after some time and will usually succeed after all of
> the resources that it requires have been registered.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied.
