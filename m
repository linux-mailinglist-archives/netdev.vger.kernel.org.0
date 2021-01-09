Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90C42F0303
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 20:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbhAITCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 14:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbhAITCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 14:02:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26FBF2399C;
        Sat,  9 Jan 2021 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610218923;
        bh=bZGRDdH7/jewq0l1yf67uZRcEHNGJNp1M5Lsry0odno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EdYMDGfwfJdhj65pzUNTTm29FAM/wC5iHVEYp/WL3bqKdf6UU7+sAmnlOMtGbwFWs
         hy4qjKeQ5TYVkh6nhIcTPJtQNkpd/90GINwWiAgrLjdX51tZYiksHeY1P84mmJ4KZ/
         usIGru9zI+WPhurdpwYfxtSHMn0Zyd6GwpUdrqZcywIxwpqTS8XZEOXd0FDepsVvMR
         6VRW+r5treommZPJ226G9vi/jgQVPwRXJXOlyt4Hc7bUTpdYnEkg8ghfAX/qkapJNx
         tm8tA3vr+SV0s3jjtfW0OifOiidTmA/bJ983J+LTR5lUso4hM3JJbor5bOdMTxTsYS
         ArD66vRrRjqlA==
Date:   Sat, 9 Jan 2021 11:02:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, schoen@loyalty.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/11] selftests: Updates to allow single instance of
 nettest for client and server
Message-ID: <20210109110202.13d04aeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <036b819f-57ad-972e-6728-b1ef87a31efe@gmail.com>
References: <20210109185358.34616-1-dsahern@kernel.org>
        <036b819f-57ad-972e-6728-b1ef87a31efe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Jan 2021 11:55:39 -0700 David Ahern wrote:
> On 1/9/21 11:53 AM, David Ahern wrote:
> > Update nettest to handle namespace change internally to allow a
> > single instance to run both client and server modes. Device validation
> > needs to be moved after the namespace change and a few run time
> > options need to be split to allow values for client and server.
> 
> Ugh, I forgot to add net-next to the subject line. Let me know if I
> should re-send.

We should be fine, the build bot will default to net-next if there are
not Fixes tag, and you just told us you're targeting net-next so all
clear.
