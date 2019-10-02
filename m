Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9F7C93A1
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfJBVsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:48:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJBVsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:48:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B40DC155109DC;
        Wed,  2 Oct 2019 14:48:29 -0700 (PDT)
Date:   Wed, 02 Oct 2019 14:48:29 -0700 (PDT)
Message-Id: <20191002.144829.1770541035413219488.davem@davemloft.net>
To:     rd.dunlab@gmail.com
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH 0/3] CAIF Kconfig fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190920230358.973169240@gmail.com>
References: <20190920230358.973169240@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 14:48:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rd.dunlab@gmail.com
Date: Tue, 01 Oct 2019 16:03:58 -0700

> 
> This series of patches cleans up the CAIF Kconfig menus in
> net/caif/Kconfig and drivers/net/caif/Kconfig and also puts the
> CAIF Transport drivers into their own sub-menu.

Series applied to net-next.  Please fix your From: field in future
submissions, thanks.
