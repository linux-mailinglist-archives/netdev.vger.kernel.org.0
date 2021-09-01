Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5453FE2A3
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343599AbhIAS50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbhIAS5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:57:19 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E924C061575;
        Wed,  1 Sep 2021 11:56:22 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j4so1045795lfg.9;
        Wed, 01 Sep 2021 11:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=5Ls5tdZcgjAmm9EO+SNlDuOmJLHTrPRKDJwY8l9kvo8=;
        b=OgzS95dL3ZT+rbl/tOUFVv0WCvjJaorvdJX2cDP5RDZHjWK8/gFgp9uiNlirobPj+e
         Z8rmjfX4O//0ueb0CMRX5J8+mPqagPT9HAfhG4yykIWjjH+8BhEvmp7Lv86mVXn8M5mO
         0DxUkNE6VKicd8VaaCsrxCwd5uv77SyUQxBaJfmYfprMifoj2L41XBlPHMjQEK9Xcj+1
         C+FDbY0UvLqsBw2gpod57naRIBzE+i07v8ZaoftdDe1q6qF03JhUiNDevTrjzZqgKK56
         MIdkPpZQvFAWygaogGsNs09QpzswuyH7oISVfdBvPRwop+N30q6/OboJwysFpZMuLikU
         ntvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=5Ls5tdZcgjAmm9EO+SNlDuOmJLHTrPRKDJwY8l9kvo8=;
        b=ppmCIhr425fnB0jdhTXWoZC1TUfF6yYJSrPqprSNnj98MltlRqx3q5Nx7n1rCrN7uA
         l7IqqGHZqf3mA7GL6Rs3V/Jp2fLGRnBqGLI2WJalPBI5wqyMUgzfujKJrWiiaE4CdAtW
         e2I7hjFV3Arilq6fLOEqfOPxVxVZWHDRikh0T2j9JSPCagZLGLyShWQBvuOgkS6tyStf
         80jrSnTVEMM4WSzJl+06mUfUto369TYvrmKvFJE+HHuNImve/EqIMuZL0yVl7unun/Dy
         308U2ocvCs0W3MoL3yOzhQTM7zMpcUroFfiXskaWR32IHhUYs/3guoHCywzjx5UQiOuH
         Rs3g==
X-Gm-Message-State: AOAM5315bJRgT4OMKIezq1QxogagAiWGQfsxMRrMPQ4G9KR4m60iIfhm
        V1bWi4izMOsKLg6SUl2tC2A=
X-Google-Smtp-Source: ABdhPJwehF9+6XQB1ZsBp8VczIlAs2ber0nIQi8Hj/ah8Iq1Fw9rod3o6EGdSFpnAYKq0GuKq/Rg4Q==
X-Received: by 2002:ac2:5d67:: with SMTP id h7mr643935lft.639.1630522580878;
        Wed, 01 Sep 2021 11:56:20 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.213])
        by smtp.gmail.com with UTF8SMTPSA id b3sm29955lft.286.2021.09.01.11.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 11:56:20 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------wbRB09NhaTJxYttPtduufDEK"
Message-ID: <52d33ff4-5ddc-0103-9312-f75b7e7cb5b6@gmail.com>
Date:   Wed, 1 Sep 2021 21:56:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_get_default
Content-Language: en-US
To:     syzbot <syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com>,
        antony.antony@secunet.com, christian.langrock@secunet.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
References: <000000000000b2420c05cacc8c66@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000b2420c05cacc8c66@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------wbRB09NhaTJxYttPtduufDEK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/30/21 23:19, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    eaf2aaec0be4 Merge tag 'wireless-drivers-next-2021-08-29' ..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1219326d300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f9d4c9ff8c5ae7
> dashboard link: https://syzkaller.appspot.com/bug?extid=b2be9dd8ca6f6c73ee2d
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e6e3a9300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10de8a6d300000
> 
> The issue was bisected to:
> 
> commit 2d151d39073aff498358543801fca0f670fea981
> Author: Steffen Klassert <steffen.klassert@secunet.com>
> Date:   Sun Jul 18 07:11:06 2021 +0000
> 
>      xfrm: Add possibility to set the default to block if we have no policy
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114523fe300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=134523fe300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=154523fe300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> 
> netlink: 172 bytes leftover after parsing attributes in process `syz-executor354'.
> ================================================================================
> UBSAN: shift-out-of-bounds in net/xfrm/xfrm_user.c:2010:49
> shift exponent 224 is too large for 32-bit type 'int'


#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git




With regards,
Pavel Skripkin
--------------wbRB09NhaTJxYttPtduufDEK
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
--------------wbRB09NhaTJxYttPtduufDEK--

