Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43782165C83
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 12:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgBTLLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 06:11:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgBTLLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 06:11:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46B7207FD;
        Thu, 20 Feb 2020 11:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582197090;
        bh=IqGe6nRCCTQfy3YAt4b2Q5IEeKFTp0zXzs+XkdE28gI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WyJ//zoefTT+rMGmjkFcz4gvqZoLverrcxN7cUa5pnwP2WCbsH8OxHm/+ugHLMugp
         36IqGmoz1MYF1GebhMGHoDu0kzfVMzhf3e3fPajymIeMteurj9DOpEaR1bUIPyys0n
         5ESZa+XJFlbvgM1WYaWfz1+60l9Q8sdYJWTVkRLo=
Date:   Thu, 20 Feb 2020 12:11:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/9] sysfs: add
 sysfs_file_change_owner{_by_name}()
Message-ID: <20200220111128.GC3374196@kroah.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-2-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218162943.2488012-2-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 05:29:35PM +0100, Christian Brauner wrote:
> Add helpers to change the owner of a sysfs files.
> This function will be used to correctly account for kobject ownership
> changes, e.g. when moving network devices between network namespaces.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v2 */
> -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>    - Better naming for sysfs_file_change_owner() to reflect the fact that it
>      can be used to change the owner of the kobject itself by passing NULL as
>      argument.
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Split sysfs_file_change_owner() into two helpers sysfs_change_owner() and
>     sysfs_change_owner_by_name(). The former changes the owner of the kobject
>     itself, the latter the owner of the kobject looked up via the name
>     argument.
> 
> /* v3 */
> -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>    - Add explicit uid/gid parameters.

Looks much better, thanks for doing these changes.  I'll review the
whole series now...

greg k-h
