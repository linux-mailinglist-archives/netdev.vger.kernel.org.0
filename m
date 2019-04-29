Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC122E5AB
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfD2PCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:02:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53586 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfD2PCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:02:30 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C67E13D36204;
        Mon, 29 Apr 2019 08:02:29 -0700 (PDT)
Date:   Mon, 29 Apr 2019 11:02:26 -0400 (EDT)
Message-Id: <20190429.110226.845933624683233442.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-04-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <459c1807e264def23b14441777a6cda6e432bfc4.camel@sipsolutions.net>
References: <20190426090747.20949-1-johannes@sipsolutions.net>
        <459c1807e264def23b14441777a6cda6e432bfc4.camel@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 08:02:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 29 Apr 2019 13:19:27 +0200

> Sorry to nag, and maybe I'm missing something, but I didn't see this
> show up in your tree, yet you marked it as accepted in patchwork:
> 
> https://patchwork.ozlabs.org/patch/1091413/
> 
> But maybe there's a gap that I should expect here, like you mark it as
> accepted when you start some kind of testing and then push it out later?
> 
> Really the only reason I'm asking is that I wanted to forward to apply
> another patch, but maybe I'll ask you to apply that one patch directly.

Sorry about that, I'll use the excuse that I'm travelling :-)

I've pulled it in now and pushed it back out, should certainly be
there for sure now.
