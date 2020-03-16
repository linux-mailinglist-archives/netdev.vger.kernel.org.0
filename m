Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2321860AF
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 01:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgCPAGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 20:06:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729091AbgCPAGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 20:06:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA6EA1212CF6A;
        Sun, 15 Mar 2020 17:06:45 -0700 (PDT)
Date:   Sun, 15 Mar 2020 17:06:45 -0700 (PDT)
Message-Id: <20200315.170645.154359133223941410.davem@davemloft.net>
To:     tiwai@suse.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/6] net: Use scnprintf() for avoiding potential
 buffer overflow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200315093503.8558-1-tiwai@suse.de>
References: <20200315093503.8558-1-tiwai@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 17:06:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Sun, 15 Mar 2020 10:34:57 +0100

> here is a respin of trivial patch series just to convert suspicious
> snprintf() usages with the more safer one, scnprintf().
> 
> v1->v2: Align the remaining lines to the open parenthesis
>         Excluded i40e patch that was already queued

Series applied, thank you.
