Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CA342E3B
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfFLSA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:00:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfFLSA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:00:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55A02142CA44E;
        Wed, 12 Jun 2019 11:00:27 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:00:26 -0700 (PDT)
Message-Id: <20190612.110026.622912750942178517.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2] vrf: Increment Icmp6InMsgs on the original
 netdev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610143250.18796-1-ssuryaextr@gmail.com>
References: <20190610143250.18796-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:00:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Mon, 10 Jun 2019 10:32:50 -0400

> Get the ingress interface and increment ICMP counters based on that
> instead of skb->dev when the the dev is a VRF device.
> 
> This is a follow up on the following message:
> https://www.spinics.net/lists/netdev/msg560268.html
> 
> v2: Avoid changing skb->dev since it has unintended effect for local
>     delivery (David Ahern).
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

Applied.
