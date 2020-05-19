Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45D51DA486
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgESW1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESW1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:27:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74F6C061A0F
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:27:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 289E0128EC8DD;
        Tue, 19 May 2020 15:27:42 -0700 (PDT)
Date:   Tue, 19 May 2020 15:27:41 -0700 (PDT)
Message-Id: <20200519.152741.1857499409331981778.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next v2 0/2] nfp: flower: feature bit updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519141502.18676-1-simon.horman@netronome.com>
References: <20200519141502.18676-1-simon.horman@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:27:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Tue, 19 May 2020 16:15:00 +0200

> this short series has two parts.
> 
> * The first patch cleans up the treatment of existing feature bits.
>   There are two distinct methods used and the code now reflects this
>   more clearly.
> * The second patch informs firmware of flower features. This allows
>   the firmware to disable certain features in the absence of of host support.
> 
> Changes since v1
> - Add now-first patch to clean up existing implementation
> - Address Jakub's feedback

Series applied, thanks Simon.
