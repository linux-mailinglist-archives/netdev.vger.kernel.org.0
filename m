Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135A6E4FD6
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440572AbfJYPIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:08:19 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:42621 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436893AbfJYPIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 11:08:19 -0400
Received: by mail-il1-f196.google.com with SMTP id o16so2118702ilq.9
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 08:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=IrkfVvn4Zmp4daizxuTgOn0CxSde6Ls/A/sZP2i/laE=;
        b=BcIgB9qWjPbdxCa3HgZVftxbBJnYapfxiS3drEGXeLoUkgE5K2ZG+Ew2JM1OY3w/fm
         Sskf+d3SHSLFTwHO9uZYEE1WsYx5sHbbHME5pHEYZ0oPqEmSKDjYM9FNizntQCGmEjxU
         8Qz7xLtj1nIvkjWIAhmNXueZ+IaH1VJZCwKrSEpb+kUKIVzDVAwf2sVbdgzC+N2d+ZrG
         Ais8/ieLaH/vJ2mQv8/qq83A77R0SQwcCm6WTbnymkoxuENVbETFlj+LE4TR5RGWkMsd
         kCyOp2aCsdCNo6+bpytOm/3m+7czD5OCKefDYCzsVQ1aP/9OHUYz1eTk7hVXMrIdTtiJ
         IgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=IrkfVvn4Zmp4daizxuTgOn0CxSde6Ls/A/sZP2i/laE=;
        b=GCJQFKdaU1uKa3MsxW9oxFgraaIUfiIj304AdmYdjS6Sq7ilv9BSWFQhvaRf2egbhZ
         hOyoWHkIA+iX6KoytlzEcp5UUAtaSrKK1kU/C4QR0e8FoKb5hJ89sBMjZVvWec+uGUTn
         VwiS8Sx0PAIORt9vfb6B/0APyUB+2f1u/jkbNR55oU24fRr1qWNDNAG31q+8lnBg3lU/
         USNLcQsGOUKQRjoHd218naWTe8KeVZPNpQOAjjojrI0KG7DJpfuullHpR2oantLlfrs/
         3pmAFVDm03T8aMbSg8s/AYOQXjAWgLoZd03XgGOfKqd2W2mTpVFDz2ZMeLFhtw3MGLYs
         T08w==
X-Gm-Message-State: APjAAAUsi/CQP5u4hVI+jNL3/0ajEg+tBdBrU0XnZ7mog9PesqXTOiZb
        ScC/uiHAf1+18/XZiqyyBy323A==
X-Google-Smtp-Source: APXvYqzpQjRvNQjC3Q3v3mUrjK9LPKaS5BfVa8z+vpzyWpOOj7wD6Bl0uIE4gokf7O6ShUk0SQq2fg==
X-Received: by 2002:a92:9c95:: with SMTP id x21mr4698826ill.115.1572016097061;
        Fri, 25 Oct 2019 08:08:17 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id u85sm385590ili.28.2019.10.25.08.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 08:08:15 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
Message-ID: <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
Date:   Fri, 25 Oct 2019 11:08:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
Content-Type: multipart/mixed;
 boundary="------------C91869D6ADAE91E36F6AE69B"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------C91869D6ADAE91E36F6AE69B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2019-10-25 10:57 a.m., Jamal Hadi Salim wrote:
> On 2019-10-25 10:26 a.m., Vlad Buslov wrote:

> 
> I think i understand what you are saying. Let me take a quick
> look at the code and get back to you.
>

How about something like this (not even compile tested)..

Yes, that init is getting uglier... over time if we
are going to move things into shared attributes we will
need to introduce a new data struct to pass to ->init()

cheers,
jamal

--------------C91869D6ADAE91E36F6AE69B
Content-Type: text/plain; charset=UTF-8;
 name="patchlet-v"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patchlet-v"

ZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9hY3RfYXBpLmMgYi9uZXQvc2NoZWQvYWN0X2FwaS5j
CmluZGV4IDY5ZDQ2NzZhNDAyZi4uYjBkMWUwMGZlMmMyIDEwMDY0NAotLS0gYS9uZXQvc2No
ZWQvYWN0X2FwaS5jCisrKyBiL25ldC9zY2hlZC9hY3RfYXBpLmMKQEAgLTg0Miw2ICs4NDIs
NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG5sYV9wb2xpY3kgdGNmX2FjdGlvbl9wb2xpY3lb
VENBX0FDVF9NQVggKyAxXSA9IHsKIHN0cnVjdCB0Y19hY3Rpb24gKnRjZl9hY3Rpb25faW5p
dF8xKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsCiAJCQkJICAgIHN0
cnVjdCBubGF0dHIgKm5sYSwgc3RydWN0IG5sYXR0ciAqZXN0LAogCQkJCSAgICBjaGFyICpu
YW1lLCBpbnQgb3ZyLCBpbnQgYmluZCwKKwkJCQkgICAgc3RydWN0IG5sYV9iaXRmaWVsZDMy
ICpyb290X2ZsYWdzLAogCQkJCSAgICBib29sIHJ0bmxfaGVsZCwKIAkJCQkgICAgc3RydWN0
IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKQogewpAQCAtOTE0LDEwICs5MTUsMTAgQEAgc3Ry
dWN0IHRjX2FjdGlvbiAqdGNmX2FjdGlvbl9pbml0XzEoc3RydWN0IG5ldCAqbmV0LCBzdHJ1
Y3QgdGNmX3Byb3RvICp0cCwKIAkvKiBiYWNrd2FyZCBjb21wYXRpYmlsaXR5IGZvciBwb2xp
Y2VyICovCiAJaWYgKG5hbWUgPT0gTlVMTCkKIAkJZXJyID0gYV9vLT5pbml0KG5ldCwgdGJb
VENBX0FDVF9PUFRJT05TXSwgZXN0LCAmYSwgb3ZyLCBiaW5kLAotCQkJCXJ0bmxfaGVsZCwg
dHAsIGV4dGFjayk7CisJCQkJcnRubF9oZWxkLCByb290X2ZsYWdzLCB0cCwgZXh0YWNrKTsK
IAllbHNlCiAJCWVyciA9IGFfby0+aW5pdChuZXQsIG5sYSwgZXN0LCAmYSwgb3ZyLCBiaW5k
LCBydG5sX2hlbGQsCi0JCQkJdHAsIGV4dGFjayk7CisJCQkJcm9vdF9mbGFncywgdHAsIGV4
dGFjayk7CiAJaWYgKGVyciA8IDApCiAJCWdvdG8gZXJyX21vZDsKIApAQCAtOTU1LDcgKzk1
Niw4IEBAIHN0cnVjdCB0Y19hY3Rpb24gKnRjZl9hY3Rpb25faW5pdF8xKHN0cnVjdCBuZXQg
Km5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsCiBpbnQgdGNmX2FjdGlvbl9pbml0KHN0cnVj
dCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsIHN0cnVjdCBubGF0dHIgKm5sYSwK
IAkJICAgIHN0cnVjdCBubGF0dHIgKmVzdCwgY2hhciAqbmFtZSwgaW50IG92ciwgaW50IGJp
bmQsCiAJCSAgICBzdHJ1Y3QgdGNfYWN0aW9uICphY3Rpb25zW10sIHNpemVfdCAqYXR0cl9z
aXplLAotCQkgICAgYm9vbCBydG5sX2hlbGQsIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4
dGFjaykKKwkJICAgIGJvb2wgcnRubF9oZWxkLCBzdHJ1Y3QgbmxhX2JpdGZpZWxkMzIgKnJv
b3RfZmxhZ3MsCisJCSAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spCiB7CiAJ
c3RydWN0IG5sYXR0ciAqdGJbVENBX0FDVF9NQVhfUFJJTyArIDFdOwogCXN0cnVjdCB0Y19h
Y3Rpb24gKmFjdDsKQEAgLTk3MCw3ICs5NzIsNyBAQCBpbnQgdGNmX2FjdGlvbl9pbml0KHN0
cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsIHN0cnVjdCBubGF0dHIgKm5s
YSwKIAogCWZvciAoaSA9IDE7IGkgPD0gVENBX0FDVF9NQVhfUFJJTyAmJiB0YltpXTsgaSsr
KSB7CiAJCWFjdCA9IHRjZl9hY3Rpb25faW5pdF8xKG5ldCwgdHAsIHRiW2ldLCBlc3QsIG5h
bWUsIG92ciwgYmluZCwKLQkJCQkJcnRubF9oZWxkLCBleHRhY2spOworCQkJCQlyb290X2Zs
YWdzLCBydG5sX2hlbGQsIGV4dGFjayk7CiAJCWlmIChJU19FUlIoYWN0KSkgewogCQkJZXJy
ID0gUFRSX0VSUihhY3QpOwogCQkJZ290byBlcnI7CkBAIC0xMzUwLDYgKzEzNTIsNyBAQCB0
Y2ZfYWRkX25vdGlmeShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBubG1zZ2hkciAqbiwgc3Ry
dWN0IHRjX2FjdGlvbiAqYWN0aW9uc1tdLAogCiBzdGF0aWMgaW50IHRjZl9hY3Rpb25fYWRk
KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IG5sYXR0ciAqbmxhLAogCQkJICBzdHJ1Y3Qgbmxt
c2doZHIgKm4sIHUzMiBwb3J0aWQsIGludCBvdnIsCisJCQkgIHN0cnVjdCBubGFfYml0Zmll
bGQzMiAqcm9vdF9mbGFncywKIAkJCSAgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNr
KQogewogCXNpemVfdCBhdHRyX3NpemUgPSAwOwpAQCAtMTM1OCw3ICsxMzYxLDggQEAgc3Rh
dGljIGludCB0Y2ZfYWN0aW9uX2FkZChzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBubGF0dHIg
Km5sYSwKIAogCWZvciAobG9vcCA9IDA7IGxvb3AgPCAxMDsgbG9vcCsrKSB7CiAJCXJldCA9
IHRjZl9hY3Rpb25faW5pdChuZXQsIE5VTEwsIG5sYSwgTlVMTCwgTlVMTCwgb3ZyLCAwLAot
CQkJCSAgICAgIGFjdGlvbnMsICZhdHRyX3NpemUsIHRydWUsIGV4dGFjayk7CisJCQkJICAg
ICAgYWN0aW9ucywgJmF0dHJfc2l6ZSwgdHJ1ZSwgcm9vdF9mbGFncywKKwkJCQkgICAgICBl
eHRhY2spOwogCQlpZiAocmV0ICE9IC1FQUdBSU4pCiAJCQlicmVhazsKIAl9CkBAIC0xMzg1
LDYgKzEzODksNyBAQCBzdGF0aWMgaW50IHRjX2N0bF9hY3Rpb24oc3RydWN0IHNrX2J1ZmYg
KnNrYiwgc3RydWN0IG5sbXNnaGRyICpuLAogCXN0cnVjdCBuZXQgKm5ldCA9IHNvY2tfbmV0
KHNrYi0+c2spOwogCXN0cnVjdCBubGF0dHIgKnRjYVtUQ0FfUk9PVF9NQVggKyAxXTsKIAl1
MzIgcG9ydGlkID0gc2tiID8gTkVUTElOS19DQihza2IpLnBvcnRpZCA6IDA7CisJc3RydWN0
IG5sYV9iaXRmaWVsZDMyIHJvb3RfZmxhZ3MgPSB7MCwgMH07CiAJaW50IHJldCA9IDAsIG92
ciA9IDA7CiAKIAlpZiAoKG4tPm5sbXNnX3R5cGUgIT0gUlRNX0dFVEFDVElPTikgJiYKQEAg
LTE0MTIsOCArMTQxNywxMSBAQCBzdGF0aWMgaW50IHRjX2N0bF9hY3Rpb24oc3RydWN0IHNr
X2J1ZmYgKnNrYiwgc3RydWN0IG5sbXNnaGRyICpuLAogCQkgKi8KIAkJaWYgKG4tPm5sbXNn
X2ZsYWdzICYgTkxNX0ZfUkVQTEFDRSkKIAkJCW92ciA9IDE7CisJCWlmICh0YltUQ0FfUk9P
VF9GTEFHU10pCisJCQlyb290X2ZsYWdzID0gbmxhX2dldF9iaXRmaWVsZDMyKHRiW1RDQV9S
T09UX0ZMQUdTXSk7CisKIAkJcmV0ID0gdGNmX2FjdGlvbl9hZGQobmV0LCB0Y2FbVENBX0FD
VF9UQUJdLCBuLCBwb3J0aWQsIG92ciwKLQkJCQkgICAgIGV4dGFjayk7CisJCQkJICAgICAm
cm9vdF9mbGFncywgZXh0YWNrKTsKIAkJYnJlYWs7CiAJY2FzZSBSVE1fREVMQUNUSU9OOgog
CQlyZXQgPSB0Y2FfYWN0aW9uX2dkKG5ldCwgdGNhW1RDQV9BQ1RfVEFCXSwgbiwK
--------------C91869D6ADAE91E36F6AE69B--
