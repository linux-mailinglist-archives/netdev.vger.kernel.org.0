Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4DC1F64AA
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 11:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgFKJYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 05:24:20 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:43440 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgFKJYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 05:24:20 -0400
Received: from [IPv6:2a01:8b81:5407:2500:1db0:89c8:8124:d9bd] (unknown [IPv6:2a01:8b81:5407:2500:1db0:89c8:8124:d9bd])
        by mail.strongswan.org (Postfix) with ESMTPSA id 939A340063;
        Thu, 11 Jun 2020 11:24:17 +0200 (CEST)
Subject: Re: [PATCHv2 ipsec] xfrm: fix a warning in xfrm_policy_insert_list
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Yuehaibing <yuehaibing@huawei.com>,
        Andreas Steffen <andreas.steffen@strongswan.org>
References: <7478dd2a6b6de5027ca96eaa93adae127e6c5894.1590386017.git.lucien.xin@gmail.com>
 <70458451-6ece-5222-c46f-87c708eee81e@strongswan.org>
 <CADvbK_cw0yeTdVuNfbc8MJ6+9+1RgnW7XGw1AgQQM7ybnbdaDQ@mail.gmail.com>
 <b93d9e68-c2da-bb1c-e1f9-21c81f740242@strongswan.org>
 <CADvbK_egkEe0Pw-Yy8eQggS-cfvndOnj7W2hqvpdNxS2xJ50xg@mail.gmail.com>
 <CADvbK_faty7VayrEfgJ-Hcr2Ah-2au6uFvq1hU0ofdNZHODNHA@mail.gmail.com>
From:   Tobias Brunner <tobias@strongswan.org>
Autocrypt: addr=tobias@strongswan.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <162dc8e7-fa96-97a1-fb4a-e3bc03ae89cf@strongswan.org>
Date:   Thu, 11 Jun 2020 11:24:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_faty7VayrEfgJ-Hcr2Ah-2au6uFvq1hU0ofdNZHODNHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

> For 'new/update/del', we should do an exact match with
> "mark.v == pol->mark.v && mark.m == pol->mark.m", as these are MSGs to
> manage the policies, every policy should be able to be matched.

Agreed, using an exact match for mark/mask would probably make the most
sense here.

> But for 'get', I'm not sure, shouldn't it be working as how it's used
> in skb rx/tx path, like in xfrm_policy_match()?
> (similar to 'ip route get')
> But maybe for ipsec userland it may be different, what do you think?

Interesting idea.  But I don't think it currently has the same semantics
as RTM_GETROUTE, i.e. you don't pass it e.g. some IP addresses and get
the "best" matching policy back.  We use it to query stats (curlft) of a
specific policy.  Basically, we expect to get back the policy added with
XFRM_MSG_NEWPOLICY or updated with XFRM_MSG_UPDPOLICY when we pass the
same selector/mark.  So I think it should work the same way as the
manipulation operations (i.e. it can continue to share the code path
with delete).

Regards,
Tobias
