Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B96018E5D
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfEIQqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:46:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfEIQqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:46:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C28BF14D071FF;
        Thu,  9 May 2019 09:46:19 -0700 (PDT)
Date:   Thu, 09 May 2019 09:46:19 -0700 (PDT)
Message-Id: <20190509.094619.2211366094183779478.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     oss-drivers@netronome.com, netdev@vger.kernel.org,
        edumazet@google.com, simon.horman@netronome.com
Subject: Re: [PATCH net] net/tcp: use deferred jump label for TCP acked
 data hook
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508234614.7751-1-jakub.kicinski@netronome.com>
References: <20190508234614.7751-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:46:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed,  8 May 2019 16:46:14 -0700

> User space can flip the clean_acked_data_enabled static branch
> on and off with TLS offload when CONFIG_TLS_DEVICE is enabled.
> jump_label.h suggests we use the delayed version in this case.
> 
> Deferred branches now also don't take the branch mutex on
> decrement, so we avoid potential locking issues.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Eric, please review.
