Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B253C368498
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhDVQPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236333AbhDVQPC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 12:15:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C80961405;
        Thu, 22 Apr 2021 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619108067;
        bh=cCHZPD8ZDPdlMH3New4aAFsblGu0V3cSV+H0uK/9UCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lu97nNMA2DN+jFZBMhDrsdwtCA4BgWiszK/YGDGZrHYt43KptUjdd7GtBxIlPR5p0
         Or6KlguwaNOMvljNfQkDUUJL3gS7Z2UKbDUmZhaZcHkKquq4OOeb9lksOoEmELEjfG
         H5dtGYcZO+DJ4z8OcVUFRjbvgm/vzqHAUqotitxvbsNPk9sL3EsYBNoiPeyZfOCUNF
         YuPk7sWmYms8dSCrKtZ7S38R2AAFtyf1++t2wQ10zzeKybUU0MC4K6tkHXZLYos4NE
         uWYBki3HEbQ0/cBbG3lvgIWseqSGEKAODJxyi4jtX38Sz8LEJJBTfQ4aVxIuiQmPWC
         qtIRtE5tkpvbQ==
Date:   Thu, 22 Apr 2021 09:14:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] netdevsim: Only use sampling truncation length
 when valid
Message-ID: <20210422091426.6fda8280@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210422135050.2429936-1-idosch@idosch.org>
References: <20210422135050.2429936-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 16:50:50 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> When the sampling truncation length is invalid (zero), pass the length
> of the packet. Without the fix, no payload is reported to user space
> when the truncation length is zero.
> 
> Fixes: a8700c3dd0a4 ("netdevsim: Add dummy psample implementation")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

> +	md->trunc_size = psample->trunc_size ? psample->trunc_size : len;

nit:  ... = psample->trunc_size ? : len;  ?
