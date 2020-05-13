Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C08F1D1F46
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390363AbgEMTdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389808AbgEMTdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:33:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4B0C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:33:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94773127E95BA;
        Wed, 13 May 2020 12:33:35 -0700 (PDT)
Date:   Wed, 13 May 2020 12:33:34 -0700 (PDT)
Message-Id: <20200513.123334.1095101323650231692.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net 0/3] tipc: add some patches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513123318.1435-1-tuong.t.lien@dektech.com.au>
References: <20200513123318.1435-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:33:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed, 13 May 2020 19:33:15 +0700

> This series adds patches to fix some issues in TIPC streaming & service
> subscription.

Series applied.
