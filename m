Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8C0EBB9
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 22:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfD2Ui7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 16:38:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729283AbfD2Ui7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 16:38:59 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FE69144FCAEA;
        Mon, 29 Apr 2019 13:38:58 -0700 (PDT)
Date:   Mon, 29 Apr 2019 16:38:55 -0400 (EDT)
Message-Id: <20190429.163855.483239595705702054.davem@davemloft.net>
To:     tom@quantonium.net
Cc:     stephen@networkplumber.org, tom@herbertland.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v7 net-next 4/6] exthdrs: Add TX parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAPDqMerHkVN5Rr6OQkp534usb9pR8z1X0eMKquBt475BChh6Ww@mail.gmail.com>
References: <1556563576-31157-5-git-send-email-tom@quantonium.net>
        <20190429123520.419ed9d4@hermes.lan>
        <CAPDqMerHkVN5Rr6OQkp534usb9pR8z1X0eMKquBt475BChh6Ww@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 13:38:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>
Date: Mon, 29 Apr 2019 13:36:03 -0700

> I sort of like being explict here to list all the fields to make it
> easy to use as a template for adding new structures.

Someone doing a sweep over the tree with automated tools is going to
remove it.

So kill these zero initializers from the start please.
