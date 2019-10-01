Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D09C3A7D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389966AbfJAQ3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:29:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49332 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfJAQ3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:29:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3353154B74E9;
        Tue,  1 Oct 2019 09:29:20 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:29:20 -0700 (PDT)
Message-Id: <20191001.092920.502666999762381001.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-10-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001160117.13628-1-johannes@sipsolutions.net>
References: <20191001160117.13628-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:29:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue,  1 Oct 2019 18:01:16 +0200

> Here's a list of fixes - the BHs disabled one has been reported
> multiple times, and the SSID/MBSSID ordering one has over-the-air
> security implementations.
> 
> Please pull and let me know if there's any problem.

Pulled and build testing, thanks Johannes.
