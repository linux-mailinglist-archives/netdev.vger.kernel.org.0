Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA0F2625AA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIIDKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgIIDKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:10:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F383C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 20:10:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55BA011E3E4C3;
        Tue,  8 Sep 2020 19:53:29 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:10:15 -0700 (PDT)
Message-Id: <20200908.201015.279618669327274413.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] MAINTAINERS: remove John Allen from ibmvnic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908163012.153155-1-kuba@kernel.org>
References: <20200908163012.153155-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:53:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue,  8 Sep 2020 09:30:12 -0700

> John's email has bounced and Thomas confirms he no longer
> works on ibmvnic.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied, thanks.

