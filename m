Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF7B1C7C0D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgEFVLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729162AbgEFVLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:11:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A655BC061A0F;
        Wed,  6 May 2020 14:11:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CC68122A98F1;
        Wed,  6 May 2020 14:11:50 -0700 (PDT)
Date:   Wed, 06 May 2020 14:11:49 -0700 (PDT)
Message-Id: <20200506.141149.81578290716709045.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH v2 net-next 00/10] s390/qeth: updates 2020-05-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506080949.3915-1-jwi@linux.ibm.com>
References: <20200506080949.3915-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:11:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed,  6 May 2020 10:09:39 +0200

> please apply the following patch series for qeth to netdev's net-next
> tree.
> Same patches as yesterday, except that the ethtool reset has been
> dropped for now.
> 
> This primarily adds infrastructure to deal with HW offloads when the
> packets get forwarded over the adapter's internal switch.
> Aside from that, just some minor tweaking for the TX code.

Series applied, thanks Julian.
