Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329F541BBBF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbhI2AgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240715AbhI2AgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 20:36:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F0660FBF;
        Wed, 29 Sep 2021 00:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632875664;
        bh=fuqUv3K4+9FVZI2p8hzSC3As4WtmgpetsPpoDdXRwXE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VIPeH2IHHJFt0c2VlpXdzcwFdUpx895urgOViC/pxNMcd29SoSZ/pS/pZptNr6ekp
         Z9Qy1DNspEu1VbAmTvUWPqsL7Lwlc5OaPSqI5Q9Ynm3CtWvldPbA7qbyqCA26lt+Q+
         P7AlZVeF2Y1GB5eybGbsgGKlcBgM4kUQm6vXN50ihBHXQnYgJKSqX3PXcFdeV+rK4z
         8OkbLo+ZlnLEh+GvJbuYl22o4rxQcghvVaaBOsVOZkbzVk/xdbEfEINVGKu+udV+D0
         uHsIxg/Q2KoCsf1OgMU0ZfuUOkd/Bshu5kqjpBlSy8I5wkcyTMnmsRMhZ6eXmawtKH
         S6AxCB+Ta4Dug==
Date:   Tue, 28 Sep 2021 17:34:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net/ipv4/fib_notifier.c remove superfluous header
 files from fib_notifier.c
Message-ID: <20210928173423.461fc8e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210928164011.1454-1-liumh1@shanghaitech.edu.cn>
References: <20210928164011.1454-1-liumh1@shanghaitech.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 00:40:11 +0800 Mianhan Liu wrote:
> fib_notifier.chasn't use any macro or function declared in net/netns/ipv4.h.
> Thus, these files can be removed from fib_notifier.c safely without
> affecting the compilation of the net/ipv4 module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

This one looks fine, applied, thanks!
