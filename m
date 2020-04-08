Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370FC1A2B26
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgDHVcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:32:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729613AbgDHVcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:32:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5C49127D38A4;
        Wed,  8 Apr 2020 14:32:18 -0700 (PDT)
Date:   Wed, 08 Apr 2020 14:32:18 -0700 (PDT)
Message-Id: <20200408.143218.803342029034510068.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, challa@noironetworks.com,
        linux-kernel@vger.kernel.org, taras.chornyi@plvision.eu
Subject: Re: [PATCH net] net: ipv4: devinet: Fix crash when add/del
 multicast IP with autojoin
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200407221328.32603-1-vadym.kochan@plvision.eu>
References: <20200407221328.32603-1-vadym.kochan@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Apr 2020 14:32:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Wed,  8 Apr 2020 01:13:28 +0300

> steps to reptoduse:
           ^^^^^^^^^

Typo, should be "reproduce"
