Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B205AB8EC
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392832AbfIFNJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:09:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392815AbfIFNJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:09:38 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2AF58152F5302;
        Fri,  6 Sep 2019 06:09:36 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:09:35 +0200 (CEST)
Message-Id: <20190906.150935.1356210416291322796.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2019-09-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905102201.1636-1-steffen.klassert@secunet.com>
References: <20190905102201.1636-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:09:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Thu, 5 Sep 2019 12:21:56 +0200

> 1) Several xfrm interface fixes from Nicolas Dichtel:
>    - Avoid an interface ID corruption on changelink.
>    - Fix wrong intterface names in the logs.
>    - Fix a list corruption when changing network namespaces.
>    - Fix unregistation of the underying phydev.
> 
> 2) Fix a potential warning when merging xfrm_plocy nodes.
>    From Florian Westphal.
> 
> Please pull or let me know if there are problems.

Pulled, thanks Steffen.
