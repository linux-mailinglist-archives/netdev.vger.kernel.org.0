Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD4FC8C27
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfJBO6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:58:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60934 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfJBO6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:58:15 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 33B3F14BBEA7A;
        Wed,  2 Oct 2019 07:58:15 -0700 (PDT)
Date:   Wed, 02 Oct 2019 10:58:14 -0400 (EDT)
Message-Id: <20191002.105814.2025422266410800090.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Ease nsid allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <30d50c1d-d4c8-f339-816b-eb28ec4c0154@6wind.com>
References: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
        <20191001.212027.1363612671973318110.davem@davemloft.net>
        <30d50c1d-d4c8-f339-816b-eb28ec4c0154@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 07:58:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed, 2 Oct 2019 10:46:03 +0200

> Is a new flag attribute ok to turn on this reply?

That might work, yes.
