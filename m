Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78219882CE
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406374AbfHISnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:43:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfHISnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:43:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DD38012B88C33;
        Fri,  9 Aug 2019 11:43:14 -0700 (PDT)
Date:   Fri, 09 Aug 2019 11:43:14 -0700 (PDT)
Message-Id: <20190809.114314.1715215925183719227.davem@davemloft.net>
To:     johunt@akamai.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        edumazet@google.com, ncardwell@google.com
Subject: Re: [PATCH v2 2/2] tcp: Update TCP_BASE_MSS comment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3353da97-e015-7303-6e10-7e3e99a50a8f@akamai.com>
References: <1565221950-1376-2-git-send-email-johunt@akamai.com>
        <c1c2febd-742d-4e13-af9f-a7d7ec936ed9@gmail.com>
        <3353da97-e015-7303-6e10-7e3e99a50a8f@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 11:43:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>
Date: Fri, 9 Aug 2019 11:38:05 -0700

> I forgot to tag these at net-next. Do I need to resubmit a v3 with
> net-next in the subject?

No need.
