Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040371E3687
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgE0D3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0D3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:29:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B947AC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:29:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B54812793ABB;
        Tue, 26 May 2020 20:29:11 -0700 (PDT)
Date:   Tue, 26 May 2020 20:29:10 -0700 (PDT)
Message-Id: <20200526.202910.1745567634164435171.davem@davemloft.net>
To:     dnlplm@gmail.com
Cc:     bjorn@mork.no, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit LE910C1-EUX
 composition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525212537.2227-1-dnlplm@gmail.com>
References: <20200525212537.2227-1-dnlplm@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:29:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>
Date: Mon, 25 May 2020 23:25:37 +0200

> Add support for Telit LE910C1-EUX composition
> 
> 0x1031: tty, tty, tty, rmnet
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Applied, thank you.
