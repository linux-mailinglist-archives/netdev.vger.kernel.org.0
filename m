Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94627463EB6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 20:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbhK3Tme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 14:42:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47444 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbhK3Tmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 14:42:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01D9CB81A8C;
        Tue, 30 Nov 2021 19:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C12AC53FC7;
        Tue, 30 Nov 2021 19:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638301151;
        bh=Y6jZKrfiz+scxKCSkey8clUNA9CWrzcgBfUmzspPyKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s/EbTfYZXRwcfluroG10mRjBu+yCutGKy03a+jd7z2bqoiWVJQmqGiDOctRatoygk
         mhfbKPBBUTENfDxrG13j7MVe9berpiUxgKh5oBAtk/1pv5XvxjqXUyDxxZRrz4IfZh
         AaffoFYaL8+ZU04ps/hysSM4da0rIcyNtV2pAHJCxJHp2jluW+Mw5SZFEyYICs1JXo
         DP1Zl/ybuekHtCbLMhIa3YUWRMRjEM9jzN8b4ea0tUODtksGH5pDMqTsOn3aVywQQv
         nnUJfLnTr52T9GZW4rRmaIp5Y6ft11fRZ9qpHJEZc5/L13uSSkNNPL//sJEHaz7Sh1
         7HVl41l2aK5uA==
Date:   Tue, 30 Nov 2021 11:39:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Drory <shayd@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net/mlx5: Memory optimizations
Message-ID: <20211130113910.25a9e3ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130150705.19863-1-shayd@nvidia.com>
References: <20211130150705.19863-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 17:07:02 +0200 Shay Drory wrote:
>  - Patch-1 Provides I/O EQ size resource which enables to save
>    up to 128KB.
>  - Patch-2 Provides event EQ size resource which enables to save up to
>    512KB.

Why is something allocated in host memory a device resource? =F0=9F=A4=94

Did you analyze if others may need this?
