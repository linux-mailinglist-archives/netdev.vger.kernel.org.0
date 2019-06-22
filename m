Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1744F5F8
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 15:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfFVNo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 09:44:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFVNo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 09:44:57 -0400
Received: from localhost (unknown [8.46.76.25])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CAEE15394EF8;
        Sat, 22 Jun 2019 06:44:51 -0700 (PDT)
Date:   Sat, 22 Jun 2019 09:44:47 -0400 (EDT)
Message-Id: <20190622.094447.257491246684509114.davem@davemloft.net>
To:     tiwai@suse.de
Cc:     paulus@samba.org, linux-ppp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ppp: mppe: Add softdep to arc4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619133407.6800-1-tiwai@suse.de>
References: <20190619133407.6800-1-tiwai@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 06:44:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 19 Jun 2019 15:34:07 +0200

> The arc4 crypto is mandatory at ppp_mppe probe time, so let's put a
> softdep line, so that the corresponding module gets prepared
> gracefully.  Without this, a simple inclusion to initrd via dracut
> failed due to the missing dependency, for example.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Applied.
