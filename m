Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901341C5E52
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgEERFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbgEERFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 13:05:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E141B206CC;
        Tue,  5 May 2020 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588698338;
        bh=MEyt7aSWbIgYiqob5dv8oqa2/x1g/R6jHmkznKo7b3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nff/AYC1ext961RQCyyI2jZEba+QCxFg4x+ibKx+ZHRHbi89pGaUWkfP7PjcrWIOY
         0ZzggmBllm0gQKCtZQAMUKYzPcbUq3A1BjqYFI/rolx9C8Yllj4ELgy1D4Isn3Nif2
         /MBTdN1dC1CUW6NiKQsm4ittYjVxKNsdba04Vn6U=
Date:   Tue, 5 May 2020 10:05:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, jiri@resnulli.us, netdev@vger.kernel.org,
        kernel-team@fb.com, jacob.e.keller@intel.com
Subject: Re: [PATCH iproute2-next v3] devlink: support kernel-side snapshot
 id allocation
Message-ID: <20200505100536.206ad9b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <76a99d9c-3574-1c8d-07cb-1f16e1bf9cca@gmail.com>
References: <20200430175759.1301789-1-kuba@kernel.org>
        <20200430175759.1301789-5-kuba@kernel.org>
        <af7fae65-1187-65c5-9c40-0b0703cf4053@gmail.com>
        <20200505092009.1cfe01c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <76a99d9c-3574-1c8d-07cb-1f16e1bf9cca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 10:59:28 -0600 David Ahern wrote:
> merged and pushed. can you resend? I deleted it after it failed to apply
> and now has vanished.

Thanks! Resent now
