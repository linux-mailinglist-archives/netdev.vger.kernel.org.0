Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F30972061
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403938AbfGWUDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:03:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403932AbfGWUDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:03:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72E16153BAE87;
        Tue, 23 Jul 2019 13:03:34 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:03:34 -0700 (PDT)
Message-Id: <20190723.130334.857369744482967463.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     cooldavid@cooldavid.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: jme: Use dev_get_drvdata
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723141642.5968-1-hslester96@gmail.com>
References: <20190723141642.5968-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:03:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Tue, 23 Jul 2019 22:16:42 +0800

> Instead of using to_pci_dev + pci_get_drvdata,
> use dev_get_drvdata to make code simpler.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied.
