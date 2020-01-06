Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5DB13163D
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgAFQlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:41:12 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46572 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgAFQlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 11:41:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id z124so27092256pgb.13
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 08:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bi8+ooZhbVbxiI2xzcaK+DFWacp4yQ1RWSgQfqmop7M=;
        b=tpakkMR7s18OMs5kphOzn0I0gJuqjfPl+QtJD4Bs5CywIwMaw1O0BANxHu25mLUSgN
         G5guuyo4K1pCYAROMttdjKvrau1jq4hHm9OTlJfePVQR0WGE5XIDe97E5RJejsq4jist
         vRf4n5h6jvxXMEZHwJxY17KeCreLw1uWfxnMtvGUtbyLNd/Mjmu9LUxVuJfvtgm/7M5S
         oz1ZfnqukHY6lTpIB1g6kIFsr+M4Xqi9Vm2rIK2brgDYe50//cMXpGCg3srBGxdHgLU1
         cO8t4hx7vBDfL72mKBZTsvVpfluooqq/RoNpBmtju8OzHBY81m3LCPLzt5UGvXW4Sq12
         tycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bi8+ooZhbVbxiI2xzcaK+DFWacp4yQ1RWSgQfqmop7M=;
        b=WvaMWnsCRwiyaSGwB33Ybe4Hykwwp8JTxrYd2JqVaw+o60+5WtYO+t0f4ZenvswFUy
         zJObxwGUL6YORXR4baUwIzRn6PYMpRTHwVoNcqybyfsd6/cs7+XiTH6hhDch9UU6jHDo
         gNbvmm/RZOy7zYh1i6wwVsYWaHpILp4d9mvsr2MfFA1bj8nxc8Ttg/2NKczLkuVwIggv
         dxOEmeqycskC0DV96frO3OukEwzoF01SNylA12w9f72Ti99qCkK2f9loGkfJKyqhUO6M
         fpUfvOiXySSKnnlOP8A39OSg9Bo7Ef/LbqV65f2K0H+Q7WT9xIrJ26Zf1MbZQbbGLW//
         5FqQ==
X-Gm-Message-State: APjAAAVVr+G9RF0DHlRquRJYmlrU9/b5C/hi+qIh9OIkoZ+woirFSXUA
        mmLhEZEnpmRH/7Ee4mtEx1Luy+OymT4=
X-Google-Smtp-Source: APXvYqzzkHxqYqh/yAay51Mu597NKLk8JHB25zed8mzkQmJPZPJMKykoRBmteO/gd+O2R3poQddVnA==
X-Received: by 2002:a63:480f:: with SMTP id v15mr110481121pga.201.1578328870914;
        Mon, 06 Jan 2020 08:41:10 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:25de:66a4:163b:14df? ([2601:282:800:7a:25de:66a4:163b:14df])
        by smtp.googlemail.com with ESMTPSA id s18sm74029497pfh.179.2020.01.06.08.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 08:41:09 -0800 (PST)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
Date:   Mon, 6 Jan 2020 09:41:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/20 4:04 AM, Tetsuo Handa wrote:
>>
>> This change seems more appropriate to me (and fixes the failure):
>>
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index ecea41ce919b..ce5e3be7c111 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -2854,7 +2854,7 @@ static int smack_socket_connect(struct socket
>> *sock, struct sockaddr *sap,
>>                 rc = smack_netlabel_send(sock->sk, (struct sockaddr_in
>> *)sap);
>>                 break;
>>         case PF_INET6:
>> -               if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family !=
>> AF_INET6)
>> +               if (addrlen < SIN6_LEN_RFC2133)
>>                         return -EINVAL;
> 
> This is called upon connect(), isn't it? Then, it is possible that a socket's
> protocol family is PF_INET6 but address given is AF_INET, isn't it? For example,
> __ip6_datagram_connect() checks for AF_INET before checking addrlen is at least
> SIN6_LEN_RFC2133 bytes. Thus, I think that we need to return 0 if address given
> is AF_INET even if socket is PF_INET6.

In this case, the sockaddr is AF_UNSPEC. From the first message:

$ strace -e connect ping6 -c1 -w1 ff02::1%eth1
connect(4, {sa_family=AF_UNSPEC,
sa_data="\4\1\0\0\0\0\377\2\0\0\0\0\0\0\0\0\0\0\0\0\0\1\3\0\0\0"}, 28) = 0

That's why I was suggesting if the socket is PF_INET6 and the address
length is at least SIN6_LEN_RFC2133, then don't worry about the sa_family.


> 
>>  #ifdef SMACK_IPV6_SECMARK_LABELING
>>                 rsp = smack_ipv6host_label(sip);
>>
>>
>> ie., if the socket family is AF_INET6 the address length should be an
>> IPv6 address. The family in the sockaddr is not as important.
>>
> 
> Commit b9ef5513c99b was wrong, but we need to also fix commit c673944347ed ?
> 

not sure. I have not seen a problem related to it yet.
