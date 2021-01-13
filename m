Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9EF2F418E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbhAMCOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:14:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbhAMCOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:14:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A088F22EBE;
        Wed, 13 Jan 2021 02:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610504009;
        bh=vArons9PZPqX5tCruIVe9XiJOMRDVRPWHScOPA3JbyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OldYpnMmK8ZtbzjU6iEVtO9ZO4uGLPqssFX/H6d6qVnK1m3jQYjAZB/xxFKL2wWHK
         U6E8QaBzItHckNLq0+xRbFfopILdLI6jSyNrtDuGshLSvIjpT2m3b2nUB7SNazBG6r
         WMeK0HlLrLnWG/85HgILk2yxHV/1rQexr+grUvdDJeHIBLir2inTVROyuw+xoicx5o
         YmEOn8idTyjRPSYH3P+hjMkfSaqJ/GciB44ZGE7c91tMbADmBJJX/fTHPdg9qN8SQD
         z4r1jYRXgPXGLHbUqlcXYeUuqpwTn+KU+QNBmYyYe3sfQh2yfzmGRcBsNW4bwnG5aS
         QXfGYXIToFO2Q==
Date:   Tue, 12 Jan 2021 18:13:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyingjie55@126.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
Message-ID: <20210112181328.091f7cfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610417389-9051-1-git-send-email-wangyingjie55@126.com>
References: <1610417389-9051-1-git-send-email-wangyingjie55@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 18:09:49 -0800 wangyingjie55@126.com wrote:
> From: Yingjie Wang <wangyingjie55@126.com>
> 
> In rvu_mbox_handler_cgx_mac_addr_get()
> and rvu_mbox_handler_cgx_mac_addr_set(),
> the msg is expected only from PFs that are mapped to CGX LMACs.
> It should be checked before mapping,
> so we add the is_cgx_config_permitted() in the functions.
> 
> Fixes: 289e20bc1ab5 ("af/rvu_cgx: Fix missing check bugs in rvu_cgx.c")
> Signed-off-by: Yingjie Wang <wangyingjie55@126.com>


Fixes tag: Fixes: 289e20bc1ab5 ("af/rvu_cgx: Fix missing check bugs in rvu_cgx.c")
Has these problem(s):
	- Target SHA1 does not exist

Where is that commit from? You're not referring to this commit itself
in your tree? The subject is suspiciously similar :S
