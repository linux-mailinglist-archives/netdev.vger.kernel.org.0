Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC472F043D
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 00:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAIXFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 18:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbhAIXFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 18:05:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8C92238E8;
        Sat,  9 Jan 2021 23:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610233481;
        bh=qVhQOtGx85Iv626xppmgH2GHprXmmmktCQ/ltNLjpB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lGhEcWFL6NZt5qCU1Fi5VO1WJzwppXG1HrqeTv2KfHXgx/ur87zLEVA2I7Ca0LrRm
         XmrSYSLKi9w6aToA/WXHFZ8Vv89u34APbf2q5zI+ZAZTwCL3HwHLEykHNgVmHG1eMt
         EwdrXy35HsBnwaPXJMrdmBlB3/tsbHtvhunS5/S6WFME+rL4Zp8DcFc9zFF0r8yHTI
         zM+2IxUJZwW6KRcumi6zkFbcOrBMpA9ry+t4jfUtGUG41pGfEVm+iWdsFb7Kqn834E
         8+k921dbf5MXiOWdXK7CBaw1qetOyPtnsDhVe+TfFD1UhEO3jxyMLkes9+/rQVYNlp
         fNdtQcHQTvX0g==
Date:   Sat, 9 Jan 2021 15:04:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, schoen@loyalty.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/11] selftests: Updates to allow single instance of
 nettest for client and server
Message-ID: <20210109150440.33b7ffe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210109110202.13d04aeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210109185358.34616-1-dsahern@kernel.org>
        <036b819f-57ad-972e-6728-b1ef87a31efe@gmail.com>
        <20210109110202.13d04aeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Jan 2021 11:02:02 -0800 Jakub Kicinski wrote:
> On Sat, 9 Jan 2021 11:55:39 -0700 David Ahern wrote:
> > On 1/9/21 11:53 AM, David Ahern wrote:  
> > > Update nettest to handle namespace change internally to allow a
> > > single instance to run both client and server modes. Device validation
> > > needs to be moved after the namespace change and a few run time
> > > options need to be split to allow values for client and server.  
> > 
> > Ugh, I forgot to add net-next to the subject line. Let me know if I
> > should re-send.  
> 
> We should be fine, the build bot will default to net-next if there are
> not Fixes tag, and you just told us you're targeting net-next so all
> clear.

Do you want to address the checkpatch issues, tho?
