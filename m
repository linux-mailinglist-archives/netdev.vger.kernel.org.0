Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25213130CBA
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 05:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgAFEUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 23:20:51 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45216 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgAFEUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 23:20:51 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so47249297ioi.12
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 20:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zvFCsFEF+c6WSnVQCIY8n6qtZvunSUGwBvD0oW+rG8I=;
        b=Uc4JnP+m1o4IN9Z9dYjmAjB4qf04Ey6nRhffb0b38moSTScBncNo2B0ZJuukiDd+oQ
         Y0zNhM7DEueM1esN8HHboHMunszJ9P4ErCX9Lc33G9ejstw/o79PHctg9l8Wrd5rTqQK
         AzrYtoP8kSrd/UbGwkJnqBe0IesMjQlq9NHAMiE4KdYbUs1gdKs5GETfFu70B0xk6rpE
         578Lqy9P1cS34mmYh8ihHQvzANu3hv9Er0Z+U71yYVUoeFzedxv8Oq8GBL7AscwgtZpK
         skLO/jBOLjwTWya9ehJh7AC+/aHsV9e3S1y0ict7pmmpqK/m/JdYIZAgct/WHZ96/Siv
         QtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zvFCsFEF+c6WSnVQCIY8n6qtZvunSUGwBvD0oW+rG8I=;
        b=JA8MwZLqaQP4+8tgsXeafYM55glA1ea4p8e6kjKuzimqMHteuguZJyoPMz76e7RUH0
         EW4aJhZrWCcTpgzumr9GT5EGLhafWGIESlUFMO2OPTuxjUnIHMePJgiM/sUlI7lyzHuO
         Zd0DOkbFexufRsq+DJrFn60QhKd3/MthKWtt+xepn829qdkYEza2r/8OZ9QrkRiwbxLu
         s1R9rUAEctPcLmNQLnsBW5yWhEeOys11ofxspLKrhCo2PP4viOFGxjmjH/fGgU0WeFcz
         TrSuKJEVqcG35QXQ0kBasmcrYVNamCIuoCa3DyfmhstuFXMaQSmewdPGsDKQ2P1oRduG
         y8Vg==
X-Gm-Message-State: APjAAAWi/2uRsZuy+bhhQXP8TvdgAkr0YI+V+zKG0P5+o2wpV2fwFp+3
        8hVQOvLvbDU+noblc8NDfhehGVYa/nw=
X-Google-Smtp-Source: APXvYqzi04PVt0A5odZXH7i4+fkzAzfnGPPShRWS5TVG9aaVfSrBkrSCMCqu0zQsffN4pj3/tzaCVQ==
X-Received: by 2002:a02:c906:: with SMTP id t6mr70592789jao.75.1578284450257;
        Sun, 05 Jan 2020 20:20:50 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:25de:66a4:163b:14df? ([2601:282:800:7a:25de:66a4:163b:14df])
        by smtp.googlemail.com with ESMTPSA id h3sm23393348ilh.6.2020.01.05.20.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2020 20:20:49 -0800 (PST)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
Date:   Sun, 5 Jan 2020 21:20:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/20 8:51 PM, Tetsuo Handa wrote:
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index ecea41ce919b..5b2177724d5e 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2810,7 +2810,7 @@ static int smack_socket_bind(struct socket *sock, struct sockaddr *address,
>  	if (sock->sk != NULL && sock->sk->sk_family == PF_INET6) {
>  		if (addrlen < SIN6_LEN_RFC2133 ||
>  		    address->sa_family != AF_INET6)
> -			return -EINVAL;
> +			return 0;
>  		smk_ipv6_port_label(sock, address);
>  	}
>  	return 0;
> 

Hi:

The failure is the connect function, not the bind.

This change seems more appropriate to me (and fixes the failure):

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ecea41ce919b..ce5e3be7c111 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2854,7 +2854,7 @@ static int smack_socket_connect(struct socket
*sock, struct sockaddr *sap,
                rc = smack_netlabel_send(sock->sk, (struct sockaddr_in
*)sap);
                break;
        case PF_INET6:
-               if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family !=
AF_INET6)
+               if (addrlen < SIN6_LEN_RFC2133)
                        return -EINVAL;
 #ifdef SMACK_IPV6_SECMARK_LABELING
                rsp = smack_ipv6host_label(sip);


ie., if the socket family is AF_INET6 the address length should be an
IPv6 address. The family in the sockaddr is not as important.
