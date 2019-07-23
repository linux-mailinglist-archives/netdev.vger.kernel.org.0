Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB072053
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391814AbfGWUDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:03:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfGWUDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:03:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0CD9B153BA91B;
        Tue, 23 Jul 2019 13:03:10 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:03:10 -0700 (PDT)
Message-Id: <20190723.130310.1882563676176591087.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        michael.chan@broadcom.com, siva.kallam@broadcom.com,
        prashant@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: broadcom: Use dev_get_drvdata
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723131929.31987-1-hslester96@gmail.com>
References: <20190723131929.31987-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:03:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Tue, 23 Jul 2019 21:19:29 +0800

> Instead of using to_pci_dev + pci_get_drvdata,
> use dev_get_drvdata to make code simpler.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied.
