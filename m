Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8B89535F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfHTB1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:27:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39296 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfHTB1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:27:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 598DA14B8F03B;
        Mon, 19 Aug 2019 18:27:44 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:27:43 -0700 (PDT)
Message-Id: <20190819.182743.22753599842704079.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net-next 0/8] sctp: support per endpoint auth and
 asconf flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:27:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 22:02:42 +0800

> This patchset mostly does 3 things:
> 
>   1. add per endpint asconf flag and use asconf flag properly
>      and add SCTP_ASCONF_SUPPORTED sockopt.
>   2. use auth flag properly and add SCTP_AUTH_SUPPORTED sockopt.
>   3. remove the 'global feature switch' to discard chunks.

Series applied, thanks.
