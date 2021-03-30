Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA8434EE91
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhC3Q5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhC3Q5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 12:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57559619A7;
        Tue, 30 Mar 2021 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617123420;
        bh=N9QsFO4gX80bBfmNggo0nfTWKB62BzJ6TQ6Z0yfhB6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qZtcieMWuPndfexXZk75CJrQJY2TqT0szlW/DnZD6q4MUpQ8NgPPfUZK5B47j4VeE
         DxOZypMg3k1lX1ADdW2amC3Ds915RstxMtnGj7QAUKtY9ikjJWqXmeky+HASNAKd4D
         5F/KUbX3DR1rfDC3PNcCsvtBWaF29FjXb7dXfttBw+uVpfGY+3IkRF+oZDAK21OOxS
         fknwSGIfdUnd0wroqjQV43M+2w4niA3qlGr09YUa/1VmF5iVOEZ11s+mEC89/q+Div
         X+YuQyUPF5hc8IjZhk42Jw0EKax09nObBvh4yXWeyvp5rWKvlWwl7FE6jcQkAnwdlR
         tat1IKrvejIDQ==
Date:   Tue, 30 Mar 2021 12:56:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Brazdil <dbrazdil@google.com>
Cc:     stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jamorris@linux.microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jeff Vander Stoep <jeffv@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH pre-5.10] selinux: vsock: Set SID for socket returned by
 accept()
Message-ID: <YGNYWyRFwAt6Woel@sashalap>
References: <20210329182443.1960963-1-dbrazdil@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210329182443.1960963-1-dbrazdil@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 06:24:43PM +0000, David Brazdil wrote:
>[Backport of commit 1f935e8e72ec28dddb2dc0650b3b6626a293d94b to all
>stable branches from 4.4 to 5.4, inclusive]
>
>For AF_VSOCK, accept() currently returns sockets that are unlabelled.
>Other socket families derive the child's SID from the SID of the parent
>and the SID of the incoming packet. This is typically done as the
>connected socket is placed in the queue that accept() removes from.
>
>Reuse the existing 'security_sk_clone' hook to copy the SID from the
>parent (server) socket to the child. There is no packet SID in this
>case.

Queued up, thanks!

-- 
Thanks,
Sasha
