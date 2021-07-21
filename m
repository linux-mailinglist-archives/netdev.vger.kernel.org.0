Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9713C3D1601
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbhGURfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:35:02 -0400
Received: from sonic309-27.consmr.mail.ne1.yahoo.com ([66.163.184.153]:34812
        "EHLO sonic309-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237382AbhGURex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 13:34:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626891327; bh=z/xxpg8EbUmWXtmWD5hTeLFg+erI4akH+xhekw4NvpI=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=hrR4tkOkhMgUwJB2i7fw/ScepwUI0TzVZREYUAAhs2xsAAXoxZu3KxwBB0xquXD/WUB6M/RwCWS6eThSr3jdsnf5zGHt93ZvnxHI3bqCfj63vAHPamEx+D1Mz2zrpuP45r0u8tmPYYTIcaedtT9aH6ViPzK5efWeQF7PRF8VBZbiQszw04xod3wrrY4efwnTZtmPjk49NOt/VcBHrZOO8kv2jxJ7cr5UWQSOQTvvvxo1VsJaqxDQKoWlouKCTFaaj7wixKH6sicPyOW18t0dpWqLDkOzTHKt/7712j0yJ39gdoDArZ6B8u57yYtBcIXC/mS7UCdLwGH3V3spE+FgfA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626891327; bh=yjnuXbuW80Sua3ucKVaVU6+Oyh+dLCnQFFA9/szvV4R=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=sko9fqN6w43DJFazMkinDJZEjTqGn2I2NctJydsgnTSFur0PGe80vEvNOrsG4KDKMqE5E28P9f6kfkQasL4pTjhw36gyrzS025RxxI4w2vYbCCYJYAoKVJy660Z1r9/KW62ZV3ChOffJ5fqJBsNSj8G6PqJI52W1IRarOI3/UiwrDz/dasFsc/7lrH0sXwDYJOdChms+CEuf4M1Q8K7Wh7iCZRTpJaEAnofdi5NIXLWt/9iIWGn67If67vGrsQQjd53YwoGo0ps93lewRFKvbDQxvlG7XgWT57+3oH+w0NPkUL6ODu1LbwdBW8zHXLdgLz/c4hGwTkmtjNdFMVnzVQ==
X-YMail-OSG: e23Kp5wVM1lBXY4VW1Pkyl.WhgUs9QjnEYnFvplrn51ue4jMiMcQCwUidm3RQL8
 4TUBPNMFCwUqtqHmCdDaXFIPR7O66b6OusmI.9iylGpSFRNwWqKwocvTGXxhvQEKW9FVQH9b6BXx
 QTmZPdX56Tm7C8iCTwwrp7xCN_HCbyRQJm4uDLuoDki4SAKQLdAPUuC9qhXXOmkrs7oWpiJQCPxe
 nhbjmn9PeV7LDuc1Tm_997J.PmMvwRoNc1cLhRdkREc0rjKf37fDO1NOKdhYiNOkDmrn2UjE1gmb
 ..ERH3N0XCgPiy5LyzhLwxohx1EVgFD6qngpDmgkCMCsddoAraHD1x0NDgIDc6na4_H10FHbCuL8
 FadCEvvq4xkxmDEs0Rap17oM.2iYHUsEBna_Zo3XS5At9vT30GrIjei_VwceZdi_kzAWhMmZlsEZ
 pk7U6thcFmQWsECwzfNFxR8dG0un0cy3fiedJof4sgzIVft.4AkViiC5vslG8rwVchgV2CGzkm7C
 CxcPUT_K.6gvujx1bA..cBRdeWtezfd.n3bDzumSHk8BR083.RsUW7pgIef9a2hhcHB277rW5T78
 s7AtAhaIanNJDjgV8.GYqiBJdZuBJJt2Cr9K9qWwgGdGTFoRVu0bYHCQIOv9TbJaY96HTbMFZTLC
 b1yOZUK30qbaE7I24qLs89PkjuWCfRuaZb2GynRqwCkRW9zico21SqOOWrRlpro7Zfp.6xV.qjzo
 hLsP.OZpC7d_DPssBrw95agbJal5s_7c26QuCjMM1IxwdA0mwGMlyBhxqd4NhlsV7HkstLDsVCEG
 nW7dIE86lVyvXvLMcCrXgJqKBPuzpDdN97gCQfdp3BchO4Y60D1BsdWnRjKGqhfKrlS66pN.LPy2
 p50HBTR5rDIKG0oXP_hGC6vE9WkQQ.5TMpP9a0KHURseoOUtcH9wgXRkAvxEJJTFSAXnHFA4z0xb
 I7jjQaSHqca7.xK9QnSDnbq3H0Q6OVxxOkaAFoLCvAYSDBsaWkdip3pJo4XTSNJEe_YyYDWiisdG
 Z7EbxlW7qlF.U2zikaDJ5N.SNXzBBhFJOGzN6qw02EHv4BxiMSwwkqxyjMSXW1vFoAGjl6QgL9Ha
 G0hHKj.64K6IsxYq4fCzPtk1JOjbzfagC3C.A.blaq6s8IVHhzCuMtSxhIz7_pMuTD_4y.vZqLgk
 QAQ2hvaf7yN59gPgRfeN5rnDej8RlSenUAhdzdGWiyW6JTN_XvFfFN9j9jIB3LbrmEafqW9PNaEQ
 oy05HLjwLAgd9r1CYFtRWscKMNpS7BpH5wpxsOg3L2zYAR_ZSWfWdLr9OhskYYneEaC6Nq4aIB6B
 HuBlOPJq5z33ldKU_ZEvsEz7zUTjHHV0PbOES5MBs3YELdJcP.8T5kq6A6XZ.gAhDf.YwEouzWH_
 ftxPqWGHRu0mYywMu0x6mGu3hvkuIp4pZl1YayKbjbDJyY8m.VM735a_Pq0QBnGXVwDfkLRDviec
 UrdykTLwhTNrJm3h3ezhbWMGB0KYae8zc7okQoG4gBTmBH0kgScVPqt9KjHKvkR0xq8JnpD1kj9x
 vEf8T0HgLFEset1fS3840_l7XERkoDB.jOFU5kLIW2hhwNglG08YZijNEX0X82lc6APUD8T6HoM5
 JbwpNpxUBzmpaIV2JzzsD5TAUq4eQLdb6wOYJ3mrGZKVE7ZTj9FoKXpxCLH4tqUi9kCizkpi5dRd
 dYajOiwM9VUUIvRX6esFHa6j2Vpr9qwSaWJU31xNAvLoGSQP1gJ9ivANUWg.DUk96hZVoeBhmTen
 z1Hy3GahO3hyhKsVBNzq6r03WNy_4.W560_iHvEoNyc3rcxG7HdOfGnFD2._WTYOv8wQ.sQOSKNn
 RaGM0nPXNPw294qUNZ0v.jDuGg_aP31ggi0VS1q4Hp5zeNw2SIFRkQycj3HWuVkR78BSSdGYem0L
 aYh_jhH5qlAvO7_Rit3MhuPbtOofbhx7.QudZCm1ycFrcttjqDJTgo8W7ZOPUIgU1day3kv0K7RJ
 CEtSSw4M.ea.hOvEZKz7mvmZ1rz5qYf.ItvvX_G5.3yo_._02lNEIpz4BP6MHkW_PSyJZ9G6zU8l
 QHKENiAhuk968LN96.RTa2ZRV3Z89tfU3obL4Z2iYXztqmAhjydC1lzI.5brgp5vmG0D3c4hDQCJ
 hwtbKHOHohGxHy7YkMEmctH6ZumUZZRPCHI.ytlYLwEbS5JuiBZxLanN8vEn3tgRT3jFZJQ2hVNA
 mHgTGyZV0FMz5XLKeMSViJA.h8FVMPoZaHyMg1OmUbfqsmc8OQeSRl8.1Zzu3VAEWpe.BtGGVeGy
 nigT_HvbBqGFviPr99bJiGmR4jDbqjVPPF8ZuEMGSjJ2vOqnajwfNTrZs3WjwCNImBPynIhSjkHQ
 9UTOUueaKpFg3MUL6TiUQhlkDFFnWhJJNJWa2E8NwnMSa6cXhQrNQrU.WahdPkl61.3eAhJNteUT
 FBsWGTMcCNDX_0ooi4AxvgiglyYibUIiC6oCBmosQaet0fp2l3CvLUBwemsX.9gAEFT.ibnauJKd
 9Kdin4rPpIdBAWyTHWYY.A5yzgGvefdJt42PohukT1Akw3ptjuQXZ2Wo5rBFrau0CP216x_TguDw
 Z8rQPjIBfFGWz77VZhQLJ0QJiJyGIh_gl7loYcmkyIZSsoYuau4Um91LM8p44ZHCSOhCD3aFn8T2
 8Q743Zqe9JQEkPaN8RIznhwl6AyQJY1uJnBcqV7De3h6VhmsnXNwcUQ10jRGXZADW1gJfFEPwLDL
 _Hv9w69H.yzXIOLW5SL_5v6rmCVt6RQyA.0Sr.c4pcDCEC40xoELA9JzSRGw0CfynXBOhPzrrYBo
 shluBigSzpgRDanfE7wAcgcYX__M9uctVopzMtkTMuLYykzkOQbdX2wxOLkfMWTACMjutVUXe.Rn
 k_A21KoNK4PnM6g9AkK4DtnkZIG1V2X5o3QuEbOyxskyjPZ.jPcAVvtA2qHCTW7AxRZNBLAYxaEi
 aVFfJ430qFDeO140GGFA2WZUUWA5ThO8f5QBysJSMLCA3fihVGFGp
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Wed, 21 Jul 2021 18:15:18 +0000
Received: by kubenode540.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 2b3d54d16852bcc9a77bb6e694199967;
          Wed, 21 Jul 2021 18:15:06 +0000 (UTC)
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <cover.1626879395.git.pabeni@redhat.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
Date:   Wed, 21 Jul 2021 11:15:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <cover.1626879395.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18469 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/2021 9:44 AM, Paolo Abeni wrote:
> This is a very early draft - in a different world would be
> replaced by hallway discussion at in-person conference - aimed at
> outlining some ideas and collect feedback on the overall outlook.
> There are still bugs to be fixed, more test and benchmark need, etc.
>
> There are 3 main goals:
> - [try to] avoid the overhead for uncommon conditions at GRO time
>   (patches 1-4)
> - enable backpressure for the veth GRO path (patches 5-6)
> - reduce the number of cacheline used by the sk_buff lifecycle
>   from 4 to 3, at least in some common scenarios (patches 1,7-9).
>   The idea here is avoid the initialization of some fields and
>   control their validity with a bitmask, as presented by at least
>   Florian and Jesper in the past.

If I understand correctly, you're creating an optimized case
which excludes ct, secmark, vlan and UDP tunnel. Is this correct,
and if so, why those particular fields? What impact will this have
in the non-optimal (with any of the excluded fields) case?

>
> The above requires a bit of code churn in some places and, yes,
> a few new bits in the sk_buff struct (using some existing holes)
>
> Paolo Abeni (9):
>   sk_buff: track nfct status in newly added skb->_state
>   sk_buff: track dst status in skb->_state
>   sk_buff: move the active_extensions into the state bitfield
>   net: optimize GRO for the common case.
>   skbuff: introduce has_sk state bit.
>   veth: use skb_prepare_for_gro()
>   sk_buff: move inner header fields after tail
>   sk_buff: move vlan field after tail.
>   sk_buff: access secmark via getter/setter
>
>  drivers/net/veth.c               |   2 +-
>  include/linux/skbuff.h           | 117 ++++++++++++++++++++++---------=

>  include/net/dst.h                |   3 +
>  include/net/sock.h               |   9 +++
>  net/core/dev.c                   |  31 +++++---
>  net/core/skbuff.c                |  40 +++++++----
>  net/netfilter/nfnetlink_queue.c  |   6 +-
>  net/netfilter/nft_meta.c         |   6 +-
>  net/netfilter/xt_CONNSECMARK.c   |   8 +--
>  net/netfilter/xt_SECMARK.c       |   2 +-
>  security/apparmor/lsm.c          |  15 ++--
>  security/selinux/hooks.c         |  10 +--
>  security/smack/smack_lsm.c       |   4 +-
>  security/smack/smack_netfilter.c |   4 +-
>  14 files changed, 175 insertions(+), 82 deletions(-)
>

