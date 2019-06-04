Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A4D35011
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFDS6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:58:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDS6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 14:58:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9927614FA95CB;
        Tue,  4 Jun 2019 11:58:01 -0700 (PDT)
Date:   Tue, 04 Jun 2019 11:58:00 -0700 (PDT)
Message-Id: <20190604.115800.2011407122879630149.davem@davemloft.net>
To:     dinguyen@kernel.org
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        wei.liang.lim@intel.com
Subject: Re: [PATCH RESEND net-next] net: stmmac: socfpga: add RMII phy mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603144418.3297-1-dinguyen@kernel.org>
References: <20190603144418.3297-1-dinguyen@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 11:58:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>
Date: Mon,  3 Jun 2019 09:44:18 -0500

> Add option for enabling RMII phy mode.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Wei Liang Lim <wei.liang.lim@intel.com>
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>

Applied.
