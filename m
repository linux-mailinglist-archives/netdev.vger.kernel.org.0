Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF7C12BBE9
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 01:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfL1A3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 19:29:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL1A3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 19:29:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C69A154D113D;
        Fri, 27 Dec 2019 16:29:38 -0800 (PST)
Date:   Fri, 27 Dec 2019 16:29:35 -0800 (PST)
Message-Id: <20191227.162935.1255200512054821740.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        ncardwell@google.com, ycheng@google.com, kafai@fb.com
Subject: Re: [PATCH net-next v2 0/5] tcp_cubic: various fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223202754.127546-1-edumazet@google.com>
References: <20191223202754.127546-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Dec 2019 16:29:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 23 Dec 2019 12:27:49 -0800

> This patch series converts tcp_cubic to usec clock resolution
> for Hystart logic.
> 
> This makes Hystart more relevant for data-center flows.
> Prior to this series, Hystart was not kicking, or was
> kicking without good reason, since the 1ms clock was too coarse.
> 
> Last patch also fixes an issue with Hystart vs TCP pacing.
> 
> v2: removed a last-minute debug chunk from last patch

Series applied, please address Neil's feedback on patch #4.
