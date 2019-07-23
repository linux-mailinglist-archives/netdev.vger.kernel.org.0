Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2443F721C2
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389398AbfGWVk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:40:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfGWVk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:40:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5245153BFB08;
        Tue, 23 Jul 2019 14:40:55 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:40:55 -0700 (PDT)
Message-Id: <20190723.144055.138556918172139772.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 19/19] ionic: Add basic devlink interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722214023.9513-20-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
        <20190722214023.9513-20-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:40:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 22 Jul 2019 14:40:23 -0700

> +struct ionic *ionic_devlink_alloc(struct device *dev)
> +{
> +	struct devlink *dl;
> +	struct ionic *ionic;

Reverse christmas tree please.
