Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8901616012B
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 00:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgBOXmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 18:42:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38748 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgBOXmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 18:42:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so15286975wrh.5
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 15:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QM5xcVAfeaTfSpqqkFNfyzPo7Ae2XakKgkOTJyXKvFE=;
        b=GOQxlFpToqVvN5AItk3pZNRezizBuCefCtg9NYuFwAuMQU9CpFS2epJOF3eJpyJ/D6
         k5IxzVqRClDNx+9l2NXjF49K6VYWvg3wr21k/asNxTHcLpKQljOx25N1fIW3ZogsDLwS
         wo46AdgkFZ2msSgxOO/1fgIXlJrJEYJwkbIYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QM5xcVAfeaTfSpqqkFNfyzPo7Ae2XakKgkOTJyXKvFE=;
        b=h+1hD6k2RSTH553PUfGVXpgfL2zeQOw4vgZmD3EVKlOEhrfyszaRy5MIifoaRXyt9l
         fsV0GzWZz7fXsszcN0Mr0XrCpniOWsZIu48cqbywIGa+rm6LG3zNNLMwJRbk6LQEHw57
         rQY4MrwpfKEXmLN1hxe8V0jEWEIfDmCIX9gimkq0CjFqbZu8SLrasxp3W+TFa5OBu+O9
         Ar8hXShlL4NP6aBwU2ZzDYYLOTajdb78+x7qpPHQkhml3oe4Be+3y3F0izQHYHHqP7Zh
         VRRYU/1AQliqRre/oTLwfci0c9AQJwxvitDf7x03Ns0eZJFoLKdYd9FE6W5h+cjCnQrX
         JwhQ==
X-Gm-Message-State: APjAAAX/upi+J/5VwEPTgGk+2E8z/z0k3DzHHZKD66SMTuNJQ/uVHQF5
        nG4Oa6R9Fz3Grny6tju1fHVckyqrMraAkQ==
X-Google-Smtp-Source: APXvYqzql9k3rZuucyDqgndFIBvZDd026jRfKu45YpOkNNEz7+RRJRH1vTpGKMhWLUE24rZR+6puBA==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr12434007wru.398.1581810160888;
        Sat, 15 Feb 2020 15:42:40 -0800 (PST)
Received: from [10.6.5.6] (130.202.158.77.rev.sfr.net. [77.158.202.130])
        by smtp.googlemail.com with ESMTPSA id f127sm13480204wma.4.2020.02.15.15.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 15:42:40 -0800 (PST)
Subject: Re: [netlink_bind()] [Bug 206525] BUG: KASAN: stack-out-of-bounds in
 test_bit+0x30/0x44 (kernel 5.6-rc1)
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bug-206525-206035-l8GOXmwaUO@https.bugzilla.kernel.org/>
 <4c64dd30-b742-cc54-540d-f81f6f0ecc18@c-s.fr>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <c0b3bc83-2a3a-92c4-94c5-8b92d22df948@cumulusnetworks.com>
Date:   Sun, 16 Feb 2020 01:42:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4c64dd30-b742-cc54-540d-f81f6f0ecc18@c-s.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/20 7:58 PM, Christophe Leroy wrote:
> 
> 
> 
> -------- Message transféré --------
> Sujet : [Bug 206525] BUG: KASAN: stack-out-of-bounds in test_bit+0x30/0x44 (kernel 5.6-rc1)
> Date : Sat, 15 Feb 2020 17:52:44 +0000
> De : bugzilla-daemon@bugzilla.kernel.org
> Pour : linuxppc-dev@lists.ozlabs.org
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=206525
> 
> --- Comment #3 from Christophe Leroy (christophe.leroy@c-s.fr) ---
> Bug introduced by commit ("cf5bddb95cbe net: bridge: vlan: add rtnetlink group
> and notify support")
> 
> RTNLGRP_MAX is now 33.
> 
> 'unsigned long groups' is 32 bits long on PPC32
> 
> Following loop in netlink_bind() overflows.
> 
> 
>                  for (group = 0; group < nlk->ngroups; group++) {
>                          if (!test_bit(group, &groups))
>                                  continue;
>                          err = nlk->netlink_bind(net, group + 1);
>                          if (!err)
>                                  continue;
>                          netlink_undo_bind(group, groups, sk);
>                          goto unlock;
>                  }
> 
> 
> Should 'groups' be changes to 'unsigned long long' ?
> 

Hi,
I'm currently traveling and will be able to look into this properly in a few days, but
I think we can just cap these at min(BITS_PER_TYPE(u32), nlk->ngroups) since "groups" is coming
from sockaddr_nl's "nl_groups" which is a u32, for any groups beyond u32 one has to use
setsockopt().

Cheers,
  Nik

