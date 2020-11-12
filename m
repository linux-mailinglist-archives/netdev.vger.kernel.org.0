Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF502B1202
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKLWrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgKLWrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:47:06 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7346C2085B;
        Thu, 12 Nov 2020 22:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605221225;
        bh=L1qDBfuWoGFysf4iEZaz6zYPvDIHmPw8pxnAgHSoJHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1RWbRD3Y0CFxyLFeNGDwsTG1ELK02CY66uOt9APravogN/MMF2r9LLB9ZZFI/kGAe
         9CTD5JW0NzCXOJKhYFzRzh5wp670E5wpwRViVclxgDv8j6m1p8pcG2DUmhcdPN20D+
         DxnaReAwaaSJhHIaXKcXNvw7c40bfyFreiqGF6hQ=
Date:   Thu, 12 Nov 2020 14:47:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH v2 net-next] net: udp: remove redundant initialization
 in udp_gro_complete
Message-ID: <20201112144704.6760defe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5faa01d5.1c69fb81.8451c.cb5b@mx.google.com>
References: <5faa01d5.1c69fb81.8451c.cb5b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 21:57:58 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The initialization for 'err' with '-ENOSYS' is redundant and
> can be removed, as it is updated soon and not used.
> 
> Changes since v1:
> - Move the err declaration below struct sock *sk
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Applied, thanks!
