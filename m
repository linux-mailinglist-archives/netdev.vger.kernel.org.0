Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEC41C0C90
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgEADZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgEADZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:25:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC98C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:25:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E8FD1276FCCE;
        Thu, 30 Apr 2020 20:25:52 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:25:51 -0700 (PDT)
Message-Id: <20200430.202551.1731918847310613450.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        leoyang.li@nxp.com
Subject: Re: [PATCH] ptp_qoriq: output PPS signal on FIPER2 in default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427033903.9724-1-yangbo.lu@nxp.com>
References: <20200427033903.9724-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:25:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Mon, 27 Apr 2020 11:39:03 +0800

> Output PPS signal on FIPER2 (Fixed Period Interval Pulse) in default
> which is more desired by user.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied to net-next, thanks.
