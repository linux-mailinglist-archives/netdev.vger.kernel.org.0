Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6D74C26E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 22:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbfFSUbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 16:31:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSUbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 16:31:22 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 92F2F13AEF243;
        Wed, 19 Jun 2019 13:31:21 -0700 (PDT)
Date:   Wed, 19 Jun 2019 16:31:20 -0400 (EDT)
Message-Id: <20190619.163120.1469264208117720999.davem@davemloft.net>
To:     krzk@kernel.org
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns3: Fix inconsistent indenting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618185422.3726-1-krzk@kernel.org>
References: <20190618185422.3726-1-krzk@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 13:31:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Tue, 18 Jun 2019 20:54:22 +0200

> Fix wrong indentation of goto return.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Applied, thanks.
