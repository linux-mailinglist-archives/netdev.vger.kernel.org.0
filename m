Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEEE45780C
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 22:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhKSVTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 16:19:06 -0500
Received: from sonic304-28.consmr.mail.ne1.yahoo.com ([66.163.191.154]:40533
        "EHLO sonic304-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234766AbhKSVTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 16:19:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637356563; bh=vFJtUdvDjuctXd1U2IkO+EN/0QC8+ex4lFMDF5hvvuM=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=V4r/XpD1uud2QawIyawkM5dhY3jGitPOaLGlFPWIsXPnx+Wu6GRImD70umGpFPu+LVBBg3fUk//ULNxwGKlOvQ0cGmlmhnCZ1vQpuuSbtDcpChSB+GLcTd9PTYocGYUGFSzWq8+gwIAvfjd+QJWwWec+/KImbQhOW3Ilb0CetvFvsl/JszZJmdZi+lhfzxeuPWm3OXpLDoAZaXrw0qX94X8fo8IaOCWg5Ucq/SD1/e/l4Jt5Z/nUU3ovQ0poy/AtUW90s/q3zNkc9T8XI8vUgNGQBZoZ5bf4MBwnj5AYjLX6G90l+Pk6mvEe6XdwV+hI5TaRoW2hnOUh4yRyj6hA9g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1637356563; bh=5CzMVBtMTRZgC201e8LfM4zRbB+hj2BfNa5O1wtVV0O=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=psiG8CaUU/5ds6XrDpPaA7O+Bz5p2VVUv0N2ZnVDZDgNfi5CTXvuRa8/Bc1ypV+hF6HkR0QHsJL9Eyn34DF7Wip4pP/1L3ZOYMxspGPaYNXFBs8WLH3WXH/PIr2tBk5Chq7IyZrQ1DYgQerpfXNzovU/XtdTpBxwtmZz5qcwRU+J9oQyw3hyRdGy45QLcsJREeKzhBPOdWsJQKZh6ORbCD71B2XcDoCeQvyVBRKZX2h+DuNx+tTq8d2SrH7mIblar2cqUlHMshXyVI1rCDhzfVKNhQobtKZL0w+0u1z53HTN5uV8lHvhOhHN7L4Xeb1fRMwNn2Y4DCbUDWmE2ugkSA==
X-YMail-OSG: raU5vcEVM1ne3jwPHgF2_Pvc2DBzGZNsKaT_jdGZpeZdo34p73ueqB_exoMCaFn
 ECaCuKIBtd7e4Y.v.yZDzQW63Dvel6j61bgp3AbOOZ9TSsRLCnHFdVPSsBUkbT0EQ28fK.vZEqER
 smy8u0FBWMTVU_sYT1JX5E4kz8BZBuJpn.OXg7HTHiU.x8Roy7ieE1CJ9xXmrx.gVhcz4jo6izAy
 0POX7OJynWWF0q8kJLLq5Z6dOhiGnR6MAz9nf6FxNQtKlkqGVZlB8uAtJdmPyhakWJY173Iven60
 coUHCkXLL8tkeMreCU1962eYcSuwLR5oJpm5q0vFSTdWDc9mftfIXJnAkxxhrERYm2rVIWUZrIRU
 eza3wxv5s7ve4sSaO_a.c97gmLGl_C2ypLZsym9gkX5mY7GlaR8d.Zl4ZJKKeMe_1rKrIRKK7Ws6
 Q6LSUo6Mle24awDZObiF_NFkCpTbTUSEwSA4yQcLsKaqBCimuPx_Y5KsKRByzOEMaSShnTWEJhuB
 f7b.sH4FXyNZt30HktR1nnxD18J77tZrmCpUL4QHViyekThqmzdigsOvnF7N.zSVp1n9F9UST7I6
 OSG7Af2BLzs2a.pGW.kiFqoS_CFbi__pjgWMcdilQ.aqj7AJalC5rpgc6BjhSZkBrctMJnB2C_4y
 KpjsuHDuZS4zSRYZIlYuFG6MkEXajmcOvtB7fk23FJBaMhVUJS2MAJ8SAEGv8aUFHfB.mw.6F4wg
 UWP8GncdWENQ9Ip4we2ez2CGDdJJn6AQj3SJKAiVb1A2IUHvAui0VX_FwzKOUE8s0kPl9Kl8_RWG
 BH57zvyfjbwTo.ZGVCaFg9GPmOr02.TbUZTdp7LLwh_PBMF_lDrn.GQbaaVQ86oxnaek_Q7LVkte
 8yuZt7JnLojAOJxClToyCLNXd21ra7VIM.CZMNhCxVQ_w042xmlol7m5obdw5qIEg_lapRP2BY8m
 x3l0wydIuTLXJjaYTucio2kSW81hRy2UUp2zcRtGtpo0NF2L6EYJe2il5HuepQ8IiL5lfXnF0sFZ
 kezlH27TbjF6R1pukLbTFgEwk8OoHEcxsK8_AZAkH0S4MwRxQuilFmVMHjURp9TGZPRsJMEdrq55
 NCSDnkpuLjbbj_osVMhF3On3fukCGkYZWWQYAralD1zDSA4v3hoB.pJxgVsq3k5OYQ4jkpCrsHre
 H3Pg_MGkF0TezVHSd3euo6xlKpVWd8l3X7pog0EDRYPoZ3TB3RsxxOmLAsoal5WYZ2QYHr9H_AtQ
 RC5oXvRet1460iVw269XD5n3FJ5KSLavwCEsvML6ls1ZXtAaHd.uJkynK7s3rHn8RNvW7OFIcoTn
 f56fRunekI59LEqyE._H32zLAcwu6RliL3Ufl6V_lzopVO0cfGw67THzbJnd5UadQSZKWRTuF0iT
 upIhAqKs64SptWu4ySzb8di7lmfIf0EV7qOGZJnnlkXYlOTCmwDJVpYl5dApHiYW6VdkPLrDOMCj
 Ruqnrc1.5P0Nvh4IDy1KcD89uL1VQLJVSARj2b7aDUjOAHsjQBjhxcyvlgv3UlTHBpKlWsdkQxdi
 qfEGtmbOlnTyURcGl6Nk.WlH00SlnpJLRenLSUL4sYMzWK0b3x.UqxtkPzIURzR2scMiZh3DfVy_
 QoHOKMznTiVIpt_X8qJgLs6lDq.1mN4C09UGdbfQ7vquT8EPA7EaZnpzDZ6P.KA..qNAwam1SQRk
 _1Qzzs0o0z0mSylDHVPm1MHd6CE13w1.0nzaoXuUFJLD6O2Ebpz02yHN1u3mef2jYeCyIIkcIaiw
 WC1BGN2v69pMym0Zfvpjx8VNBWFn3vEoJZvxPjcDEKIV9atg9jnwkxp7SZCg4wDAywv6BPRJxHNy
 4snx_BUhuhU_XnncfCkS0Hy._3PFZazU5vFesutpo4PV1H7GokOIaAhOHvq6JazOCNavwZlQ1F3x
 86jPVwD41quk_s3Ie9x1n60Gd1LJvQzqCj3xOHD4.BD6NbC.ZdyVBnueZRtsK5T_85uSr5iVh7dX
 QjIwwFe5HyCKJJNS74AUpN3JvFEZTcc35B.sN.G5B1B4EX0LSDu_Z693uFPnibK4BTu9M.TCBNYg
 Hayd8T7wtA6Zs0AbRQl6uHCicfZx7csSsHEQKL_789bafRHcyQxpV.9gG_qPUOm5BFo1FYulQ1BH
 GOW6V_eNNnOqQovcNyQ9y4RCOjNTT3Mkds.Rsh2MvqvF99NpAQWzPFHbUtqzxThuT3s9Wm0taevU
 DvdnUqAds88aejLPmJItzeYLM_Bk8VbZ4H9y3yv4.iIwEtGdysTRCgFKFt1Ahp_l.gN3gXFgl9A-
 -
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Fri, 19 Nov 2021 21:16:03 +0000
Received: by kubenode502.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 66df3053efa0f9cbcd5295357ddbd602;
          Fri, 19 Nov 2021 21:15:58 +0000 (UTC)
Message-ID: <de27c745-52d5-2fba-4728-df251987315c@schaufler-ca.com>
Date:   Fri, 19 Nov 2021 13:15:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] af_unix: fix regression in read after shutdown
Content-Language: en-US
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel@axis.com, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20211119120521.18813-1-vincent.whitchurch@axis.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20211119120521.18813-1-vincent.whitchurch@axis.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.19306 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/2021 4:05 AM, Vincent Whitchurch wrote:
> On kernels before v5.15, calling read() on a unix socket after
> shutdown(SHUT_RD) or shutdown(SHUT_RDWR) would return the data
> previously written or EOF.  But now, while read() after
> shutdown(SHUT_RD) still behaves the same way, read() after
> shutdown(SHUT_RDWR) always fails with -EINVAL.
>
> This behaviour change was apparently inadvertently introduced as part of
> a bug fix for a different regression caused by the commit adding sockmap
> support to af_unix, commit 94531cfcbe79c359 ("af_unix: Add
> unix_stream_proto for sockmap").  Those commits, for unclear reasons,
> started setting the socket state to TCP_CLOSE on shutdown(SHUT_RDWR),
> while this state change had previously only been done in
> unix_release_sock().
>
> Restore the original behaviour.  The sockmap tests in
> tests/selftests/bpf continue to pass after this patch.
>
> Fixes: d0c6416bd7091647f60 ("unix: Fix an issue in unix_shutdown causing the other end read/write failures")
> Link: https://lore.kernel.org/lkml/20211111140000.GA10779@axis.com/
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>

This change passes the test case that lead to the original
problem report.

Tested-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>   net/unix/af_unix.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 78e08e82c08c..b0bfc78e421c 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2882,9 +2882,6 @@ static int unix_shutdown(struct socket *sock, int mode)
>   
>   	unix_state_lock(sk);
>   	sk->sk_shutdown |= mode;
> -	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
> -	    mode == SHUTDOWN_MASK)
> -		sk->sk_state = TCP_CLOSE;
>   	other = unix_peer(sk);
>   	if (other)
>   		sock_hold(other);
