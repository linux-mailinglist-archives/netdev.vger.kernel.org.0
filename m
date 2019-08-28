Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1F2A0ACD
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 21:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfH1Tzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 15:55:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfH1Tzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 15:55:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6B2A15312648;
        Wed, 28 Aug 2019 12:55:54 -0700 (PDT)
Date:   Wed, 28 Aug 2019 12:55:54 -0700 (PDT)
Message-Id: <20190828.125554.1282892870259221491.davem@davemloft.net>
To:     wang.yi59@zte.com.cn
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.liang82@zte.com.cn,
        cheng.lin130@zte.com.cn
Subject: Re: [PATCH v2] ipv6: Not to probe neighbourless routes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566958765-1686-1-git-send-email-wang.yi59@zte.com.cn>
References: <1566958765-1686-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 12:55:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I am tossing this patch.

Resubmit it when you test it properly on current kernels.
