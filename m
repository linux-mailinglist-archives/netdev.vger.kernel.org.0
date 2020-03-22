Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2150818E626
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgCVC4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:56:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVC4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:56:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8C5815ABF03B;
        Sat, 21 Mar 2020 19:56:29 -0700 (PDT)
Date:   Sat, 21 Mar 2020 19:56:28 -0700 (PDT)
Message-Id: <20200321.195628.916348035610104791.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] ionic error recovery fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320023153.48655-1-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 19:56:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 19 Mar 2020 19:31:47 -0700

> These are a few little patches to make error recovery a little
> more safe and successful.

Series applied, thank you.
