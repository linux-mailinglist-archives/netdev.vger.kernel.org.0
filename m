Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D755287FA7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgJIA40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbgJIA4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 20:56:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2B122254;
        Fri,  9 Oct 2020 00:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602204982;
        bh=3Geiek3bGZyHs7vQ54vLrLu+FKf5iDVmdbVNxhGi6IQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m+Yav6H5w2KdvjsYIc8XPYHNZWsPRQmDyN1CjCWxj8UMDtHrWOEphomtdi0RmIqlh
         x74piA6S0cY2w4BfFLAc9ttrf4C1+tMbEPP17JpzAcEyjmNDqDnaYY8sJptCygU4oD
         55xzLEGUBoeQoTQ6w6Hp2xnh/mLAdVcrJ0CGF1Gg=
Date:   Thu, 8 Oct 2020 17:56:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] selftests: mptcp: interpret \n as a new line
Message-ID: <20201008175621.6d2f2ddd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c750c3256bec4ceab91a95f2725e4bc026f4b5dc.camel@redhat.com>
References: <20201006160631.3987766-1-matthieu.baerts@tessares.net>
        <c750c3256bec4ceab91a95f2725e4bc026f4b5dc.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 06 Oct 2020 18:12:45 +0200 Paolo Abeni wrote:
> On Tue, 2020-10-06 at 18:06 +0200, Matthieu Baerts wrote:
> > In case of errors, this message was printed:
> > 
> >   (...)
> >   balanced bwidth with unbalanced delay       5233 max 5005  [ fail ]
> >   client exit code 0, server 0
> >   \nnetns ns3-0-EwnkPH socket stat for 10003:
> >   (...)
> > 
> > Obviously, the idea was to add a new line before the socket stat and not
> > print "\nnetns".
> > 
> > The commit 8b974778f998 ("selftests: mptcp: interpret \n as a new line")
> > is very similar to this one. But the modification in simult_flows.sh was
> > missed because this commit above was done in parallel to one here below.
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks!
