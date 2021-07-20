Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EF13D020D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhGTS23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 14:28:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53836 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhGTS20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 14:28:26 -0400
Received: from localhost (unknown [51.219.3.84])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 372354F6948CC;
        Tue, 20 Jul 2021 12:09:03 -0700 (PDT)
Date:   Tue, 20 Jul 2021 12:08:57 -0700 (PDT)
Message-Id: <20210720.120857.447378612092310208.davem@davemloft.net>
To:     arnd@kernel.org
Cc:     netdev@vger.kernel.org, hch@lst.de, arnd@arndb.de
Subject: Re: [PATCH net-next v2 00/31] ndo_ioctl rework
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 20 Jul 2021 12:09:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This gets several rejects against bet-next, please respin.

Thank you.

