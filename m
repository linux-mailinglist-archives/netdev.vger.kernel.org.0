Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B732AA750
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgKGRxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:53:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgKGRxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 12:53:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3243920885;
        Sat,  7 Nov 2020 17:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604771622;
        bh=5NFhM8xdiqhfdIkAbPhPGOKpfh6z63qz8bo2i2srEHc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ycIkoeHuYR8H8rfqbIUyOpZcc5H9WUi+NFRO4EUmJYggdBvKugWWGqZW8DH1p/hS6
         m2BOejHjlI40gkcvBiifX0G9YZKQzufu80p5lCimNfPATcZZsIyI3V9D6HIKVDm8iW
         geLgUl8jfBfv5Wh6g0nAt8DKYI7Ee+0N19NGiWHQ=
Date:   Sat, 7 Nov 2020 09:53:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] can: flexcan: fix reference count leak in flexcan ops
Message-ID: <20201107095341.1f07c06a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107110414.1567451-1-zhangqilong3@huawei.com>
References: <20201107110414.1567451-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Nov 2020 19:04:14 +0800 Zhang Qilong wrote:
> Fixes: ca10989632d88 ("can: flexcan: implement can Runtime PM")
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

No empty lines between tags, please.
