Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A851C5E5A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbgEERGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbgEERGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 13:06:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7BC206CC;
        Tue,  5 May 2020 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588698409;
        bh=tTVT7BQznaeeQv2ueCzSRGGQd+1lPc3rjhDCHTLInVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a2lTKS3q4bRFS3TqUo4OhuqTVvYyVxuFiH3f7mPsDwmvDTg+ZNiqOQzgY1uMPfQ/n
         MVo+fyWqj9uCKaIjgb0PtSupQRR0iHKi690MQR4xjcB6DzyoVrHxd8p6hhaYlOUAl0
         wp6Y9D0p4VT4j6pBrWYag5HbrB/5nXQmOn6MYNGo=
Date:   Tue, 5 May 2020 10:06:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, jiri@resnulli.us, netdev@vger.kernel.org,
        kernel-team@fb.com, jacob.e.keller@intel.com
Subject: Re: [PATCH iproute2-next v3] devlink: support kernel-side snapshot
 id allocation
Message-ID: <20200505100640.15a5093d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200505100536.206ad9b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200430175759.1301789-1-kuba@kernel.org>
        <20200430175759.1301789-5-kuba@kernel.org>
        <af7fae65-1187-65c5-9c40-0b0703cf4053@gmail.com>
        <20200505092009.1cfe01c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <76a99d9c-3574-1c8d-07cb-1f16e1bf9cca@gmail.com>
        <20200505100536.206ad9b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 10:05:36 -0700 Jakub Kicinski wrote:
> On Tue, 5 May 2020 10:59:28 -0600 David Ahern wrote:
> > merged and pushed. can you resend? I deleted it after it failed to apply
> > and now has vanished.  
> 
> Thanks! Resent now

Ah damn, I didn't add Jiri's review tag, should I resent again?
