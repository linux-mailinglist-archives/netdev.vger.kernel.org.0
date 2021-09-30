Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDAB41D9DD
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350884AbhI3Mei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:34:38 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:35446 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350339AbhI3Meh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 08:34:37 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 501A3200F835;
        Thu, 30 Sep 2021 14:32:53 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 501A3200F835
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633005173;
        bh=wNc6MhCgQT6+EqY92JYgvfGgPHgidwJi32cnGqcd9HI=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=N3vrexeNY264EgqbY8KMwsblKRt71kMV+eLAUjrRftCycJ984o+orj6AorvCLePaO
         5+Ek9X4bWnmGzKtn6mif0T60NaDiO30OZir1f4/1NSgpIlVrJ2X9SdKWjuB8iRpzmw
         qj/MGYylP2qQQE+QR+iOGUtARC0deIsoy6XUH8GAVKtPU5AD2FPxnGN82g+dwffaK0
         sT4OdyQWwcECO4yCxE+ZU8QVsAGEfMsVd3C/0a+uf9QpQPhwRT2/CiBtTgHcrf9O//
         fPyu08MWT/s+85TJmu/bbwiB85S1pmPiYWRRybbV6R7H6jCRpBbgUZ8Qqjm00EpI/H
         m8vz5fC2YciIA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 3727160125E23;
        Thu, 30 Sep 2021 14:32:53 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QTvtN9ep6FvO; Thu, 30 Sep 2021 14:32:53 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 15B4760225413;
        Thu, 30 Sep 2021 14:32:53 +0200 (CEST)
Date:   Thu, 30 Sep 2021 14:32:53 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <495911022.108075672.1633005173034.JavaMail.zimbra@uliege.be>
In-Reply-To: <590592ba-0e79-b649-e03b-6b735a575fc3@gmail.com>
References: <20210928190328.24097-1-justin.iurman@uliege.be> <590592ba-0e79-b649-e03b-6b735a575fc3@gmail.com>
Subject: Re: [PATCH net-next 0/2] Support for the ip6ip6 encapsulation of
 IOAM
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4026)
Thread-Topic: Support for the ip6ip6 encapsulation of IOAM
Thread-Index: eBCPx8cYyrfejaRL3yoLEIyHbhLOgA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> With current iproute2 implementation, it is configured this way:
>> 
>> $ ip -6 r [...] encap ioam6 trace prealloc type 0x800000 ns 1 size 12 [...]
>> 
>> Now, an encap mode must be specified:
>> 
>> (inline mode)
>> $ [...] encap ioam6 mode inline trace prealloc [...]
> 
> I take this to mean you want to change the CLI for ioam6? If so, that
> does not happen once an iproute2 version has shipped with some previous
> command line; it needs to be backwards compatible.

Sure. The inline mode would be the default one when using the old syntax (i.e., without specifying a mode).
