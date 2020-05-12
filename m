Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE471CFF10
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 22:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgELUL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 16:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELUL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 16:11:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8F7C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 13:11:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D962212838918;
        Tue, 12 May 2020 13:11:57 -0700 (PDT)
Date:   Tue, 12 May 2020 13:11:57 -0700 (PDT)
Message-Id: <20200512.131157.399845195173640691.davem@davemloft.net>
To:     u9012063@gmail.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] erspan: Check IFLA_GRE_ERSPAN_VER is set.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589304983-100626-1-git-send-email-u9012063@gmail.com>
References: <1589304983-100626-1-git-send-email-u9012063@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 May 2020 13:11:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Tue, 12 May 2020 10:36:23 -0700

> Add a check to make sure the IFLA_GRE_ERSPAN_VER is provided by users.
> 
> Fixes: f989d546a2d5 ("erspan: Add type I version 0 support.")
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: William Tu <u9012063@gmail.com>

Applied, thanks.
