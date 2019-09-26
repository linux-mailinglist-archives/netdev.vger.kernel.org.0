Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671CFBF940
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfIZSfr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 14:35:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41625 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbfIZSfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 14:35:47 -0400
Received: from [206.169.234.110] (helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iDYcD-0001J1-1X; Thu, 26 Sep 2019 18:35:45 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 5E38C2400D8; Thu, 26 Sep 2019 11:35:43 -0700 (PDT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 5826A289C51;
        Thu, 26 Sep 2019 11:35:43 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Madhavi Joshi <madhavi@arrcus.com>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lalit-arrcus <notifications@github.com>
Subject: Re: Question on LACP Bypass feature
In-reply-to: <6390BF88-7D04-41CC-8D57-844FC6A742FE@arrcus.com>
References: <EC009050-F472-4D97-AC9B-F60BE5876176@arrcus.com> <6390BF88-7D04-41CC-8D57-844FC6A742FE@arrcus.com>
Comments: In-reply-to Madhavi Joshi <madhavi@arrcus.com>
   message dated "Thu, 26 Sep 2019 17:32:45 -0000."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date:   Thu, 26 Sep 2019 11:35:43 -0700
Message-ID: <21633.1569522943@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Madhavi Joshi <madhavi@arrcus.com> wrote:

>  We have a question regarding LACP Bypass feature . It appears that by default, this feature is enabled in the kernel (we are on 4.1.1274 version kernel). 
>Having said that, we do not see any sysctl or directory on the lines of /sys/class/net/<bond>/bonding/lacp_bypass.
> 
>Really appreciate your help with this.

	I do not recall having ever heard of a "lacp_bypass" feature in
bonding, and do not see it as present in the kernel sources I have
handy.  I presume this is a feature added by a third party, but I don't
know who, or what it does.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
