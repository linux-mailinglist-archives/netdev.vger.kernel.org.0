Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829C919048C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgCXEn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:43:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56326 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXEn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:43:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F9741579A17F;
        Mon, 23 Mar 2020 21:43:26 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:43:25 -0700 (PDT)
Message-Id: <20200323.214325.617532102957279814.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] bnxt_en: Bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
References: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:43:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 22 Mar 2020 16:40:00 -0400

> 5 bug fix patches covering an indexing bug for priority counters, memory
> leak when retrieving DCB ETS settings, error path return code, proper
> disabling of PCI before freeing context memory, and proper ring accounting
> in error path.

Series applied.

> Please also apply these to -stable.  Thanks.

Queued up, thanks.
