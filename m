Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21502313C7
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgG1UWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728234AbgG1UWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:22:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB382065E;
        Tue, 28 Jul 2020 20:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595967774;
        bh=/+omfSZLhvK02U5FcKCre386kJT6ulWLVMrAVUiZcW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lNh4idu73rD2FriV5wXz6P0JNCxKTgPu2NyHg5gCH96Si1a6RK7r0m5IWQOgnBPsL
         G0wgQbwzxuPuvWVdKbZqtdqc/xlwfO9ejBkPl6XHwwNQwpxGi8mjXk7C/NupUfdQVB
         iE32XgTVdSMvAGrzn4Is2WUyA5aUvArjVONt7ZWA=
Date:   Tue, 28 Jul 2020 13:22:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net V2 00/11] mlx5 fixes-2020-07-28
Message-ID: <20200728132252.7364fdf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 12:59:24 -0700 Saeed Mahameed wrote:
> Hi Dave,
> 
> This series introduces some fixes to mlx5 driver.
> v1->v2:
>  - Drop the "Hold reference on mirred devices" patch, until Or's
>    comments are addressed.
>  - Imporve "Modify uplink state" patch commit message per Or's request.

Acked-by: Jakub Kicinski <kuba@kernel.org>
