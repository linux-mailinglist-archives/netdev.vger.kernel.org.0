Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78ED1A9BB5
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbfIEHZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 03:25:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbfIEHZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 03:25:04 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 934F715383DCF;
        Thu,  5 Sep 2019 00:25:03 -0700 (PDT)
Date:   Thu, 05 Sep 2019 00:25:02 -0700 (PDT)
Message-Id: <20190905.002502.895536491816890643.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v7 net-next 00/19] ionic: Add ionic driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 00:25:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue,  3 Sep 2019 15:28:02 -0700

> This is a patch series that adds the ionic driver, supporting the Pensando
> ethernet device.
> 
> In this initial patchset we implement basic transmit and receive.  Later
> patchsets will add more advanced features.
> 
> Our thanks to Saeed Mahameed, David Miller, Andrew Lunn, Michal Kubecek,
> Jacub Kicinski, Jiri Pirko, Yunsheng Lin, and the ever present kbuild
> test robots for their comments and suggestions.
 ...

Series applied, thank you.
