Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E792AE3F2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbgKJXWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:22:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgKJXWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:22:45 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B22A20781;
        Tue, 10 Nov 2020 23:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605050564;
        bh=I1wn0YndI3i2ALunGF24vwSx7K48sLYI8X+7ki52hJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a6Un3f/p+oud5In+RMmjOVQyT8bjdWQxjQy//+TQsbVw07HKJzfACETs3FEltGCsu
         bF5jAtheUaDq21uZ9fc3Ly+vqLxn81r/HyfvLalN59DIKLMr9FSEXF7y2va+Ms26jt
         92v20Rx85UEdGxfNrVFHw7n++r/fMynZ4H0xz1WM=
Date:   Tue, 10 Nov 2020 15:22:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH v2] net: ipv4: remove redundant initialization in
 inet_rtm_deladdr
Message-ID: <20201110152243.6b7f2b86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201108010541.12432-1-dong.menglong@zte.com.cn>
References: <20201108010541.12432-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Nov 2020 09:05:41 +0800 Menglong Dong wrote:
> The initialization for 'err' with '-EINVAL' is redundant and
> can be removed, as it is updated soon.
> 
> Changes since v1:
> - Remove redundant empty line
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Applied, thanks.
