Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECC338105C
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhENTPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233435AbhENTPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 15:15:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 690DE613AA;
        Fri, 14 May 2021 19:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621019674;
        bh=z18wKSqOqahkbywJ6L0H4CYb7mPZkfBtWI20Ka0xlwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bgBaZsyDB0RiIEoEk4fH0aTlDuxqlKFACaoY7/Tvrm3hTwzRPqW9vPF9lBy+eTAHy
         jVP6YSHLDNWC4P1jak8+ZrTWeZiQGm9+SYIbBrnHYaQC1Ngv0y8vinVB5DC7LAcCzC
         nj0kwPt9i5BN+OJM3spAwmEJivxcntnB28BYWYIyvyCxJtEQYcYkNaqoxZZfaD8Yq1
         YUtFTw/gtVqfKiByS10dSuy8MA3cljgNrfEWdonPUFgp8mVsZebMY1Y7j2iWMX2kYH
         PPSNCn5Hq7hP+FXL5fzVqTtfmbvMqpSmMI9rDW73aVCB2LAp21WyjdH28HrnfAmsAT
         PbcnI8KaTjGHA==
Date:   Fri, 14 May 2021 12:14:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net] netns: export get_net_ns_by_id()
Message-ID: <20210514121433.2d5082b3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210512212956.4727-1-ryazanov.s.a@gmail.com>
References: <20210512212956.4727-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 May 2021 00:29:56 +0300 Sergey Ryazanov wrote:
> No one loadable module is able to obtain netns by id since the
> corresponding function has not been exported. Export it to be able to
> use netns id API in loadable modules too as already done for
> peernet2id_alloc().

peernet2id_alloc() is used by OvS, what's the user for get_net_ns_by_id()?
