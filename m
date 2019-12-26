Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF9512A96A
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 01:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfLZAfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 19:35:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfLZAfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 19:35:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23ACF15386D94;
        Wed, 25 Dec 2019 16:35:50 -0800 (PST)
Date:   Wed, 25 Dec 2019 16:35:49 -0800 (PST)
Message-Id: <20191225.163549.752942690967874824.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     arvid.brodin@alten.se, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/6] hsr: fix several bugs in hsr module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191222112458.2859-1-ap420073@gmail.com>
References: <20191222112458.2859-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Dec 2019 16:35:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Series applied, thank you.
