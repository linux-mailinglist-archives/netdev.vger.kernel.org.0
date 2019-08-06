Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A881683AEE
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfHFVSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:18:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfHFVSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:18:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2288F12B8A10A;
        Tue,  6 Aug 2019 14:18:36 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:18:35 -0700 (PDT)
Message-Id: <20190806.141835.1028865322747867054.davem@davemloft.net>
To:     dave.taht@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Two small fq_codel optimizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564875449-12122-1-git-send-email-dave.taht@gmail.com>
References: <1564875449-12122-1-git-send-email-dave.taht@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:18:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Taht <dave.taht@gmail.com>
Date: Sat,  3 Aug 2019 16:37:27 -0700

> These two patches improve fq_codel performance 
> under extreme network loads. The first patch 
> more rapidly escalates the codel count under
> overload, the second just kills a totally useless
> statistic. 
> 
> (sent together because they'd otherwise conflict)
> 
> Signed-off-by: Dave Taht <dave.taht@gmail.com>

Series applied.
