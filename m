Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FDD421AF6
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhJEAGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:06:16 -0400
Received: from sonic307-16.consmr.mail.ne1.yahoo.com ([66.163.190.39]:45567
        "EHLO sonic307-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229486AbhJEAGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 20:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633392266; bh=FOJNnrVRmS9H1W4ti+/QExbHkJVUyiJ1JahleLUS3qI=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=uFu6C0Pi/Q0P9MjIjQwrJtDdAqo0guC6ZXM0RLCKqb/rylvV2KmXC5Xh86rSNQ7lWQ2eqZxftFkyoYM9cbTczuFPUBYdWl3UMY2GBtUgoFB8OVDEMs3GkTG/xV9SNt+OmzEwHzX4IM3s6GMXi5WmmOxNgXY7FGrU/YdzfnC9D45WR/oY+n92Z3nUPMGxZslqEXmn/F2MGPlP+GomTgp9URFssOzcwJbCVJJpdPKqtxecA6e6IDDnc6+EctzuNGNvrIFx9ZUQzE1NYgUogca2VfWogQljaV0WDVNUpOCVz8+G7/ImcLqpTJ9G5+iykS2yCbXnuLZ/aeWYevSih0SFFw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1633392266; bh=MUPmB1tB9k0D5WFzpTpez38Dzj2vbD/As9iIEHPtUMP=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=KTePSG4tIl/dfvRNa6u5gmE1nqtePG1BOmJzgb1NzfBhWoHsU7r5G0rnyoEi1RFu76sLEmE/SXnxoEbqjqizamksu4BVj7xVfGVWkyq/mP7zfF4bCeEtus+Pr49DTpoid74i01mtgKngP/MJWD751M+dzo1aT4WD4O1gLHciXwiTmgQWFGiik/Djt76axxYa+r9WvRgr6YK35I7/7U2Ja6ygh3epCTW6x7xpNGqBoRdYS2qPLmlzQYUwp89rFt1wnzUUlTNGwl0ltuc2Q6K0KdSfCtF+wapHw5WQF9aDipbrkaVLTTTM34yVPPud7pT3bFfdO/DXVpF3ZWiT6Qd3Zw==
X-YMail-OSG: gPMMkM0VM1kN7Gf97CtVvwitFIjCYfPFVmfttsucLry0Nb6hxFshE0O7jQeEAtY
 YaTQeNJuorxXLBH6fjuI3mDok78J4vfUNqsaSsXwSPh6658grmz3YAttH4D45vYQxuww4hjq0qpg
 aNQ1o4WZlZ7AT_0yPJJoFjCiIHb14gJ03JNyt.H5UVNVmH1ULXcnM89rWypN5wm.DEX9LpKVk8oR
 liC7hXWAu87z0Pyrg1cFABxXkmbvv65w3_GOtAj94bHUsWj3EWeZ81VUBTOhTiEqM2PlY_5PNC3S
 HWppvdO20NLEzBBLMj8JNXlo_SR6B.W5XexrJDPC2SP8jeTjk6BfVTPmrWEWP8OfcOh8ejzwobd1
 okzeh1byFkwGH5jNcTMNPUvoYb2geGh75QshRUqumwjidmYhuyVnOdb9T95kcb2jrM6piACU3GVc
 HqCMwerm2QXjHH6WYFvzvCliZqZskCdWfcZpkuesKRQl78P9Evk_RVc1yPnaQlv0awx2CF6YxITn
 0oHUtRD0zfwSAE2RkEgxGbCFYZ0AQbZINLrcCAZAGUNzex.4jFcWdFGkQ8_ov8YnxqotJmjhOuPd
 8Bfv4Azn1.1OyW30ise7uJCFzVtTxq2Vvz5CRGn9GZOz9zbf110TkMuEf8_qrpxSoBFPvAalmGvt
 dLaAPYBrCBYMr6ERvv0_mqFAB29iiJIpV8z2qeVcgQvEyiWLNV4g9lA4P99mxyUKw8dzcXWBnzjD
 8CUpnyGt4wDD1u2RUS5tRYF8vF2NlMVyL5aBvgP0aTmJTbXmV5mwhEBRT8mpOcbSut30UcpfMpUA
 XwdtWa7mUz5ystjdqjk6vdGMlpwryi9RqGMJfbGm2Hg_4TBrFUpeaiXthS9SbK6CeT1Iv54TxILl
 G5Qx4e1Hly0p0LapFHVlaaHRygtRWwt9ZB.DoeZY47Wa85OV.sRtkGI7ztr9GMSUmdsdmKwTGloF
 BLIniIBzbQhINRJwvw7o5Cm3muULPuJTau3IENq1zEttPzdHlqGhJMK8HV3IOHP3LHi796QB5OY5
 2bt27QfkkINJ0379EFI5CMpqJ.tH.vgpWnxyzounHrbwZD.OCVR4I3rtQjXW56or4MmB57FlaYmX
 GO8beiTa4nLQvSbf7Ck6nAYCbysGn7Xv.OTP8W40ROd.xfHmTAPaVyutVnXeuVVnupI4WHigAFIX
 rXThOh7SbBMDpPEIKM85a9egvpyF9ClS9eb1SrQYaVD8QanSg8O5E.5oftVFwQH3oixdTZzu1Equ
 4CxZZDm_lERaJoACRCJfg1rjrGNrn7Ll8z_CIVedpj9clNGfhKqh1RjKo5Z9vsGvFCg9VSYrZAyJ
 xCDvYsj_iAMQQ_fRmZxDGWYRLhNOjHeZHNuBOYA5NtzKirrz_HDIevjyoVs1HwO2cnmR4zZt.wpu
 qAGAEr1YCbot0xyrJNrVm1jB9KZv9bu6pzzMsSDlEOwoGkkq9bc2m0f4I8c1jixwREKvaqQPFKxG
 8EVjuEueBwlmHUVga5hNL4PtU7V1RCWoB5_JnX7Uf1hAnHVOiH3OAPYMpVG2VFtywBw48hDBqKHC
 M8sWY3nvgloISWK7CRlNZOodkFxXxBZo4BoevHA4YXH6G9CbI_9uHlyvk.ZICFEJVb36HQAE5lBt
 W2w_K4qx5X8_JNwIYS2jpBLsPS75ofI_sQGvzUKU13m9GY6JGmq4I_y4whKQ29welDQJORBlvOeh
 4WhdSBoQr7lRq6Mj.0ta_QmrFdZ1Sfw5QBruOGk2P3XZ6UhPkPDDO4H1ZEU0IuCP3_Z47Mt8JfyA
 swHSske7OTjrDpAYPb0vFLyuAgCK1iRdOTv3Qi4Axh2cf23rE.Diulqll6TXupo1uBWBEKsEkECX
 dhInYfKGCcYv9NgcVD.WT9mpnWdJG6etYIo9t7I7yNjphFRKsOLLOlyYAOFFBpL6oNfTv0Uc.Fxw
 49THilMHqLMrAuFi79Z28zH7qo.JtNdaLUbRQqqPro1GMm82zeO_ALgTMHxJzQ1e9CMv6FacFnnK
 .265OKaELAwwTIyNLXiWYwo1lDeOpYfCm1Am.jkLCJht1hc_O0DW6dPui8evawWYo.aNp9JBqWlx
 03KciHfWekpWjNbzyKKW_OU0kDQuv3n_tJGSiAjYmipvmuOiBK7SWa1EIGaYoRn5iysrlBUQF61f
 QsrDHyqW.x9UZNu97Ow0XmA1tj7OceOX3DtkeSGfMVAYKIoQqYLtL6DekxoY_mbVFlCJphaeBEMT
 YGjEqsAmGp1yeipW.CUA4DtDM971aaWUQl8gYyACvOJLLnoXYM.b_s0F99qxF188dvsj13MofMb_
 UYULOCEt.I583RGqechaceX3517nbzTWf7Z.GqRie
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Tue, 5 Oct 2021 00:04:26 +0000
Received: by kubenode524.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 9da3deb579f6e0ea44bca64c61db2f77;
          Tue, 05 Oct 2021 00:04:24 +0000 (UTC)
Subject: Re: [PATCH bpf v1] unix: fix an issue in unix_shutdown causing the
 other end read/write failures
To:     Jiang Wang <jiang.wang@bytedance.com>, bpf@vger.kernel.org
Cc:     cong.wang@bytedance.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20211004232530.2377085-1-jiang.wang@bytedance.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <f7338e3e-8798-478f-bac9-a86e247e3a13@schaufler-ca.com>
Date:   Mon, 4 Oct 2021 17:04:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004232530.2377085-1-jiang.wang@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.19076 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/2021 4:25 PM, Jiang Wang wrote:
> Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> sets unix domain socket peer state to TCP_CLOSE
> in unix_shutdown. This could happen when the local end is shutdown
> but the other end is not. Then the other end will get read or write
> failures which is not expected.
>
> Fix the issue by setting the local state to shutdown.
>
> Fixes: 94531cfcbe79 (af_unix: Add unix_stream_proto for sockmap)
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Reported-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>

This patch looks like it has fixed the problem. My test cases
are now getting expected results consistently. Please add any
or all of:

Tested-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  net/unix/af_unix.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index efac5989edb5..0878ab86597b 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2882,6 +2882,9 @@ static int unix_shutdown(struct socket *sock, int mode)
>  
>  	unix_state_lock(sk);
>  	sk->sk_shutdown |= mode;
> +	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
> +	    mode == SHUTDOWN_MASK)
> +		sk->sk_state = TCP_CLOSE;
>  	other = unix_peer(sk);
>  	if (other)
>  		sock_hold(other);
> @@ -2904,12 +2907,10 @@ static int unix_shutdown(struct socket *sock, int mode)
>  		other->sk_shutdown |= peer_mode;
>  		unix_state_unlock(other);
>  		other->sk_state_change(other);
> -		if (peer_mode == SHUTDOWN_MASK) {
> +		if (peer_mode == SHUTDOWN_MASK)
>  			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_HUP);
> -			other->sk_state = TCP_CLOSE;
> -		} else if (peer_mode & RCV_SHUTDOWN) {
> +		else if (peer_mode & RCV_SHUTDOWN)
>  			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_IN);
> -		}
>  	}
>  	if (other)
>  		sock_put(other);
