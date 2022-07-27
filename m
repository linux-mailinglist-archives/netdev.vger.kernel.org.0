Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C49581CFD
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 03:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbiG0BRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 21:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiG0BRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 21:17:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88132A261;
        Tue, 26 Jul 2022 18:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85F5D616D4;
        Wed, 27 Jul 2022 01:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95DAC433D7;
        Wed, 27 Jul 2022 01:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658884653;
        bh=yHdFI7UZExa1GxsmSAJPPFlPx1kKFocZoTBH3mG9NMo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mdshVMdvfzhti6LRuDN6H7FqRhIPEHgJQTuekQbRk/mzcXXE8ynF8tli3utiZLp5O
         QxJiEvHmZWAdKm0SYEtppBgNd1fXBwwgNxA1xN/58n6z/5G0fZLq1uX8wd9Gu+Ny9s
         3BZFdmz9bgUxy7tc8D9OXGQTNnxX+AolldBOTMuoHbo/jeOpa7QOB7GpQQczyvNU5w
         Mb6G9CKihsYC/NAcfU+R9sFAv01z9O5gFdLey2i/K+Dz7mddR0bFAiv8OXIQMYhtc1
         +saf5fv4mak89IDZ4Wam0A9XfwnyABJR6qN7sfsaT3/bqbqGI+zbkKoRM2ZPP2tLqf
         rmhz8+MSk3NtQ==
Message-ID: <40928cfc-150c-8714-bb83-21d325ce93e5@kernel.org>
Date:   Tue, 26 Jul 2022 19:17:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v6 02/26] tcp: authopt: Remove more unused noops
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1658815925.git.cdleonard@gmail.com>
 <2e9007e2f536ef2b8e3dfdaa1dd44dcc6bfc125f.1658815925.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <2e9007e2f536ef2b8e3dfdaa1dd44dcc6bfc125f.1658815925.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/22 12:15 AM, Leonard Crestez wrote:
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  include/net/tcp_authopt.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
> index adf325c260d5..bc2cff82830d 100644
> --- a/include/net/tcp_authopt.h
> +++ b/include/net/tcp_authopt.h
> @@ -60,14 +60,10 @@ DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
>  void tcp_authopt_clear(struct sock *sk);
>  int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
>  int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
>  int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
>  #else
> -static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
> -{
> -	return -ENOPROTOOPT;
> -}
>  static inline void tcp_authopt_clear(struct sock *sk)
>  {
>  }
>  #endif
>  
added in the previous patch, so this one should be folded into patch 1
