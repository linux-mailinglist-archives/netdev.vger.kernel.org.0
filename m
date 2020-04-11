Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5416F1A4CE5
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 02:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgDKAX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 20:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgDKAX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 20:23:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E11220936;
        Sat, 11 Apr 2020 00:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586564608;
        bh=f0p2kHyven9B7/rEs4yASxu/X7zNikw2/7hIkDrfLf0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DVzTN+cq8OybNLSiIhfj7Lf3JzHWc0u3Wt9XOWKZyqKW6SGG3GgxPjrjBXWfF9NQ+
         EJ7cVy+xzas4uNIYrk2bXDELt9sm+DJihr9xT4D2493iyNAGi6ab4FHrj+B24cejwf
         B1LHyl+7ke6Fli78TDcqUEQEwmNSZ5wqSbg7UN3E=
Date:   Fri, 10 Apr 2020 17:23:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     keescook@chromium.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH v5 0/5] kselftest: add fixture parameters
Message-ID: <20200410172326.3ad05290@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200318010153.40797-1-kuba@kernel.org>
References: <20200318010153.40797-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 18:01:48 -0700 Jakub Kicinski wrote:
> Hi!
> 
> Shuah please consider applying to the kselftest tree.
> 
> This set is an attempt to make running tests for different
> sets of data easier. The direct motivation is the tls
> test which we'd like to run for TLS 1.2 and TLS 1.3,
> but currently there is no easy way to invoke the same
> tests with different parameters.
> 
> Tested all users of kselftest_harness.h.

Hi Shuah!

Were these applied anywhere? I'm happy to take them via 
the networking tree if that's easier.
