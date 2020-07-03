Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212C5213EEA
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 19:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgGCRoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 13:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgGCRoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 13:44:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA2682084C;
        Fri,  3 Jul 2020 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593798241;
        bh=mShitwIuzxp3DRL6sOphOxChg78yr3Ymh+hHF6gB+5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RAvNGFsxPBwEQWr252N0sXwrY/up5f2G+gNbKTPCGHOoovHnBFV21mLnjpvCkgd9Y
         qmxIScfl98WA9C8pHbugd1O2LlUQKD0Fadh1oX21K0v+pzvJzlRKAcA6HMXzBnMvA3
         XgJsUuv6XpVwwe95P4sLW5X51BB3Nj8wn+lug9gU=
Date:   Fri, 3 Jul 2020 10:43:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andre Edich <andre.edich@microchip.com>
Cc:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>,
        <Parthiban.Veerasooran@microchip.com>
Subject: Re: [PATCH net 0/2] smsc95xx: fix smsc95xx_bind
Message-ID: <20200703104358.7bfc1f75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200703132506.12359-1-andre.edich@microchip.com>
References: <20200703132506.12359-1-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jul 2020 15:25:04 +0200 Andre Edich wrote:
> The patchset fixes two problems in the function smsc95xx_bind:
>  - return of false success
>  - memory leak

Could you add Fixes tags to both patches?
