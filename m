Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7D132EA4
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgAGSoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:44:37 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:39434 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgAGSog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:44:36 -0500
Received: by mail-il1-f193.google.com with SMTP id x5so464266ila.6
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 10:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YxecbRSS5/xS4hfBj+SmIjlgG7O+fWqM5dnBKs9e0GM=;
        b=AL1KkxQliv4o/NfvgA5RM2hMskItOwHYkO0klfA5Ew2XPA6BAd50XRLAlpGEKYMwhX
         8esFENtoEfF2iAUunp5wnVOzmb4wxCWk4hAAHu6zYdpz/NZE023MhsXr5Re1qvpOgwKx
         64Ofv1wsGSkOXQinOxkILadarp95P5o+7fca3IhYgi6hCq3zD0AM55mGcJY6rwgA2yKY
         /F9ORG8WJaYC5JHSdl+swUW1WaXkyGz9xrfew0VMgLNtu63/WabRkT1a90i71/lWdGwZ
         IP1RJYg7pFtc1ixqGI1t32Rto0k8Zb2B1DutX3LwlNWTBc4h3s6VBFWWe0Dp/hRJI29w
         u1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YxecbRSS5/xS4hfBj+SmIjlgG7O+fWqM5dnBKs9e0GM=;
        b=Th5zQStsD81/rF/X1H10tjgvnnSN92/kDV8as6Wdm5Jcho2a9emqEHMmR+mimD4bFo
         ATcGcirFecyITfIXzMRK9vP9kIoIBkRMYPG2QoH7hNmuN7qkkutdz/WDKma5NkvI7pvO
         hNTUzW4WaKnsAOn2GF1IWYolOxhAWGPKyocRR0Dvvy9cFnElArhZXVU5IBT/uI6BUHnu
         4tDr/yNVuOW+Pb32epVAnVgUNxJIy8C6AIs+qCw7IEXzJos/oMLaAKRby6jluNJZ06+E
         KJfV6qGLGVGQrgQYR2nD3SFwPZfkjRpE6Xbu48J9UZ3sWboZb2wRLtx7XSoKta4ozqSf
         Vk8Q==
X-Gm-Message-State: APjAAAXfsrKmKkSGDy5tbpGbVjJGn5+rtanPL4X5ZxsYtXkKH7Oqus0u
        0yurUwnyTKAyFsfDiP9PXmax9a5q
X-Google-Smtp-Source: APXvYqzhfTIR65FoOQ/XIx3k223CdwfZhq+RfKz+IFrDFe0Dmr/1v5s/ACk8mCWNbdrrWpOhJwT+qw==
X-Received: by 2002:a92:5e46:: with SMTP id s67mr485507ilb.162.1578422675799;
        Tue, 07 Jan 2020 10:44:35 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:25de:66a4:163b:14df? ([2601:282:800:7a:25de:66a4:163b:14df])
        by smtp.googlemail.com with ESMTPSA id s88sm122367ilk.79.2020.01.07.10.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 10:44:35 -0800 (PST)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
 <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
 <3bafff5a-f404-e559-bfd6-bb456a923525@schaufler-ca.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e0fd132-4574-4ae7-45ea-88c4a2ec94b2@gmail.com>
Date:   Tue, 7 Jan 2020 11:44:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <3bafff5a-f404-e559-bfd6-bb456a923525@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 11:40 AM, Casey Schaufler wrote:
> Does this patch address the Debian issue? It works for the test program
> and on my Fedora system.
> 
> 
>  security/smack/smack_lsm.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 50c536cad85b..b0bb36419aeb 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2857,7 +2857,9 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
>  		rc = smack_netlabel_send(sock->sk, (struct sockaddr_in *)sap);
>  		break;
>  	case PF_INET6:
> -		if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family != AF_INET6)
> +		if (addrlen < SIN6_LEN_RFC2133)
> +			return 0;
> +		if (sap->sa_family != AF_INET6)
>  			return -EINVAL;

I doubt it; can't test it until tonight. strace for ping on buster is
showing this:

$ strace -e connect ping6 -c1 -w1 ff02::1%eth1
connect(4, {sa_family=AF_UNSPEC,
sa_data="\4\1\0\0\0\0\377\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\3\0\0\0"}, 28)

ie., the addrlen >= SIN6_LEN_RFC2133 but the family is AF_UNSPEC. That
suggests to me the first check passes and the second check fails.
