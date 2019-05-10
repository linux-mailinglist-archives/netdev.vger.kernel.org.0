Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804A71A5A0
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 01:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfEJXlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 19:41:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59602 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbfEJXlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 19:41:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B86D133E976D;
        Fri, 10 May 2019 16:41:45 -0700 (PDT)
Date:   Fri, 10 May 2019 16:41:42 -0700 (PDT)
Message-Id: <20190510.164142.2254976888525470430.davem@davemloft.net>
To:     ycheng@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com
Subject: Re: [PATCH net] tcp: fix retrans timestamp on passive Fast Open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190510230019.137937-1-ycheng@google.com>
References: <20190510230019.137937-1-ycheng@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 May 2019 16:41:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>
Date: Fri, 10 May 2019 16:00:19 -0700

> Fixes: 3844718c20d0 ("tcp: properly track retry time on passive Fast Open")

This is not a valid commit ID.
