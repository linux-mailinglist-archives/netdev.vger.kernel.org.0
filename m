Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3405698F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfFZMmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:42:43 -0400
Received: from m97188.mail.qiye.163.com ([220.181.97.188]:6769 "EHLO
        m97188.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfFZMmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 08:42:43 -0400
Received: from [192.168.1.3] (unknown [180.157.109.113])
        by m97188.mail.qiye.163.com (Hmail) with ESMTPA id F35C496443D;
        Wed, 26 Jun 2019 20:42:38 +0800 (CST)
Subject: Re: [PATCH nf-next v2 2/2] netfilter: nft_meta: Add NFT_META_BRI_VLAN
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
 <1560993460-25569-2-git-send-email-wenxu@ucloud.cn>
 <20190626102935.ztxcfb3kysvohzi3@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b037a0a9-4729-41ff-81bb-ca76c0e3fba9@ucloud.cn>
Date:   Wed, 26 Jun 2019 20:42:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190626102935.ztxcfb3kysvohzi3@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVklVSU9IS0tLSU1DQkhNSk1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pww6Hww*TDg3HBQxDT0XNgo2
        Pj4aCzNVSlVKTk1KTk5JQk1LSkNMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSktCVUpKSFlXWQgBWUFJSklINwY+
X-HM-Tid: 0a6b93cf39ea20bckuqyf35c496443d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I agree with you, It's a more generic way to set the vlan tag not base on

any bridge. I will resubmit NFT_META_BRI_VLAN_PROTO and

NFT_META_VLAN patches

在 2019/6/26 18:29, Pablo Neira Ayuso 写道:
> Could you add a NFT_META_BRI_VLAN_PROTO? Similar to patch 1/2, to
> retrieve p->br->vlan_proto.
>
> Then, add a generic way to set the vlan metadata. I'm attaching an
> incomplete patch, so there is something like:
>
>         meta vlan set 0x88a8:20
>
> to set q-in-q.
>
> we could also add a shortcut for simple vlan case (no q-in-q), ie.
> assuming protocol is 0x8100:
>
>         meta vlan set 20
>
> Does this make sense to you?
>
> And we have a way to set the meta vlan information from ingress to
> then, which is something I also need here.
>
> Thanks.
