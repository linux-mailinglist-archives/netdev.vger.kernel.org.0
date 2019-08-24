Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C0E9C033
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 22:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfHXUrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 16:47:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbfHXUrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 16:47:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9407015249296;
        Sat, 24 Aug 2019 13:47:45 -0700 (PDT)
Date:   Sat, 24 Aug 2019 13:47:42 -0700 (PDT)
Message-Id: <20190824.134742.654247809680601663.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154 for net 2019-08-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190824121953.27839-1-stefan@datenfreihafen.org>
References: <20190824121953.27839-1-stefan@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 13:47:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Sat, 24 Aug 2019 14:19:53 +0200

> An update from ieee802154 for your *net* tree.
> 
> Yue  Haibing fixed two bugs discovered by KASAN in the hwsim driver for
> ieee802154 and Colin Ian King cleaned up a redundant variable assignment.
> 
> If there are any problems let me know.

Pulled, thank you.
