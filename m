Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1482605BE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 22:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgIGUi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 16:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgIGUiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 16:38:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E1E21556;
        Mon,  7 Sep 2020 20:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599511134;
        bh=JCC16tfAaOLvYj/6BxPeORpieJMWF9mUe+bcB6vKfzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=prcvPp4sn7RG1y+i8zpKqcGseal0+iN/e1lhBpxoiAMtLCOcrYPP1Xcn4d/8ltj8e
         1ySGaPrPzfdPa38ZHt2JNPzlAgwS8Lk5zPQtSxVCcV9mc+mdqqC2+K3zhdFxDrnDQT
         o7Uo7XniZ9uxnsucz4AQN4FuCI7Z9aaPKfkg0kp0=
Date:   Mon, 7 Sep 2020 13:38:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: stmmac: remove redundant null check
 before clk_disable_unprepare()
Message-ID: <20200907133852.1f7fa645@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599483444-43331-1-git-send-email-zhangchangzhong@huawei.com>
References: <1599483444-43331-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 20:57:24 +0800 Zhang Changzhong wrote:
> Because clk_prepare_enable() and clk_disable_unprepare() already checked
> NULL clock parameter, so the additional checks are unnecessary, just
> remove them.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied.
