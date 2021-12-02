Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C3A465E63
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 07:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhLBGq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 01:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345419AbhLBGpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 01:45:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D26C061574;
        Wed,  1 Dec 2021 22:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E09FDCE21BA;
        Thu,  2 Dec 2021 06:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A76C53FCC;
        Thu,  2 Dec 2021 06:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638427299;
        bh=N6s8uyXaMMbHTbaRzaIZf1iqKMVGcdcuwE2QAnSJP/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1edUzoosLnLNB5sm67pQrYuNM4Ra5WTtE6YDOHP/Fn8dG7nIk4Dz8fcYVVnUMec+M
         5fOnktik/v6hXjPN16lvDO9XJFdXN9y9YKfyLgZpSYFh6U+YAhNDolL8Ou//5Ywd1M
         GYMoTE4fgmnhodSJfECMg2sZopMtU1p9vAFnUfhg=
Date:   Thu, 2 Dec 2021 07:41:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     roots@gmx.de, kuba@kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, stable@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH] igc: Avoid possible deadlock during suspend/resume
Message-ID: <YahqnvgmT63iG48E@kroah.com>
References: <87r1awtdx3.fsf@intel.com>
 <20211201185731.236130-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201185731.236130-1-vinicius.gomes@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 10:57:31AM -0800, Vinicius Costa Gomes wrote:
> Inspired by:
> https://bugzilla.kernel.org/show_bug.cgi?id=215129
> 

This changelog does not say anything at all, sorry.  Please explain what
is happening here as the kernel documentation asks you to.

> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
> Just to see if it's indeed the same problem as the bug report above.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
