Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5DF2DA88D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgLOHbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgLOHbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 02:31:37 -0500
Message-ID: <44630610f64e4535646e4cb5ba8e0e62d52fc360.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608017457;
        bh=w1nz95JmPQvYuB8yU95zy6VmbmaEmKTSvysZF62WVCg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WOlS0dA1X1rQaCDSx4ELOSedA0UweV9BgzfyNM11X5APKxBOSASPLyuA4DkbqKxa3
         PvnOaoY3caf+alsEilXG/O4NvfGRRpUKUBiHlBRVcOJg1VFiB289TacmOY4jtNYIgc
         IzwF5G1XlJBEUoRPryL6rnROi5IvyRidJcn59KE8DteNjKUuAxp1k5wp6gV5SYTXXW
         tpUl1hKfNgfmPQex63zTM1kW1rS2jFDYRkeQEnA7C6yXmlDXBfb4hObULbS9JSIU+p
         kPwkHDJdnCDuPTWmVcTCjO/sI227Ao3Atc8OFcvtk3a8GiogdqxhUT+wjaf5BEY3tv
         xGAG6bGy8y4+A==
Subject: Re: [PATCH -next v2] net/mlx5_core: remove unused including
 <generated/utsrelease.h>
From:   Saeed Mahameed <saeed@kernel.org>
To:     Zou Wei <zou_wei@huawei.com>, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 23:30:55 -0800
In-Reply-To: <1607497292-121156-1-git-send-email-zou_wei@huawei.com>
References: <1607497292-121156-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-09 at 15:01 +0800, Zou Wei wrote:
> Remove including <generated/utsrelease.h> that don't need it.
> 
> Fixes: 17a7612b99e6 ("net/mlx5_core: Clean driver version and name")
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---

Applied to net-next-mlx5.

Thanks!

