Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5E378366
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 04:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfG2Co2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 22:44:28 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:50902 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfG2Co2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 22:44:28 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E2683417FF;
        Mon, 29 Jul 2019 10:44:20 +0800 (CST)
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
 <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
 <20190728131653.6af72a87@cakuba.netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
Date:   Mon, 29 Jul 2019 10:43:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190728131653.6af72a87@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEtMS0tLS09KS0tDWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PC46Lxw6LjgrKkoYGUw5IlZI
        DAhPFENVSlVKTk1PSE1DSU1KT05CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUpJSDcG
X-HM-Tid: 0a6c3b9d50d82086kuqye2683417ff
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/29/2019 4:16 AM, Jakub Kicinski wrote:
> .
> The TC default block is there because the indirect registration may
> happen _after_ the block is installed and populated.  It's the device
> driver that usually does the indirect registration, the tunnel device
> and its rules may already be set when device driver is loaded or
> reloaded.
Yes, I know this scenario.
> I don't know the nft code, but it seems unlikely it wouldn't have the
> same problem/need..

nft don't have the same problem.  The offload rule can only attached to offload base chain.

Th  offload base chain is created after the device driver loaded (the device exist).

>
