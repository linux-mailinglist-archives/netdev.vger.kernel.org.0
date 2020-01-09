Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578AA135205
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 04:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgAIDjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 22:39:24 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46090 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbgAIDjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 22:39:24 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so5563502ioi.13
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 19:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ieCOBB+i/5HDuOSLZ5XBVg841/uijK+zgRS6tLkY0RY=;
        b=Q6xvnTDCgE6xgjrNIgvBwrT/hcX8y++9ZSJCkLAvJ+ejerDUiNX3dUCYtahHhKX44N
         l19zchWwxlTUtNm+3M/wZcxWWBk++N8LIUVt155Ev/ImEg7KYgwQr8wb8KlS++a/auBi
         dr2lhrQaUD++mClOTwsK6hCmoOIy2pwCSnO9Th3mK0hMYsDaWAFNkXwKZV1UVmOAkX2S
         TtaLluDlIxI0wrKbDNR+JbwrbH+D/0x9mjNAJEyMNbit+JayN1l8TMxttfwrTY+3DFVN
         aD2dxZCzC1LGd7snnBEmOGp+v0N0He35tIWtQRtIhLOuTSzqsjb03z7jPz8llejyeabf
         iz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ieCOBB+i/5HDuOSLZ5XBVg841/uijK+zgRS6tLkY0RY=;
        b=Wv2HdyaCho5ylwwLa25UrmSSVKIbgkwSDuFq0XqGUwlqa47KbvO1m+pCicK/RNUF4x
         iVMrc2ac/Wp8iAEH6eGgC7tiMlWGvIVDb18YHB2bKXU6zv9+cCsJK7cp5Mm5ZibQP+mV
         YFxz47qCIQ27K7Ujbs/bfIzWIu2gOAGjs/jGHTOs1QTrQaKsY/X5JKg+XJihqq9oKiCu
         qdZSDMzsxXX/WPdO32IjLP08BLut3p2vjups7PjJ6gCq6xi+SH5RlIuadnMwoOKjntnk
         vCYAYqT+o4PVQtKgoXR1HDGO3o5GkYUWcOysH9dD7XOtbshBqotY5IiAEdxX6bf8TKUf
         RCbQ==
X-Gm-Message-State: APjAAAWzaZhr493CkWTnn6VyGetk0kDJQB+x3SER5thLKZUxxyIHG3cg
        SJS+kCZkRSlcMBtJ5LDN3tSqAAYcenU=
X-Google-Smtp-Source: APXvYqwa6+61iJ6JMjUURblwV+CZi6ux2sfiXZhJK/bh1Hw1zvvnkveNtwgUxJUpASaLLcl+2+aRZg==
X-Received: by 2002:a6b:6f07:: with SMTP id k7mr6059184ioc.174.1578541163168;
        Wed, 08 Jan 2020 19:39:23 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:601d:4dc7:bf1b:dae9? ([2601:282:800:7a:601d:4dc7:bf1b:dae9])
        by smtp.googlemail.com with ESMTPSA id k16sm1592230ili.35.2020.01.08.19.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 19:39:22 -0800 (PST)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     =?UTF-8?B?5ZCJ6Jek6Iux5piO?= <hideaki.yoshifuji@miraclelinux.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
 <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
 <3bafff5a-f404-e559-bfd6-bb456a923525@schaufler-ca.com>
 <8e0fd132-4574-4ae7-45ea-88c4a2ec94b2@gmail.com>
 <a730696a-9361-d39e-5dc1-280dc8d0f052@gmail.com>
 <44c7cd8a-7383-dada-e193-bcd79852912d@schaufler-ca.com>
 <CAPA1RqAqBZNeN=T_FpApLo_-oZXeFctgGHcggY6xAXV+qHYcKg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <964655d2-f74b-68b8-86d5-bc390eabd7a6@gmail.com>
Date:   Wed, 8 Jan 2020 20:39:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAPA1RqAqBZNeN=T_FpApLo_-oZXeFctgGHcggY6xAXV+qHYcKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/20 6:53 PM, 吉藤英明 wrote:
> Hi,
> 
> 2020年1月9日(木) 8:06 Casey Schaufler <casey@schaufler-ca.com
> <mailto:casey@schaufler-ca.com>>:
> 
>     This version should work, I think. Please verify. Thank you.
> 
>     ----
>      security/smack/smack_lsm.c | 19 ++++++++++++-------
>      1 file changed, 12 insertions(+), 7 deletions(-)
> 
>     diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>     index 50c536cad85b..75b3953212e2 100644
>     --- a/security/smack/smack_lsm.c
>     +++ b/security/smack/smack_lsm.c
>     @@ -2857,10 +2857,13 @@ static int smack_socket_connect(struct
>     socket *sock, struct sockaddr *sap,
>                     rc = smack_netlabel_send(sock->sk, (struct
>     sockaddr_in *)sap);
>                     break;
>             case PF_INET6:
>     -               if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family !=
>     AF_INET6)
>     -                       return -EINVAL;
>     +               if (addrlen < SIN6_LEN_RFC2133)
>     +                       return 0;
> 
> 
> Why don't we assume AF_UNSPEC as if it were AF_INET6 for AF_INET6
> sockets here?
>  

it is not called out explicitly, but the rest of the proposed change:

 #ifdef SMACK_IPV6_SECMARK_LABELING
-		rsp = smack_ipv6host_label(sip);
+		if (sap->sa_family != AF_INET6)
+			rsp = NULL;
+		else
+			rsp = smack_ipv6host_label(sip);
 		if (rsp != NULL)
 			rc = smk_ipv6_check(ssp->smk_out, rsp, sip,
 						SMK_CONNECTING);

seems to handle AF_UNSPEC. Did you have something else in mind?

