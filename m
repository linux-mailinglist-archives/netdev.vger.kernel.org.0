Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834EC22B37E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgGWQ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbgGWQ3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 12:29:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B28D7206D8;
        Thu, 23 Jul 2020 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595521779;
        bh=RUQDCU/r4+nb/UBP4ayzcebZRr2bgQyVMEfS5BBIuP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2G61JMGdG5JFN14HeDSYa597AxtJGxgzefRnKgk8UJCST+CHG8U9QLha9mKUFOiC6
         aXyyDhpcyB/Zo/R72mGkSGgk5H1ow3geZ7K9DFfBQbXVMXgj0uGLGkkvsYsGwxPSdW
         xFb5/Zp2kXVZtD5C/AO6/hnFlcZXRfuk6YCavM1M=
Date:   Thu, 23 Jul 2020 09:29:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v2 bpf-next 6/9] bpf: tcp: Allow bpf prog to write and
 parse TCP header option
Message-ID: <20200723092936.615fdae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200723010412.1908242-1-kafai@fb.com>
References: <20200723010334.1905574-1-kafai@fb.com>
        <20200723010412.1908242-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 18:04:12 -0700 Martin KaFai Lau wrote:
> @@ -3345,6 +3489,7 @@ int tcp_send_synack(struct sock *sk)
>   */
>  struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
>  				struct request_sock *req,
> +				struct sk_buff *syn_skb,
>  				struct tcp_fastopen_cookie *foc,
>  				enum tcp_synack_type synack_type)
>  {

Kdoc missing for this one.

While at it would you mind putting an @ before the other ones?
