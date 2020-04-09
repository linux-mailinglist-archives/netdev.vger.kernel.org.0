Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF371A38B1
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgDIRMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:12:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgDIRMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:12:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E55F128C0940;
        Thu,  9 Apr 2020 10:12:06 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:12:05 -0700 (PDT)
Message-Id: <20200409.101205.1131645111037893713.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        challa@noironetworks.com, linux-kernel@vger.kernel.org,
        taras.chornyi@plvision.eu
Subject: Re: [PATCH net v2] net: ipv4: devinet: Fix crash when add/del
 multicast IP with autojoin
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200409053932.22902-1-vadym.kochan@plvision.eu>
References: <20200409053932.22902-1-vadym.kochan@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:12:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Thu,  9 Apr 2020 08:39:32 +0300

> Fixes: 93a714d (multicast: Extend ip address command to enable multicast group join/leave on)

Fixes tags must specify commit IDs with 12 digits of significance.
Please fix this and resubmit.

And in the parenthesis, the commit header text should also be surrounded
by double quotes like ("...")
