Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB6223BD7
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388623AbfETPSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:18:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44991 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388502AbfETPSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:18:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id c5so6845045pll.11
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 08:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=PrWl8vI5yhxX2j7R9hGjN7Pn5mO1hfk2T++j2x4tdnc=;
        b=AaGTLOoq7zBKkPDiUq7ytZHlw8i7wVSU2arP+ePJb3uFUnZyY1SxKR9ta8djrNtpZH
         De8lC81NfIzRnmNR9t9/7MF5zIEWhPFU1VTl7mbRz8VBkt7dyAcS4JGAswkEQ+9NUvf1
         Z0m4ylqLmVH05xsUvFLITfHsjxLmnyRDE3rQWXOusnPdf19HFb8BGVDTwohkeAiLmyIy
         KhxrJLWVpxDlC/JXzM+SF1F2Nv5JhqYsXdZt5lehT4TyPdfD0nfVlvcLzzEXn6aPe9I9
         N/NeMkzNAep9Mg11yrINh2pgBBd+lPCEptYvMu3uNLMU3bJPZ8l9Nax6fd5UT/voJqlN
         lT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=PrWl8vI5yhxX2j7R9hGjN7Pn5mO1hfk2T++j2x4tdnc=;
        b=bB/aw/6hzFKdZmlwfPwmbuR+gTltViEl3UfUsxMDY/9YYhQ3gA3btVGx+nIqyuspYj
         6jR87tkaBHWh1iZjbgA0GNTrz+A4ScZ5WtDEwRpi6NlqnUoeNfxbtM4Hk0UTMWUgBrTO
         SGbeDGdCxPrgJo8bceOT4HNYSZkLmtSriTXRYEpCafmm88H7M8PUAI9BODdvlsiR4cOJ
         mi7HTrEAJqB5lPUg//8e6guSycaA/H9psQjGWb44UpJmK9TPG7klqsuz4lvdgy0Z69IZ
         3fcoTfSUqU3o2zV8VRH2dAv13kKt5ymnVnOolcz2Ek/N5Qj6XqiHjYP9Kuv76an2dvFK
         d4RA==
X-Gm-Message-State: APjAAAUxV+/Ge7sweh6HDO+P3p89Xy8otWWuc8mysdm5zZCXyAL1ULvu
        JyUzLFhgtzJOiXvONbj7YLM=
X-Google-Smtp-Source: APXvYqwJPFSOqHnWiz7QOutWkb2GSN4on8/3X6FvKoc3ihY2Q6mx0mO70SCBU0ZY6WJ7CLmAdRCq2Q==
X-Received: by 2002:a17:902:8ec4:: with SMTP id x4mr66181190plo.249.1558365491713;
        Mon, 20 May 2019 08:18:11 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:4813:9811:27e6:a3ed? ([2601:282:800:fd80:4813:9811:27e6:a3ed])
        by smtp.googlemail.com with ESMTPSA id y16sm32289820pfo.133.2019.05.20.08.18.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 08:18:10 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next] ip: add a new parameter -Numeric
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20190520075648.15882-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e2e8ba7-7c80-4d35-9255-c6dac47df4e7@gmail.com>
Date:   Mon, 20 May 2019 09:18:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190520075648.15882-1-liuhangbin@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------2421F8DB8FB7A7857C310E60"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------2421F8DB8FB7A7857C310E60
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 5/20/19 1:56 AM, Hangbin Liu wrote:
> When calles rtnl_dsfield_n2a(), we get the dsfield name from
> /etc/iproute2/rt_dsfield. But different distribution may have
> different names. So add a new parameter '-Numeric' to only show
> the dsfield number.
> 
> This parameter is only used for tos value at present. We could enable
> this for other fields if needed in the future.
> 

It does not make sense to add this flag just for 1 field.

3 years ago I started a patch to apply this across the board. never
finished it. see attached. The numeric variable should be moved to
lib/rt_names.c. It handles all of the conversions in that file - at
least as of May 2016.

--------------2421F8DB8FB7A7857C310E60
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="iproute-numeric.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="iproute-numeric.patch"

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdXRpbHMuaCBiL2luY2x1ZGUvdXRpbHMuaAppbmRleCAy
YzY5MDQxN2I3MjEuLjMxYzllNzkyZjhiZCAxMDA2NDQKLS0tIGEvaW5jbHVkZS91dGlscy5o
CisrKyBiL2luY2x1ZGUvdXRpbHMuaApAQCAtMjYsNiArMjYsNyBAQCBleHRlcm4gY29uc3Qg
Y2hhciAqIF9TTF87CiBleHRlcm4gaW50IG1heF9mbHVzaF9sb29wczsKIGV4dGVybiBpbnQg
YmF0Y2hfbW9kZTsKIGV4dGVybiBib29sIGRvX2FsbDsKK2V4dGVybiBpbnQgbnVtZXJpYzsK
IAogI2lmbmRlZiBJUFBST1RPX0VTUAogI2RlZmluZSBJUFBST1RPX0VTUAk1MApkaWZmIC0t
Z2l0IGEvaXAvaXAuYyBiL2lwL2lwLmMKaW5kZXggZWVhMDBiODIyMDg4Li45OTVjMmRhZWQ5
NjUgMTAwNjQ0Ci0tLSBhL2lwL2lwLmMKKysrIGIvaXAvaXAuYwpAQCAtMzksNiArMzksNyBA
QCBpbnQgZm9yY2U7CiBpbnQgbWF4X2ZsdXNoX2xvb3BzID0gMTA7CiBpbnQgYmF0Y2hfbW9k
ZTsKIGJvb2wgZG9fYWxsOworaW50IG51bWVyaWM7CiAKIHN0cnVjdCBydG5sX2hhbmRsZSBy
dGggPSB7IC5mZCA9IC0xIH07CiAKQEAgLTIzNiwxMCArMjM3LDggQEAgaW50IG1haW4oaW50
IGFyZ2MsIGNoYXIgKiphcmd2KQogCQl9IGVsc2UgaWYgKG1hdGNoZXMob3B0LCAiLXRzaG9y
dCIpID09IDApIHsKIAkJCSsrdGltZXN0YW1wOwogCQkJKyt0aW1lc3RhbXBfc2hvcnQ7Ci0j
aWYgMAogCQl9IGVsc2UgaWYgKG1hdGNoZXMob3B0LCAiLW51bWVyaWMiKSA9PSAwKSB7Ci0J
CQlydG5sX25hbWVzX251bWVyaWMrKzsKLSNlbmRpZgorCQkJbnVtZXJpYysrOwogCQl9IGVs
c2UgaWYgKG1hdGNoZXMob3B0LCAiLVZlcnNpb24iKSA9PSAwKSB7CiAJCQlwcmludGYoImlw
IHV0aWxpdHksIGlwcm91dGUyLXNzJXNcbiIsIFNOQVBTSE9UKTsKIAkJCWV4aXQoMCk7CmRp
ZmYgLS1naXQgYS9saWIvcnRfbmFtZXMuYyBiL2xpYi9ydF9uYW1lcy5jCmluZGV4IGY2OGU5
MWQ2ZDA0Ni4uODYwNjZlYzJkZjJjIDEwMDY0NAotLS0gYS9saWIvcnRfbmFtZXMuYworKysg
Yi9saWIvcnRfbmFtZXMuYwpAQCAtMjEsNiArMjEsNyBAQAogCiAjaW5jbHVkZSA8YXNtL3R5
cGVzLmg+CiAjaW5jbHVkZSA8bGludXgvcnRuZXRsaW5rLmg+CisjaW5jbHVkZSA8dXRpbHMu
aD4KIAogI2luY2x1ZGUgInJ0X25hbWVzLmgiCiAKQEAgLTE1MSw3ICsxNTIsNyBAQCBzdGF0
aWMgdm9pZCBydG5sX3J0cHJvdF9pbml0aWFsaXplKHZvaWQpCiAKIGNvbnN0IGNoYXIgKiBy
dG5sX3J0cHJvdF9uMmEoaW50IGlkLCBjaGFyICpidWYsIGludCBsZW4pCiB7Ci0JaWYgKGlk
PDAgfHwgaWQ+PTI1NikgeworCWlmIChpZDwwIHx8IGlkPj0yNTYgfHwgbnVtZXJpYykgewog
CQlzbnByaW50ZihidWYsIGxlbiwgIiV1IiwgaWQpOwogCQlyZXR1cm4gYnVmOwogCX0KQEAg
LTIxNiw3ICsyMTcsNyBAQCBzdGF0aWMgdm9pZCBydG5sX3J0c2NvcGVfaW5pdGlhbGl6ZSh2
b2lkKQogCiBjb25zdCBjaGFyICpydG5sX3J0c2NvcGVfbjJhKGludCBpZCwgY2hhciAqYnVm
LCBpbnQgbGVuKQogewotCWlmIChpZDwwIHx8IGlkPj0yNTYpIHsKKwlpZiAoaWQ8MCB8fCBp
ZD49MjU2IHx8IG51bWVyaWMpIHsKIAkJc25wcmludGYoYnVmLCBsZW4sICIlZCIsIGlkKTsK
IAkJcmV0dXJuIGJ1ZjsKIAl9CkBAIC0yNzgsNyArMjc5LDcgQEAgc3RhdGljIHZvaWQgcnRu
bF9ydHJlYWxtX2luaXRpYWxpemUodm9pZCkKIAogY29uc3QgY2hhciAqcnRubF9ydHJlYWxt
X24yYShpbnQgaWQsIGNoYXIgKmJ1ZiwgaW50IGxlbikKIHsKLQlpZiAoaWQ8MCB8fCBpZD49
MjU2KSB7CisJaWYgKGlkPDAgfHwgaWQ+PTI1NiB8fCBudW1lcmljKSB7CiAJCXNucHJpbnRm
KGJ1ZiwgbGVuLCAiJWQiLCBpZCk7CiAJCXJldHVybiBidWY7CiAJfQpAQCAtMzgwLDcgKzM4
MSw3IEBAIGNvbnN0IGNoYXIgKiBydG5sX3J0dGFibGVfbjJhKF9fdTMyIGlkLCBjaGFyICpi
dWYsIGludCBsZW4pCiB7CiAJc3RydWN0IHJ0bmxfaGFzaF9lbnRyeSAqZW50cnk7CiAKLQlp
ZiAoaWQgPiBSVF9UQUJMRV9NQVgpIHsKKwlpZiAoaWQgPiBSVF9UQUJMRV9NQVggfHwgbnVt
ZXJpYykgewogCQlzbnByaW50ZihidWYsIGxlbiwgIiV1IiwgaWQpOwogCQlyZXR1cm4gYnVm
OwogCX0KQEAgLTQ0Niw3ICs0NDcsNyBAQCBzdGF0aWMgdm9pZCBydG5sX3J0ZHNmaWVsZF9p
bml0aWFsaXplKHZvaWQpCiAKIGNvbnN0IGNoYXIgKnJ0bmxfZHNmaWVsZF9uMmEoaW50IGlk
LCBjaGFyICpidWYsIGludCBsZW4pCiB7Ci0JaWYgKGlkPDAgfHwgaWQ+PTI1NikgeworCWlm
IChpZDwwIHx8IGlkPj0yNTYgfHwgbnVtZXJpYykgewogCQlzbnByaW50ZihidWYsIGxlbiwg
IiVkIiwgaWQpOwogCQlyZXR1cm4gYnVmOwogCX0KQEAgLTU0OSw2ICs1NTAsMTEgQEAgY29u
c3QgY2hhciAqcnRubF9ncm91cF9uMmEoaW50IGlkLCBjaGFyICpidWYsIGludCBsZW4pCiAJ
c3RydWN0IHJ0bmxfaGFzaF9lbnRyeSAqZW50cnk7CiAJaW50IGk7CiAKKwlpZiAobnVtZXJp
YykgeworCQlzbnByaW50ZihidWYsIGxlbiwgIiVkIiwgaWQpOworCQlyZXR1cm4gYnVmOwor
CX0KKwogCWlmICghcnRubF9ncm91cF9pbml0KQogCQlydG5sX2dyb3VwX2luaXRpYWxpemUo
KTsKIApAQCAtNTk4LDcgKzYwNCw3IEBAIHN0YXRpYyB2b2lkIG5sX3Byb3RvX2luaXRpYWxp
emUodm9pZCkKIAogY29uc3QgY2hhciAqbmxfcHJvdG9fbjJhKGludCBpZCwgY2hhciAqYnVm
LCBpbnQgbGVuKQogewotCWlmIChpZCA8IDAgfHwgaWQgPj0gMjU2KSB7CisJaWYgKGlkIDwg
MCB8fCBpZCA+PSAyNTYgfHwgbnVtZXJpYykgewogCQlzbnByaW50ZihidWYsIGxlbiwgIiV1
IiwgaWQpOwogCQlyZXR1cm4gYnVmOwogCX0KZGlmZiAtLWdpdCBhL21pc2MvcnRhY2N0LmMg
Yi9taXNjL3J0YWNjdC5jCmluZGV4IGJiOGM5MGY5OGY1YS4uYWNlY2NlMGMzZWNjIDEwMDY0
NAotLS0gYS9taXNjL3J0YWNjdC5jCisrKyBiL21pc2MvcnRhY2N0LmMKQEAgLTQyLDYgKzQy
LDcgQEAgaW50IHRpbWVfY29uc3RhbnQgPSAwOwogaW50IGR1bXBfemVyb3MgPSAwOwogdW5z
aWduZWQgbG9uZyBtYWdpY19udW1iZXIgPSAwOwogZG91YmxlIFc7CitpbnQgbnVtZXJpYzsK
IAogc3RhdGljIGludCBnZW5lcmljX3Byb2Nfb3Blbihjb25zdCBjaGFyICplbnYsIGNvbnN0
IGNoYXIgKm5hbWUpCiB7CmRpZmYgLS1naXQgYS9taXNjL3NzLmMgYi9taXNjL3NzLmMKaW5k
ZXggZWNhNGFhMzVmYWNjLi5jNjQyOGNjMmYxOWIgMTAwNjQ0Ci0tLSBhL21pc2Mvc3MuYwor
KysgYi9taXNjL3NzLmMKQEAgLTg3LDcgKzg3LDYgQEAgc3RhdGljIGludCBzZWN1cml0eV9n
ZXRfaW5pdGlhbF9jb250ZXh0KGNoYXIgKm5hbWUsICBjaGFyICoqY29udGV4dCkKICNlbmRp
ZgogCiBpbnQgcmVzb2x2ZV9ob3N0cyA9IDA7Ci1pbnQgcmVzb2x2ZV9zZXJ2aWNlcyA9IDE7
CiBpbnQgcHJlZmVycmVkX2ZhbWlseSA9IEFGX1VOU1BFQzsKIGludCBzaG93X29wdGlvbnMg
PSAwOwogaW50IHNob3dfZGV0YWlscyA9IDA7CkBAIC0xMDAsNiArOTksNyBAQCBpbnQgc2hv
d19zb2NrX2N0eCA9IDA7CiAvKiBJZiBzaG93X3VzZXJzICYgc2hvd19wcm9jX2N0eCBvbmx5
IGRvIHVzZXJfZW50X2hhc2hfYnVpbGQoKSBvbmNlICovCiBpbnQgdXNlcl9lbnRfaGFzaF9i
dWlsZF9pbml0ID0gMDsKIGludCBmb2xsb3dfZXZlbnRzID0gMDsKK2ludCBudW1lcmljOwog
CiBpbnQgbmV0aWRfd2lkdGg7CiBpbnQgc3RhdGVfd2lkdGg7CkBAIC05NjMsNyArOTYzLDcg
QEAgc3RhdGljIGNvbnN0IGNoYXIgKnJlc29sdmVfc2VydmljZShpbnQgcG9ydCkKIAkJcmV0
dXJuIGJ1ZjsKIAl9CiAKLQlpZiAoIXJlc29sdmVfc2VydmljZXMpCisJaWYgKG51bWVyaWMp
CiAJCWdvdG8gZG9fbnVtZXJpYzsKIAogCWlmIChkZ19wcm90byA9PSBSQVdfUFJPVE8pCkBA
IC0zMDc2LDE0ICszMDc2LDExIEBAIHN0YXRpYyBpbnQgbmV0bGlua19zaG93X29uZShzdHJ1
Y3QgZmlsdGVyICpmLAogCiAJc29ja19zdGF0ZV9wcmludCgmc3QsICJubCIpOwogCi0JaWYg
KHJlc29sdmVfc2VydmljZXMpCi0JCXByb3RfbmFtZSA9IG5sX3Byb3RvX24yYShwcm90LCBw
cm90X2J1Ziwgc2l6ZW9mKHByb3RfYnVmKSk7Ci0JZWxzZQotCQlwcm90X25hbWUgPSBpbnRf
dG9fc3RyKHByb3QsIHByb3RfYnVmKTsKKwlwcm90X25hbWUgPSBubF9wcm90b19uMmEocHJv
dCwgcHJvdF9idWYsIHNpemVvZihwcm90X2J1ZikpOwogCiAJaWYgKHBpZCA9PSAtMSkgewog
CQlwcm9jbmFtZVswXSA9ICcqJzsKLQl9IGVsc2UgaWYgKHJlc29sdmVfc2VydmljZXMpIHsK
Kwl9IGVsc2UgaWYgKCFudW1lcmljKSB7CiAJCWludCBkb25lID0gMDsKIAkJaWYgKCFwaWQp
IHsKIAkJCWRvbmUgPSAxOwpAQCAtMzU5Miw3ICszNTg5LDcgQEAgaW50IG1haW4oaW50IGFy
Z2MsIGNoYXIgKmFyZ3ZbXSkKIAkJCQkgbG9uZ19vcHRzLCBOVUxMKSkgIT0gRU9GKSB7CiAJ
CXN3aXRjaChjaCkgewogCQljYXNlICduJzoKLQkJCXJlc29sdmVfc2VydmljZXMgPSAwOwor
CQkJbnVtZXJpYyA9IDE7CiAJCQlicmVhazsKIAkJY2FzZSAncic6CiAJCQlyZXNvbHZlX2hv
c3RzID0gMTsKQEAgLTM4MTQsNyArMzgxMSw3IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFy
ICphcmd2W10pCiAJZmlsdGVyX3N0YXRlc19zZXQoJmN1cnJlbnRfZmlsdGVyLCBzdGF0ZV9m
aWx0ZXIpOwogCWZpbHRlcl9tZXJnZV9kZWZhdWx0cygmY3VycmVudF9maWx0ZXIpOwogCi0J
aWYgKHJlc29sdmVfc2VydmljZXMgJiYgcmVzb2x2ZV9ob3N0cyAmJgorCWlmICghbnVtZXJp
YyAmJiByZXNvbHZlX2hvc3RzICYmCiAJICAgIChjdXJyZW50X2ZpbHRlci5kYnMmKFVOSVhf
REJNfCgxPDxUQ1BfREIpfCgxPDxVRFBfREIpfCgxPDxEQ0NQX0RCKSkpKQogCQlpbml0X3Nl
cnZpY2VfcmVzb2x2ZXIoKTsKIApAQCAtMzg4Niw3ICszODgzLDcgQEAgaW50IG1haW4oaW50
IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkKIAlhZGRycF93aWR0aCAvPSAyOwogCWFkZHJwX3dpZHRo
LS07CiAKLQlzZXJ2X3dpZHRoID0gcmVzb2x2ZV9zZXJ2aWNlcyA/IDcgOiA1OworCXNlcnZf
d2lkdGggPSAhbnVtZXJpYyA/IDcgOiA1OwogCiAJaWYgKGFkZHJwX3dpZHRoIDwgMTUrc2Vy
dl93aWR0aCsxKQogCQlhZGRycF93aWR0aCA9IDE1K3NlcnZfd2lkdGgrMTsKZGlmZiAtLWdp
dCBhL3RjL3RjLmMgYi90Yy90Yy5jCmluZGV4IDQ2ZmYzNzE0YTJlOS4uZjIzNzk0ZjAzMDA1
IDEwMDY0NAotLS0gYS90Yy90Yy5jCisrKyBiL3RjL3RjLmMKQEAgLTQyLDYgKzQyLDcgQEAg
aW50IHJlc29sdmVfaG9zdHMgPSAwOwogaW50IHVzZV9pZWMgPSAwOwogaW50IGZvcmNlID0g
MDsKIGJvb2wgdXNlX25hbWVzID0gZmFsc2U7CitpbnQgbnVtZXJpYzsKIAogc3RhdGljIGNo
YXIgKmNvbmZfZmlsZTsKIAo=
--------------2421F8DB8FB7A7857C310E60--
