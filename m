Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCB11180FC
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfLJHAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:00:31 -0500
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:55982
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727004AbfLJHAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:00:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575961230;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=kt/xi0W+smcW+NKMl/uIfEDHjQ5qJ7tc0aSAoL05k/c=;
        b=oZL3clesDOKK62PVPXdxMoYBH2U9aYiYvBxbnC6/6tiAbc0z5YF1eY51Vodhs8XN
        1KVoxniZGfTM4KuYj5a9gtUPaoaRp/KLnyoc0CNQdXEGDYTRxuDkw+B6ezXo19Dggj5
        gv04MaepukYGGFB4fWFioZKR8kSeoYzdPZa/HN9A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575961230;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=kt/xi0W+smcW+NKMl/uIfEDHjQ5qJ7tc0aSAoL05k/c=;
        b=O29rRmA4vGIlYB0tGFIYFypIkVNoaM7lkjfF+60HleBp79dmMNdy0TN4vMPmWQgz
        B1vWbii76i1LVMkHLk+N6U4XASViDCpS3n1nsOg/uEYIGLziNH6xuqobjVcygWozNvP
        Jnev9O433T9T5T5bm7NBVhKBzu+w1CwyzJBDmrd4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 10 Dec 2019 07:00:30 +0000
From:   subashab@codeaurora.org
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
In-Reply-To: <20191209161835.7c455fc0@cakuba.netronome.com>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com>
 <20191209154216.7e19e0c0@cakuba.netronome.com>
 <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
 <20191209161835.7c455fc0@cakuba.netronome.com>
Message-ID: <0101016eee9bfacd-d60e502b-06b1-4870-87e6-c8402b096006-000000@us-west-2.amazonses.com>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.10-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Okay, that's what I was suspecting.  It'd be great if the real
> motivation for a patch was spelled out in the commit message :/
> 
> So some SoCs which run non-vanilla kernels require hacks to steal
> ports from the networking stack for use by proprietary firmware.
> 
> I don't see how merging this patch benefits the community.
> 

This is just a transparent proxy scenario though.
We block the specific ports so that there is no unrelated traffic
belonging to host proxied here incorrectly.
