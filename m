Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3B368108
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 21:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfGNTWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 15:22:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbfGNTWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 15:22:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DA6F14E7D247;
        Sun, 14 Jul 2019 12:22:54 -0700 (PDT)
Date:   Sun, 14 Jul 2019 12:22:53 -0700 (PDT)
Message-Id: <20190714.122253.2166323325009613167.davem@davemloft.net>
To:     sergej.benilov@googlemail.com
Cc:     venza@brownhat.org, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH] sis900: correct a few typos
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190714165627.32765-1-sergej.benilov@googlemail.com>
References: <20190714165627.32765-1-sergej.benilov@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 14 Jul 2019 12:22:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergej Benilov <sergej.benilov@googlemail.com>
Date: Sun, 14 Jul 2019 18:56:27 +0200

> Correct a few typos in comments and debug text.
> 
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>

Applied.
