Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2286E559C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbfJYVFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:05:50 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:42735 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfJYVFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:05:50 -0400
Received: by mail-il1-f194.google.com with SMTP id o16so3006824ilq.9
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 14:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=c2/lTBnhcoOGhZEuACJlMmkVI+oFRt6BxVBj7vbYzzA=;
        b=cr0eHhDNPzs8z7NxHsF5AriPzwWLF+qsCJkXVKR53lrAPlmVz0VCYSYu1Z0UevGxEL
         jIRoQ3JCgMv2EmrOqVx3n4xTILXsvzC+5vE+Fr4oX4JcSPW7GjXpegl7Rbjd0a6LwNY0
         R+DSycC+EOFMJg4/zsThi8naPvqG1ZkKq9J2IDfm+A0cj9qZq5k7S8k4mDQCknuWwR2q
         puxvIYegHXI7XNwy07YzKAuREiMC3VqP1aBpqiaEe2oWQU6hBQXIX4dSYF9pVy/K2Kff
         xu/wHLfOC1NiEyMuKf1sbQr13FwBEm0gS3T8kyO5bYbBP5vEKBMHdSnT+9XxmMHOEugX
         68Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=c2/lTBnhcoOGhZEuACJlMmkVI+oFRt6BxVBj7vbYzzA=;
        b=Oezy4BFgEWzCL/jR8nCmLviNC9SMP44JQwSgZn+zQnj4J91DVG5ZcLlojsfsax3Hhv
         d2WhMdAukwnC64zRkcPKVkyCR+MUHOJFw07gTExFZwBC8M2S3A//xSMWlQpt0RW+Gk2Q
         UNKi+ScNsCXQ27YU9E27rVop1YOvI/nmjnEqOlOXNBKqiwPSoihikrBzXpCVKV0OTT/B
         AaXgDyHuc7n5CZwUXFwN7MFjmAOJcYfDXNfX9JSniQlMYDoJ9r97/juponephVNZwKZy
         qK1qlRfNpXWg9U2CRkHufNQHndmVMW14A28CMqWAL2afwU/QHfvEndqkQGcSTsIu6rt3
         v7Dg==
X-Gm-Message-State: APjAAAXj4lFITpvJMxPwb6Pqcryr0DgNMfBXqQn6Jr3hWJxLuTCoLmNp
        IIFLDpZzvYtlw1EFKz43415ucA==
X-Google-Smtp-Source: APXvYqyJyAMpil0va0++fYnBU+M12/Ys2oEvURMEgv8tlo8QjUrxg2PVckfkv1UhPlOHDUFpZF6zQw==
X-Received: by 2002:a92:c092:: with SMTP id h18mr1775598ile.174.1572037549438;
        Fri, 25 Oct 2019 14:05:49 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id r13sm500217ilo.35.2019.10.25.14.05.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 14:05:46 -0700 (PDT)
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
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
 <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
 <vbfmudou5qp.fsf@mellanox.com>
 <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
Message-ID: <d2ec62c3-afab-8a55-9329-555fc3ff23f0@mojatatu.com>
Date:   Fri, 25 Oct 2019 17:05:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
Content-Type: multipart/mixed;
 boundary="------------E2C05EFBE1BFA0F760322FFF"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------E2C05EFBE1BFA0F760322FFF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit


Like attached...

cheers,
jamal

On 2019-10-25 2:17 p.m., Jamal Hadi Salim wrote:
> On 2019-10-25 12:53 p.m., Vlad Buslov wrote:
> [..]
> 
> Sorry, the distractions here are not helping.
> When i responded i had started to do below
> 
> enum {
>          TCA_ACT_UNSPEC,
>          TCA_ACT_KIND,
>          TCA_ACT_OPTIONS,
>          TCA_ACT_INDEX,
>          TCA_ACT_STATS,
>          TCA_ACT_PAD,
>          TCA_ACT_COOKIE,
>          TCA_ACT_ROOT_FLAGS,
>          __TCA_ACT_MAX
> };
> 
> Note: "TCA_ACT_ROOT_FLAGS"
> I think your other email may have tried to do the same?
> So i claimed it was there in that email because grep showed it
> but that's because i had added it;->
> 
>> For cls API lets take flower as an example: fl_change() parses 
>> TCA_FLOWER, and calls
>> fl_set_parms()->tcf_exts_validate()->tcf_action_init() with
>> TCA_FLOWER_ACT nested attribute. No TCA_ROOT is expected, TCA_FLOWER_ACT
>> contains up to TCA_ACT_MAX_PRIO nested TCA_ACT attributes. So where can
>> I include it without breaking backward compatibility?
>>
> Not a clean solution but avoids the per action TLV attribute:
> 
> in user space parse_action() you add TCA_ACT_ROOT_FLAGS
> if the user specifies this on the command line.
> 
> in the kernel everything just passes NULL for root_flags
> when invocation is from tcf_exts_validate() i.e both
> tcf_action_init_1() and
> tcf_action_init()
> 
> In tcf_action_init_1(), if root_flags is NULL
> you try to get flags from from tb[TCA_ACT_ROOT_FLAGS]
> 
> Apologies in advance for any latency - I will have time tomorrow.
> 
> cheers,
> jamal


--------------E2C05EFBE1BFA0F760322FFF
Content-Type: text/plain; charset=UTF-8;
 name="patchlet-v2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patchlet-v2"

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2FjdF9hcGkuaCBiL2luY2x1ZGUvbmV0L2FjdF9h
cGkuaAppbmRleCBiMThjNjk5NjgxY2EuLmVjNTJiMjhkZGZjNSAxMDA2NDQKLS0tIGEvaW5j
bHVkZS9uZXQvYWN0X2FwaS5oCisrKyBiL2luY2x1ZGUvbmV0L2FjdF9hcGkuaApAQCAtOTMs
NyArOTMsOCBAQCBzdHJ1Y3QgdGNfYWN0aW9uX29wcyB7CiAJaW50ICAgICAoKmxvb2t1cCko
c3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QgdGNfYWN0aW9uICoqYSwgdTMyIGluZGV4KTsKIAlp
bnQgICAgICgqaW5pdCkoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3QgbmxhdHRyICpubGEsCiAJ
CQlzdHJ1Y3QgbmxhdHRyICplc3QsIHN0cnVjdCB0Y19hY3Rpb24gKiphY3QsIGludCBvdnIs
Ci0JCQlpbnQgYmluZCwgYm9vbCBydG5sX2hlbGQsIHN0cnVjdCB0Y2ZfcHJvdG8gKnRwLAor
CQkJaW50IGJpbmQsIGJvb2wgcnRubF9oZWxkLCBzdHJ1Y3QgbmxhX2JpdGZpZWxkMzIgKnJm
LAorCQkJc3RydWN0IHRjZl9wcm90byAqdHAsCiAJCQlzdHJ1Y3QgbmV0bGlua19leHRfYWNr
ICpleHRhY2spOwogCWludCAgICAgKCp3YWxrKShzdHJ1Y3QgbmV0ICosIHN0cnVjdCBza19i
dWZmICosCiAJCQlzdHJ1Y3QgbmV0bGlua19jYWxsYmFjayAqLCBpbnQsCkBAIC0xNzYsMTAg
KzE3NywxMiBAQCBpbnQgdGNmX2FjdGlvbl9leGVjKHN0cnVjdCBza19idWZmICpza2IsIHN0
cnVjdCB0Y19hY3Rpb24gKiphY3Rpb25zLAogaW50IHRjZl9hY3Rpb25faW5pdChzdHJ1Y3Qg
bmV0ICpuZXQsIHN0cnVjdCB0Y2ZfcHJvdG8gKnRwLCBzdHJ1Y3QgbmxhdHRyICpubGEsCiAJ
CSAgICBzdHJ1Y3QgbmxhdHRyICplc3QsIGNoYXIgKm5hbWUsIGludCBvdnIsIGludCBiaW5k
LAogCQkgICAgc3RydWN0IHRjX2FjdGlvbiAqYWN0aW9uc1tdLCBzaXplX3QgKmF0dHJfc2l6
ZSwKLQkJICAgIGJvb2wgcnRubF9oZWxkLCBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRh
Y2spOworCQkgICAgYm9vbCBydG5sX2hlbGQsIHN0cnVjdCBubGFfYml0ZmllbGQzMiAqcm9v
dF9mbGFncywKKwkJICAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjayk7CiBzdHJ1
Y3QgdGNfYWN0aW9uICp0Y2ZfYWN0aW9uX2luaXRfMShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVj
dCB0Y2ZfcHJvdG8gKnRwLAogCQkJCSAgICBzdHJ1Y3QgbmxhdHRyICpubGEsIHN0cnVjdCBu
bGF0dHIgKmVzdCwKIAkJCQkgICAgY2hhciAqbmFtZSwgaW50IG92ciwgaW50IGJpbmQsCisJ
CQkJICAgIHN0cnVjdCBubGFfYml0ZmllbGQzMiAqcm9vdF9mbGFncywKIAkJCQkgICAgYm9v
bCBydG5sX2hlbGQsCiAJCQkJICAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjayk7
CiBpbnQgdGNmX2FjdGlvbl9kdW1wKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCB0Y19h
Y3Rpb24gKmFjdGlvbnNbXSwgaW50IGJpbmQsCmRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkv
bGludXgvcGt0X2Nscy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3BrdF9jbHMuaAppbmRleCBh
NmFhNDY2ZmFjOWUuLmQ5MmYzZDBmMmM3OSAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2xp
bnV4L3BrdF9jbHMuaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvcGt0X2Nscy5oCkBAIC0x
Niw2ICsxNiw3IEBAIGVudW0gewogCVRDQV9BQ1RfU1RBVFMsCiAJVENBX0FDVF9QQUQsCiAJ
VENBX0FDVF9DT09LSUUsCisJVENBX0FDVF9ST09UX0ZMQUdTLAogCV9fVENBX0FDVF9NQVgK
IH07CiAKZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9hY3RfYXBpLmMgYi9uZXQvc2NoZWQvYWN0
X2FwaS5jCmluZGV4IDY5ZDQ2NzZhNDAyZi4uZWY3YjBiYjczNWM3IDEwMDY0NAotLS0gYS9u
ZXQvc2NoZWQvYWN0X2FwaS5jCisrKyBiL25ldC9zY2hlZC9hY3RfYXBpLmMKQEAgLTg0Miw2
ICs4NDIsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG5sYV9wb2xpY3kgdGNmX2FjdGlvbl9w
b2xpY3lbVENBX0FDVF9NQVggKyAxXSA9IHsKIHN0cnVjdCB0Y19hY3Rpb24gKnRjZl9hY3Rp
b25faW5pdF8xKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsCiAJCQkJ
ICAgIHN0cnVjdCBubGF0dHIgKm5sYSwgc3RydWN0IG5sYXR0ciAqZXN0LAogCQkJCSAgICBj
aGFyICpuYW1lLCBpbnQgb3ZyLCBpbnQgYmluZCwKKwkJCQkgICAgc3RydWN0IG5sYV9iaXRm
aWVsZDMyICpyb290X2ZsYWdzLAogCQkJCSAgICBib29sIHJ0bmxfaGVsZCwKIAkJCQkgICAg
c3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKQogewpAQCAtODUyLDYgKzg1Myw3IEBA
IHN0cnVjdCB0Y19hY3Rpb24gKnRjZl9hY3Rpb25faW5pdF8xKHN0cnVjdCBuZXQgKm5ldCwg
c3RydWN0IHRjZl9wcm90byAqdHAsCiAJc3RydWN0IG5sYXR0ciAqdGJbVENBX0FDVF9NQVgg
KyAxXTsKIAlzdHJ1Y3QgbmxhdHRyICpraW5kOwogCWludCBlcnI7CisJc3RydWN0IG5sYV9i
aXRmaWVsZDMyIHJmID0gezAsIDB9OwogCiAJaWYgKG5hbWUgPT0gTlVMTCkgewogCQllcnIg
PSBubGFfcGFyc2VfbmVzdGVkX2RlcHJlY2F0ZWQodGIsIFRDQV9BQ1RfTUFYLCBubGEsCkBA
IC04ODQsNiArODg2LDEwIEBAIHN0cnVjdCB0Y19hY3Rpb24gKnRjZl9hY3Rpb25faW5pdF8x
KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsCiAJCX0KIAl9CiAKKwlp
ZiAoIXJvb3RfZmxhZ3MgJiYgdGJbVENBX0FDVF9ST09UX0ZMQUdTXSkgeworCQlyZiA9IG5s
YV9nZXRfYml0ZmllbGQzMih0YltUQ0FfQUNUX1JPT1RfRkxBR1NdKTsKKwkJcm9vdF9mbGFn
cyA9ICZyZjsKKwl9CiAJYV9vID0gdGNfbG9va3VwX2FjdGlvbl9uKGFjdF9uYW1lKTsKIAlp
ZiAoYV9vID09IE5VTEwpIHsKICNpZmRlZiBDT05GSUdfTU9EVUxFUwpAQCAtOTE0LDEwICs5
MjAsMTAgQEAgc3RydWN0IHRjX2FjdGlvbiAqdGNmX2FjdGlvbl9pbml0XzEoc3RydWN0IG5l
dCAqbmV0LCBzdHJ1Y3QgdGNmX3Byb3RvICp0cCwKIAkvKiBiYWNrd2FyZCBjb21wYXRpYmls
aXR5IGZvciBwb2xpY2VyICovCiAJaWYgKG5hbWUgPT0gTlVMTCkKIAkJZXJyID0gYV9vLT5p
bml0KG5ldCwgdGJbVENBX0FDVF9PUFRJT05TXSwgZXN0LCAmYSwgb3ZyLCBiaW5kLAotCQkJ
CXJ0bmxfaGVsZCwgdHAsIGV4dGFjayk7CisJCQkJcnRubF9oZWxkLCByb290X2ZsYWdzLCB0
cCwgZXh0YWNrKTsKIAllbHNlCiAJCWVyciA9IGFfby0+aW5pdChuZXQsIG5sYSwgZXN0LCAm
YSwgb3ZyLCBiaW5kLCBydG5sX2hlbGQsCi0JCQkJdHAsIGV4dGFjayk7CisJCQkJcm9vdF9m
bGFncywgdHAsIGV4dGFjayk7CiAJaWYgKGVyciA8IDApCiAJCWdvdG8gZXJyX21vZDsKIApA
QCAtOTU1LDcgKzk2MSw4IEBAIHN0cnVjdCB0Y19hY3Rpb24gKnRjZl9hY3Rpb25faW5pdF8x
KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsCiBpbnQgdGNmX2FjdGlv
bl9pbml0KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsIHN0cnVjdCBu
bGF0dHIgKm5sYSwKIAkJICAgIHN0cnVjdCBubGF0dHIgKmVzdCwgY2hhciAqbmFtZSwgaW50
IG92ciwgaW50IGJpbmQsCiAJCSAgICBzdHJ1Y3QgdGNfYWN0aW9uICphY3Rpb25zW10sIHNp
emVfdCAqYXR0cl9zaXplLAotCQkgICAgYm9vbCBydG5sX2hlbGQsIHN0cnVjdCBuZXRsaW5r
X2V4dF9hY2sgKmV4dGFjaykKKwkJICAgIGJvb2wgcnRubF9oZWxkLCBzdHJ1Y3QgbmxhX2Jp
dGZpZWxkMzIgKnJvb3RfZmxhZ3MsCisJCSAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpl
eHRhY2spCiB7CiAJc3RydWN0IG5sYXR0ciAqdGJbVENBX0FDVF9NQVhfUFJJTyArIDFdOwog
CXN0cnVjdCB0Y19hY3Rpb24gKmFjdDsKQEAgLTk3MCw3ICs5NzcsNyBAQCBpbnQgdGNmX2Fj
dGlvbl9pbml0KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHRjZl9wcm90byAqdHAsIHN0cnVj
dCBubGF0dHIgKm5sYSwKIAogCWZvciAoaSA9IDE7IGkgPD0gVENBX0FDVF9NQVhfUFJJTyAm
JiB0YltpXTsgaSsrKSB7CiAJCWFjdCA9IHRjZl9hY3Rpb25faW5pdF8xKG5ldCwgdHAsIHRi
W2ldLCBlc3QsIG5hbWUsIG92ciwgYmluZCwKLQkJCQkJcnRubF9oZWxkLCBleHRhY2spOwor
CQkJCQlyb290X2ZsYWdzLCBydG5sX2hlbGQsIGV4dGFjayk7CiAJCWlmIChJU19FUlIoYWN0
KSkgewogCQkJZXJyID0gUFRSX0VSUihhY3QpOwogCQkJZ290byBlcnI7CkBAIC0xMzUwLDYg
KzEzNTcsNyBAQCB0Y2ZfYWRkX25vdGlmeShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBubG1z
Z2hkciAqbiwgc3RydWN0IHRjX2FjdGlvbiAqYWN0aW9uc1tdLAogCiBzdGF0aWMgaW50IHRj
Zl9hY3Rpb25fYWRkKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IG5sYXR0ciAqbmxhLAogCQkJ
ICBzdHJ1Y3Qgbmxtc2doZHIgKm4sIHUzMiBwb3J0aWQsIGludCBvdnIsCisJCQkgIHN0cnVj
dCBubGFfYml0ZmllbGQzMiAqcm9vdF9mbGFncywKIAkJCSAgc3RydWN0IG5ldGxpbmtfZXh0
X2FjayAqZXh0YWNrKQogewogCXNpemVfdCBhdHRyX3NpemUgPSAwOwpAQCAtMTM1OCw3ICsx
MzY2LDggQEAgc3RhdGljIGludCB0Y2ZfYWN0aW9uX2FkZChzdHJ1Y3QgbmV0ICpuZXQsIHN0
cnVjdCBubGF0dHIgKm5sYSwKIAogCWZvciAobG9vcCA9IDA7IGxvb3AgPCAxMDsgbG9vcCsr
KSB7CiAJCXJldCA9IHRjZl9hY3Rpb25faW5pdChuZXQsIE5VTEwsIG5sYSwgTlVMTCwgTlVM
TCwgb3ZyLCAwLAotCQkJCSAgICAgIGFjdGlvbnMsICZhdHRyX3NpemUsIHRydWUsIGV4dGFj
ayk7CisJCQkJICAgICAgYWN0aW9ucywgJmF0dHJfc2l6ZSwgdHJ1ZSwgcm9vdF9mbGFncywK
KwkJCQkgICAgICBleHRhY2spOwogCQlpZiAocmV0ICE9IC1FQUdBSU4pCiAJCQlicmVhazsK
IAl9CkBAIC0xMzg1LDYgKzEzOTQsNyBAQCBzdGF0aWMgaW50IHRjX2N0bF9hY3Rpb24oc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5sbXNnaGRyICpuLAogCXN0cnVjdCBuZXQgKm5l
dCA9IHNvY2tfbmV0KHNrYi0+c2spOwogCXN0cnVjdCBubGF0dHIgKnRjYVtUQ0FfUk9PVF9N
QVggKyAxXTsKIAl1MzIgcG9ydGlkID0gc2tiID8gTkVUTElOS19DQihza2IpLnBvcnRpZCA6
IDA7CisJc3RydWN0IG5sYV9iaXRmaWVsZDMyIHJvb3RfZmxhZ3MgPSB7MCwgMH07CiAJaW50
IHJldCA9IDAsIG92ciA9IDA7CiAKIAlpZiAoKG4tPm5sbXNnX3R5cGUgIT0gUlRNX0dFVEFD
VElPTikgJiYKQEAgLTE0MTIsOCArMTQyMiwxMSBAQCBzdGF0aWMgaW50IHRjX2N0bF9hY3Rp
b24oc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5sbXNnaGRyICpuLAogCQkgKi8KIAkJ
aWYgKG4tPm5sbXNnX2ZsYWdzICYgTkxNX0ZfUkVQTEFDRSkKIAkJCW92ciA9IDE7CisJCWlm
ICh0YltUQ0FfUk9PVF9GTEFHU10pCisJCQlyb290X2ZsYWdzID0gbmxhX2dldF9iaXRmaWVs
ZDMyKHRiW1RDQV9ST09UX0ZMQUdTXSk7CisKIAkJcmV0ID0gdGNmX2FjdGlvbl9hZGQobmV0
LCB0Y2FbVENBX0FDVF9UQUJdLCBuLCBwb3J0aWQsIG92ciwKLQkJCQkgICAgIGV4dGFjayk7
CisJCQkJICAgICAmcm9vdF9mbGFncywgZXh0YWNrKTsKIAkJYnJlYWs7CiAJY2FzZSBSVE1f
REVMQUNUSU9OOgogCQlyZXQgPSB0Y2FfYWN0aW9uX2dkKG5ldCwgdGNhW1RDQV9BQ1RfVEFC
XSwgbiwKZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9jbHNfYXBpLmMgYi9uZXQvc2NoZWQvY2xz
X2FwaS5jCmluZGV4IDg3MTdjMGIyNmM5MC4uOWRjNWJmMGQ2MzdlIDEwMDY0NAotLS0gYS9u
ZXQvc2NoZWQvY2xzX2FwaS5jCisrKyBiL25ldC9zY2hlZC9jbHNfYXBpLmMKQEAgLTI5NDYs
NyArMjk0Niw3IEBAIGludCB0Y2ZfZXh0c192YWxpZGF0ZShzdHJ1Y3QgbmV0ICpuZXQsIHN0
cnVjdCB0Y2ZfcHJvdG8gKnRwLCBzdHJ1Y3QgbmxhdHRyICoqdGIsCiAJCQlhY3QgPSB0Y2Zf
YWN0aW9uX2luaXRfMShuZXQsIHRwLCB0YltleHRzLT5wb2xpY2VdLAogCQkJCQkJcmF0ZV90
bHYsICJwb2xpY2UiLCBvdnIsCiAJCQkJCQlUQ0FfQUNUX0JJTkQsIHJ0bmxfaGVsZCwKLQkJ
CQkJCWV4dGFjayk7CisJCQkJCQlOVUxMLCBleHRhY2spOwogCQkJaWYgKElTX0VSUihhY3Qp
KQogCQkJCXJldHVybiBQVFJfRVJSKGFjdCk7CiAKQEAgLTI5NTksNyArMjk1OSw3IEBAIGlu
dCB0Y2ZfZXh0c192YWxpZGF0ZShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCB0Y2ZfcHJvdG8g
KnRwLCBzdHJ1Y3QgbmxhdHRyICoqdGIsCiAJCQllcnIgPSB0Y2ZfYWN0aW9uX2luaXQobmV0
LCB0cCwgdGJbZXh0cy0+YWN0aW9uXSwKIAkJCQkJICAgICAgcmF0ZV90bHYsIE5VTEwsIG92
ciwgVENBX0FDVF9CSU5ELAogCQkJCQkgICAgICBleHRzLT5hY3Rpb25zLCAmYXR0cl9zaXpl
LAotCQkJCQkgICAgICBydG5sX2hlbGQsIGV4dGFjayk7CisJCQkJCSAgICAgIHJ0bmxfaGVs
ZCwgTlVMTCwgZXh0YWNrKTsKIAkJCWlmIChlcnIgPCAwKQogCQkJCXJldHVybiBlcnI7CiAJ
CQlleHRzLT5ucl9hY3Rpb25zID0gZXJyOwo=
--------------E2C05EFBE1BFA0F760322FFF--
