Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006624F986
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 04:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfFWCYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 22:24:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45187 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFWCYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 22:24:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id z19so2255453pgl.12
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 19:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=XQL8KH/0y/MYrB5gBqSf/mTFOmdMsh82TlV3Muptnqs=;
        b=Z0qG0mq4bZdW5kRBumQAfNo7JmZS+1zet7uhrByDfHTCY0lJ8ejUfMw/Jb/S2nkgnn
         7ZSReYLYPdCCwDRXjhDLs+28Wg3cPEg4UxFTvlFl+vNqaDRKcg0J9FEHmmNtJ59UBdlB
         eA0/92XGjtBl5/DgJscztHWdUEy5CNC0EfPUhB3R1qbFkR6rMLG24bJGAIBcWbb5gMti
         gu/yeVwmtjWazG7hhjeo3PoP9y/XEUCt1XTeUaV9xsuOFEiROIGA846FPdq8gHGK10Qb
         SMRQnBAvhu8Q1ZvYWadzoMzTUVLw4RoMg4VbRKHQ05sx76zHpH+RiIovhnumhZ70S/7c
         ZzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language;
        bh=XQL8KH/0y/MYrB5gBqSf/mTFOmdMsh82TlV3Muptnqs=;
        b=goLP+kb6qXwJgbrKGkhu75A1OL02QM2SlMA7JzON7hM6n8moRLzJqICVGNA4ebWhs2
         iUG2y27bQJ+czFQ/zOWQlyKTB0L4jUaPaM6Eu3OkNwt2k1tSz3GTcL2kps8sNN5zi1Xi
         YewZ4+5pqrVz+KjOG5TiFpNFMmKSNYfv4n60pE+48ePLk+Daj4fiS9C9//ZIByrz050c
         2BmpU1EePQwkfz5YrM8OUzmnqYztkpH156c7820mi8Idez7hf8PbpMdLsF+JzPKlFS+S
         Kc20iRdZqS60lPVj1zD8QkwnWJF/60aPIk+GBTOHcNlqMCyxX3xKo9RLtI1jvchHXwET
         0Ymw==
X-Gm-Message-State: APjAAAUjqDPzcNSmZJou03ptmeBYzavyZ6AndjWJwLC8liQsQR/8ci2z
        9o6lZ44ZkEbg6SDSJ6sgH+CLqzSu
X-Google-Smtp-Source: APXvYqwxq64qTk5UF+6KyTehmMYxOipe3hmxjw8+gbjjXipjf3z1J7vN2wHM0kxfGDutOXY1ipTysw==
X-Received: by 2002:a17:90a:2228:: with SMTP id c37mr16405864pje.9.1561256651227;
        Sat, 22 Jun 2019 19:24:11 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id 1sm6731795pfe.102.2019.06.22.19.24.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 19:24:10 -0700 (PDT)
Subject: Re: [RFC PATCH 0/2] enable broadcom tagging for bcm531x5 switches
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20190618175712.71148-1-b.spranger@linutronix.de>
 <bc932af1-d957-bd40-fa65-ee05b9478ec7@gmail.com>
 <20190619111832.16935a93@mitra>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f1f45e1d-5079-ab24-87d8-99b8c6710a08@gmail.com>
Date:   Sat, 22 Jun 2019 19:24:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190619111832.16935a93@mitra>
Content-Type: multipart/mixed;
 boundary="------------D176783D47549ADEBE3CF121"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------D176783D47549ADEBE3CF121
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit



On 6/19/2019 2:18 AM, Benedikt Spranger wrote:
> On Tue, 18 Jun 2019 11:16:23 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
>> How is that a problem for other machines? Does that lead to some kind
>> of broadcast storm because there are machines that keep trying to
>> respond to ARP solicitations?
> Mirroring broadcast packages on the interface they are coming in, is
> IMHO a poor idea. As a result any switch connected to wan update the
> MAC table and send packages on a port where they do not belong to.
> Just imagine to send a DHCP request. The BPi R1 acts as nearly perfect
> black hole in such a situation.

Fair enough.

> 
>> The few aspects that bother me, not in any particular order, are that:
>>
>> - you might be able to not change anything and just get away with the
>> one line patch below that sets skb->offload_fwd_mark to 1 to indicate
>> to the bridge, not to bother with sending a copy of the packet, since
>> the HW took care of that already
> 
> I can test it, but i like to note that the changed function is not
> executed in case of bcm53125.

Indeed, that won't work, how about implementing port_egress_flood() for
b53? That would make sure that multicast is flooded (as well as unicast)
before the switch port is enslaved into the bridge and this should take
care of both your problem and the lack of multicast flooding once
Broadcom tags are turned on. You might also need to set
skb->fwd_offload_mark accordingly in case you still see duplicate
packets, though that should not happen anymore AFAICT.

Something like this should take care of that (untested). You might have
to explicitly set the IMP port (port 8) in B53_UC_FWD_EN and
B53_MC_FWD_EN, though since you turn on management mode, this may not be
required. I might have some time tomorrow to test that on a Lamobo R1.
-- 
Florian

--------------D176783D47549ADEBE3CF121
Content-Type: text/plain; charset=UTF-8;
 name="b53-egress-floods.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="b53-egress-floods.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX2NvbW1vbi5jIGIvZHJpdmVy
cy9uZXQvZHNhL2I1My9iNTNfY29tbW9uLmMKaW5kZXggYzgwNDBlY2Y0NDI1Li5hNDdmNWJj
NjY3YmQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX2NvbW1vbi5jCisr
KyBiL2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX2NvbW1vbi5jCkBAIC0zNDIsNiArMzQyLDEz
IEBAIHN0YXRpYyB2b2lkIGI1M19zZXRfZm9yd2FyZGluZyhzdHJ1Y3QgYjUzX2RldmljZSAq
ZGV2LCBpbnQgZW5hYmxlKQogCWI1M19yZWFkOChkZXYsIEI1M19DVFJMX1BBR0UsIEI1M19T
V0lUQ0hfQ1RSTCwgJm1nbXQpOwogCW1nbXQgfD0gQjUzX01JSV9EVU1CX0ZXREdfRU47CiAJ
YjUzX3dyaXRlOChkZXYsIEI1M19DVFJMX1BBR0UsIEI1M19TV0lUQ0hfQ1RSTCwgbWdtdCk7
CisKKwkvKiBMb29rIGF0IEI1M19VQ19GV0RfRU4gYW5kIEI1M19NQ19GV0RfRU4gdG8gZGVj
aWRlIHdoZXRoZXIKKwkgKiBmcmFtZXMgc2hvdWxkIGJlIGZsb29lZCBvciBub3QuCisJICov
CisJYjUzX3JlYWQ4KGRldiwgQjUzX0NUUkxfUEFHRSwgQjUzX0lQX01VTFRJQ0FTVF9DVFJM
LCAmbWdtdCk7CisJbWdtdCB8PSBCNTNfVUNfRldEX0VOIHwgQjUzX01DX0ZXRF9FTjsKKwli
NTNfd3JpdGU4KGRldiwgQjUzX0NUUkxfUEFHRSwgQjUzX0lQX01VTFRJQ0FTVF9DVFJMLCBt
Z210KTsKIH0KIAogc3RhdGljIHZvaWQgYjUzX2VuYWJsZV92bGFuKHN0cnVjdCBiNTNfZGV2
aWNlICpkZXYsIGJvb2wgZW5hYmxlLApAQCAtMTc0OCw2ICsxNzU1LDMxIEBAIHZvaWQgYjUz
X2JyX2Zhc3RfYWdlKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQpCiB9CiBFWFBP
UlRfU1lNQk9MKGI1M19icl9mYXN0X2FnZSk7CiAKK2ludCBiNTNfYnJfZWdyZXNzX2Zsb29k
cyhzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LAorCQkJIGJvb2wgdW5pY2FzdCwg
Ym9vbCBtdWx0aWNhc3QpCit7CisJc3RydWN0IGI1M19kZXZpY2UgKmRldiA9IGRzLT5wcml2
OworCXUxNiB1YywgbWM7CisKKwliNTNfcmVhZDE2KGRldiwgQjUzX0NUUkxfUEFHRSwgQjUz
X1VDX0ZXRF9FTiwgJnVjKTsKKwlpZiAodW5pY2FzdCkKKwkJdWMgfD0gQklUKHBvcnQpOwor
CWVsc2UKKwkJdWMgJj0gfkJJVChwb3J0KTsKKwliNTNfd3JpdGUxNihkZXYsIEI1M19DVFJM
X1BBR0UsIEI1M19VQ19GV0RfRU4sIHVjKTsKKworCWI1M19yZWFkMTYoZGV2LCBCNTNfQ1RS
TF9QQUdFLCBCNTNfTUNfRldEX0VOLCAmbWMpOworCWlmIChtdWx0aWNhc3QpCisJCW1jIHw9
IEJJVChwb3J0KTsKKwllbHNlCisJCW1jICY9IH5CSVQocG9ydCk7CisJYjUzX3dyaXRlMTYo
ZGV2LCBCNTNfQ1RSTF9QQUdFLCBCNTNfTUNfRldEX0VOLCBtYyk7CisKKwlyZXR1cm4gMDsK
KworfQorRVhQT1JUX1NZTUJPTChiNTNfYnJfZWdyZXNzX2Zsb29kcyk7CisKIHN0YXRpYyBi
b29sIGI1M19wb3NzaWJsZV9jcHVfcG9ydChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBw
b3J0KQogewogCS8qIEJyb2FkY29tIHN3aXRjaGVzIHdpbGwgYWNjZXB0IGVuYWJsaW5nIEJy
b2FkY29tIHRhZ3Mgb24gdGhlCkBAIC0xOTQ4LDYgKzE5ODAsNyBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IGRzYV9zd2l0Y2hfb3BzIGI1M19zd2l0Y2hfb3BzID0gewogCS5wb3J0X2JyaWRn
ZV9sZWF2ZQk9IGI1M19icl9sZWF2ZSwKIAkucG9ydF9zdHBfc3RhdGVfc2V0CT0gYjUzX2Jy
X3NldF9zdHBfc3RhdGUsCiAJLnBvcnRfZmFzdF9hZ2UJCT0gYjUzX2JyX2Zhc3RfYWdlLAor
CS5wb3J0X2VncmVzc19mbG9vZHMJPSBiNTNfYnJfZWdyZXNzX2Zsb29kcywKIAkucG9ydF92
bGFuX2ZpbHRlcmluZwk9IGI1M192bGFuX2ZpbHRlcmluZywKIAkucG9ydF92bGFuX3ByZXBh
cmUJPSBiNTNfdmxhbl9wcmVwYXJlLAogCS5wb3J0X3ZsYW5fYWRkCQk9IGI1M192bGFuX2Fk
ZCwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX3ByaXYuaCBiL2RyaXZl
cnMvbmV0L2RzYS9iNTMvYjUzX3ByaXYuaAppbmRleCBmMjViYzgwYzRmZmMuLmE3ZGQ4YWNj
MjgxYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfcHJpdi5oCisrKyBi
L2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX3ByaXYuaApAQCAtMzE5LDYgKzMxOSw4IEBAIGlu
dCBiNTNfYnJfam9pbihzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LCBzdHJ1Y3Qg
bmV0X2RldmljZSAqYnJpZGdlKTsKIHZvaWQgYjUzX2JyX2xlYXZlKHN0cnVjdCBkc2Ffc3dp
dGNoICpkcywgaW50IHBvcnQsIHN0cnVjdCBuZXRfZGV2aWNlICpicmlkZ2UpOwogdm9pZCBi
NTNfYnJfc2V0X3N0cF9zdGF0ZShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LCB1
OCBzdGF0ZSk7CiB2b2lkIGI1M19icl9mYXN0X2FnZShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMs
IGludCBwb3J0KTsKK2ludCBiNTNfYnJfZWdyZXNzX2Zsb29kcyhzdHJ1Y3QgZHNhX3N3aXRj
aCAqZHMsIGludCBwb3J0LAorCQkJIGJvb2wgdW5pY2FzdCwgYm9vbCBtdWx0aWNhc3QpOwog
dm9pZCBiNTNfcG9ydF9ldmVudChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0KTsK
IHZvaWQgYjUzX3BoeWxpbmtfdmFsaWRhdGUoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQg
cG9ydCwKIAkJCSAgdW5zaWduZWQgbG9uZyAqc3VwcG9ydGVkLAo=
--------------D176783D47549ADEBE3CF121--
