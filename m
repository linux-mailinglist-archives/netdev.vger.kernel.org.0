Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244861BAD20
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgD0StD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgD0StD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:49:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3725AC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:49:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB93715D586A9;
        Mon, 27 Apr 2020 11:49:02 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:49:01 -0700 (PDT)
Message-Id: <20200427.114901.1280973211772172834.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: improve chip config handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e076bba2-e4dc-f8ce-d119-5b6735017727@gmail.com>
References: <e076bba2-e4dc-f8ce-d119-5b6735017727@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:49:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 26 Apr 2020 23:35:08 +0200

> Series includes two improvements for chip configuration handling.

Series applied, thanks.
