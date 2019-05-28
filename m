Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EDE2CE0E
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfE1Ryx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:54:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfE1Ryx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 13:54:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1CC612D6B4D0;
        Tue, 28 May 2019 10:54:52 -0700 (PDT)
Date:   Tue, 28 May 2019 10:54:50 -0700 (PDT)
Message-Id: <20190528.105450.2066055659215742246.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, tom@quantonium.net
Subject: Re: [PATCH net-next 0/4] ipv6: Update RFC references and implement
 ICMP errors for limits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558905306-2968-1-git-send-email-tom@quantonium.net>
References: <1558905306-2968-1-git-send-email-tom@quantonium.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 10:54:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Any time you say "Do A and B" it means that your patch set is doing
two different things and should be split up properly into two separate
submissions.
