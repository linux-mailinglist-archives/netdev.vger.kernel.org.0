Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877A028434
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfEWQsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:48:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729218AbfEWQsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:48:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C312B150A82AF;
        Thu, 23 May 2019 09:48:21 -0700 (PDT)
Date:   Thu, 23 May 2019 09:48:21 -0700 (PDT)
Message-Id: <20190523.094821.1455033797037166263.davem@davemloft.net>
To:     subashab@codeaurora.org
Cc:     elder@linaro.org, bjorn.andersson@linaro.org, arnd@arndb.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: qualcomm: rmnet: Move common struct
 definitions to include
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558556467-12007-1-git-send-email-subashab@codeaurora.org>
References: <1558556467-12007-1-git-send-email-subashab@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:48:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date: Wed, 22 May 2019 14:21:07 -0600

> Create if_rmnet.h and move the rmnet MAP packet structs to this
> common include file. To account for portablity, add little and
> big endian bitfield definitions similar to the ip & tcp headers.
> 
> The definitions in the headers can now be re-used by the
> upcoming ipa driver series as well as qmi_wwan.
> 
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Applied.
