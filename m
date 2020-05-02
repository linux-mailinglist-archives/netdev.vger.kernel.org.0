Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0951C2906
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgEBXnv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 May 2020 19:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgEBXnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 19:43:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC586C061A0C;
        Sat,  2 May 2020 16:43:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5FFA415166C3B;
        Sat,  2 May 2020 16:43:50 -0700 (PDT)
Date:   Sat, 02 May 2020 16:43:49 -0700 (PDT)
Message-Id: <20200502.164349.488231555246678455.davem@davemloft.net>
To:     Kangie@footclan.ninja
Cc:     bjorn@mork.no, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for DW5816e
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200502155228.11535-1-Kangie@footclan.ninja>
References: <20200502155228.11535-1-Kangie@footclan.ninja>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 May 2020 16:43:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Jolly <Kangie@footclan.ninja>
Date: Sun,  3 May 2020 01:52:28 +1000

> Add support for Dell Wireless 5816e to drivers/net/usb/qmi_wwan.c
> 
> Signed-off-by: Matt Jolly <Kangie@footclan.ninja>

Bjørn, please review.
