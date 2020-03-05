Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB74117AF9E
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 21:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgCEURo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 15:17:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgCEURo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 15:17:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66C9A15BE96F9;
        Thu,  5 Mar 2020 12:17:42 -0800 (PST)
Date:   Thu, 05 Mar 2020 12:17:41 -0800 (PST)
Message-Id: <20200305.121741.1417349052761969854.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, ecree@solarflare.com, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/12] ethtool: consolidate parameter
 checking for irq coalescing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305051542.991898-1-kuba@kernel.org>
References: <20200305051542.991898-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 12:17:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed,  4 Mar 2020 21:15:30 -0800

> This set aims to simplify and unify the unsupported irq
> coalescing parameter handling.

Series applied, thanks Jakub.
