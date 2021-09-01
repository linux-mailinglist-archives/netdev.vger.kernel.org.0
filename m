Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B474A3FE2A7
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbhIAS6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhIAS6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:58:18 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF4FC061575;
        Wed,  1 Sep 2021 11:57:21 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id q21so753409ljj.6;
        Wed, 01 Sep 2021 11:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=fBnJIU0t61NUYaxawSY/ly3EIWKLTHzb1N4k4y6uowY=;
        b=dcteTyooUmZjcHkbtxkpdtLpY9tGcvh2AgJNtXkeTNvX+xq2ZQHJhucs+325qQaiee
         NqcN0b58DoAZSl933/hRagDQw+oUOE6D0WceLayzya1dd9al7e/x3igu5FcrpzE7RZie
         m1ZIUHzYN0yI70AiYYDo43OEC7M1v38rBH1LNwhW8E/6qg7vugT73LLkG4zNh64iYhcB
         N1alsVtXNlI+KYqrnoU4x/LFzVtnUc+ZEvNRMn4Y7P/60jGZaNucf+98qVklF165Uxeg
         H9iYKo2ez5grTX2UixL2AxvflAvm9N1qz76Ah3cR313YQ6B0Y4cFSwZE37Id1nW9P/Yn
         7EpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=fBnJIU0t61NUYaxawSY/ly3EIWKLTHzb1N4k4y6uowY=;
        b=MNiNojHZPoJ5vlueY6ZxEQlCOP2kfF6ASYcDrX5tfm1++Zv+be9EODeA9EDYO6WUM1
         RjNas4HvaLTr5cGP74tqT+WbDDScd4MGPSLyBcp6OcQDRvA8xOKBSKLak6UNW55dArxF
         wpz9kv9ogZFDJvaBc+nnEuuY5UHq7fu/0y9qByqSx8mDHpiPECN5VK7urZBEtc+6g4vk
         0N7t2tgIjnQ+mn9oDrXIjG4ZYtivqzC1cpNb9TjErN/3eyfP+5WtzoAK1pJnI6pWDjhC
         67Bol7e5bGvrn9ed4o0kkQcRSOCGEG9p4aYG0FFJ02OShu5KAv2cTRNt09MQldn16Kxx
         jRKg==
X-Gm-Message-State: AOAM531WLNvQZ9AwBuSpqq8Pu4HoG83xZ63lNF0IaRFUoYi05xM581V+
        08G8s8m9pWEMai5lUEHvJbQ=
X-Google-Smtp-Source: ABdhPJwdQXW+aQoZakU0ljZ/d0ZRNQn+5F6Ydi9iqCatsoD0JMuxq0OplSrpkZu5G77DuMqfZKbGUw==
X-Received: by 2002:a2e:a58b:: with SMTP id m11mr938202ljp.342.1630522639395;
        Wed, 01 Sep 2021 11:57:19 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.213])
        by smtp.gmail.com with UTF8SMTPSA id x74sm31029lff.179.2021.09.01.11.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 11:57:18 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------p6tOJn77QrvhVhWu2egpseeU"
Message-ID: <ba030947-6463-9a0f-7ce1-cd712ef9c1aa@gmail.com>
Date:   Wed, 1 Sep 2021 21:57:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_get_default
Content-Language: en-US
To:     syzbot <syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com>
Cc:     antony.antony@secunet.com, christian.langrock@secunet.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
References: <0000000000004b552c05caf39fd8@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <0000000000004b552c05caf39fd8@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------p6tOJn77QrvhVhWu2egpseeU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/21 21:56, syzbot wrote:
>> On 8/30/21 23:19, syzbot wrote:
>>> Hello,
>>> 
>>> syzbot found the following issue on:
>>> 
>>> HEAD commit:    eaf2aaec0be4 Merge tag 'wireless-drivers-next-2021-08-29' ..
>>> git tree:       net-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1219326d300000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f9d4c9ff8c5ae7
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b2be9dd8ca6f6c73ee2d
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e6e3a9300000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10de8a6d300000
>>> 
>>> The issue was bisected to:
>>> 
>>> commit 2d151d39073aff498358543801fca0f670fea981
>>> Author: Steffen Klassert <steffen.klassert@secunet.com>
>>> Date:   Sun Jul 18 07:11:06 2021 +0000
>>> 
>>>      xfrm: Add possibility to set the default to block if we have no policy
>>> 
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114523fe300000
>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=134523fe300000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=154523fe300000
>>> 
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com
>>> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
>>> 
>>> netlink: 172 bytes leftover after parsing attributes in process `syz-executor354'.
>>> ================================================================================
>>> UBSAN: shift-out-of-bounds in net/xfrm/xfrm_user.c:2010:49
>>> shift exponent 224 is too large for 32-bit type 'int'
>>
>>
>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> 
> want 2 args (repo, branch), got 3
> 

Whoops... :(



#syz test: 
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git master




With regards,
Pavel Skripkin
--------------p6tOJn77QrvhVhWu2egpseeU
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-xfrm-fix-shift-out-of-bounds-in-xfrm_get_default.patch"
Content-Disposition: attachment;
 filename*0="0001-net-xfrm-fix-shift-out-of-bounds-in-xfrm_get_default.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAwMzk1ODM5MDI4YjEzZjRlMzgwZTE2N2M2MzgxZTRlZWE0YTlmYzQyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBTa3JpcGtpbiA8cGFza3JpcGtpbkBnbWFp
bC5jb20+CkRhdGU6IFdlZCwgMSBTZXAgMjAyMSAyMTo1NToyNSArMDMwMApTdWJqZWN0OiBb
UEFUQ0hdIG5ldDogeGZybTogZml4IHNoaWZ0LW91dC1vZi1ib3VuZHMgaW4geGZybV9nZXRf
ZGVmYXVsdAoKLyogLi4uICovCgpTaWduZWQtb2ZmLWJ5OiBQYXZlbCBTa3JpcGtpbiA8cGFz
a3JpcGtpbkBnbWFpbC5jb20+Ci0tLQogbmV0L3hmcm0veGZybV91c2VyLmMgfCAzICsrKwog
MSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL25ldC94ZnJt
L3hmcm1fdXNlci5jIGIvbmV0L3hmcm0veGZybV91c2VyLmMKaW5kZXggYjdiOTg2NTIwZGM3
Li5hMWRkMzg1MjU5NTcgMTAwNjQ0Ci0tLSBhL25ldC94ZnJtL3hmcm1fdXNlci5jCisrKyBi
L25ldC94ZnJtL3hmcm1fdXNlci5jCkBAIC0yMDA3LDYgKzIwMDcsOSBAQCBzdGF0aWMgaW50
IHhmcm1fZ2V0X2RlZmF1bHQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5sbXNnaGRy
ICpubGgsCiAKIAlyX3VwID0gbmxtc2dfZGF0YShyX25saCk7CiAKKwlpZiAodXAtPmRpcm1h
c2sgPj0gWEZSTV9VU0VSUE9MSUNZX0RJUk1BU0tfTUFYKQorCQlyZXR1cm4gLUVJTlZBTDsK
KwogCXJfdXAtPmFjdGlvbiA9ICgobmV0LT54ZnJtLnBvbGljeV9kZWZhdWx0ICYgKDEgPDwg
dXAtPmRpcm1hc2spKSA+PiB1cC0+ZGlybWFzayk7CiAJcl91cC0+ZGlybWFzayA9IHVwLT5k
aXJtYXNrOwogCW5sbXNnX2VuZChyX3NrYiwgcl9ubGgpOwotLSAKMi4zMy4wCgo=
--------------p6tOJn77QrvhVhWu2egpseeU--

