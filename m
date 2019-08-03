Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FDC803AD
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 03:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389479AbfHCBRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 21:17:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53108 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388638AbfHCBRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 21:17:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 855D812B88C3F;
        Fri,  2 Aug 2019 18:17:23 -0700 (PDT)
Date:   Fri, 02 Aug 2019 18:17:22 -0700 (PDT)
Message-Id: <20190802.181722.115856569002980058.davem@davemloft.net>
To:     kevlo@kevlo.org
Cc:     hayeswang@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8152: fix typo in register name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801032938.GA22256@ns.kevlo.org>
References: <20190801032938.GA22256@ns.kevlo.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 18:17:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>
Date: Thu, 1 Aug 2019 11:29:38 +0800

> It is likely that PAL_BDC_CR should be PLA_BDC_CR.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Applied.
