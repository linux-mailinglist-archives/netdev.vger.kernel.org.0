Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A079130364
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfE3Uls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:41:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3Ulr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 16:41:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6701914DAF62A;
        Thu, 30 May 2019 13:41:47 -0700 (PDT)
Date:   Thu, 30 May 2019 13:41:44 -0700 (PDT)
Message-Id: <20190530.134144.866018206534810561.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     edumazet@google.com, ycheng@google.com, cpaasch@apple.com,
        ilubashe@akamai.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] add TFO backup key
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 13:41:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Wed, 29 May 2019 12:33:55 -0400

> Christoph, Igor, and I have worked on an API that facilitates TFO key 
> rotation. This is a follow up to the series that Christoph previously
> posted, with an API that meets both of our use-cases. Here's a
> link to the previous work:
> https://patchwork.ozlabs.org/cover/1013753/
 ...
> Changes in v2:
>   -spelling fixes in ip-sysctl.txt (Jeremy Sowden)
>   -re-base to latest net-next

Series applied, thank you.
