Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EA86D84FA
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjDEReS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDEReQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:34:16 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D635FC3;
        Wed,  5 Apr 2023 10:34:13 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id n14so35697310qta.10;
        Wed, 05 Apr 2023 10:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680716053; x=1683308053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=91xrSAGJZ9CpF78jalzLZ0An4C+xQG0wK06zg5Q9bhM=;
        b=DFjoByLeW3xSgganVKbt48AUQ8gq3tt7FUeDS+gkE7Vvc9tr3ZwW+oU8CPTjj6WI0E
         9ddgcI8nexR7mnvkP3cgBhluYKMSEi5Q1jSmfAVtYd2bP/burf1kShz23DVK3/b5p8QL
         m6P1FyNGTWHGpz3rgZcXMQ2gfVrnqwZV02Ucg/RmBu6dtjVg20AYLfXeSOgVHbi73Cyw
         kCUO+15o08Y4gPztgklsfdwKCNRm2oCOjFNGP5c+w4ZCqFBw8EPRf9CdF6cp+bAw6SuP
         AL2jD4lKX/RYjJnDbacUfbnpCZ6QKe+/1vzrxfHdVp/dT5DUZiFnPVISuO3mqTcT3wqy
         RD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680716053; x=1683308053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91xrSAGJZ9CpF78jalzLZ0An4C+xQG0wK06zg5Q9bhM=;
        b=5LWGUTi6Dg1aeb+w3bG9FEWoubqEIgrGg1oAKZq/+Wcu5alMdwkvB/t/UAP22VolXn
         5JrRWTbK9LEr4IyHJz86iYOoqjzoaUZiAT1maQjVrsQz9juMo1BLLX2WmFz+1yuDlxon
         mM0q2ZgGK6oafrEs3h17kKAv/RqP3LRu6gWX9E/hT5B1r8Qqmao8t7CpKeC7Bq8J7roi
         X8taZnc47sm5v9wIg/Oz+MGiFanEYUzkNhIj2mgv9t7bkgcej0otAfFkur6s1pTi7l0p
         g7yv/XnVvZ+3r1m5oEvJm44RAKrkTfvfqvZy+WXuLx1KaXZGGD1Ii4+7BS4uw8zYZtRK
         yjwQ==
X-Gm-Message-State: AAQBX9eTC3CwDhNre0mO+EqkRV5DNsdO/5v/Mljv/GvE/562kcGsaSNT
        AZacyFoc2nzJgIGi8W/5ARaCOyVwOwtkjA==
X-Google-Smtp-Source: AKy350ZSwvPmWlKAkeXROHNK0HBSuMXc+fSio+emLVUsWSV1OyV0OTmkvCyL7paITBbMgRDTbW9qNQ==
X-Received: by 2002:a05:622a:8e:b0:3db:9289:6949 with SMTP id o14-20020a05622a008e00b003db92896949mr5698120qtw.3.1680716052889;
        Wed, 05 Apr 2023 10:34:12 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id dm33-20020a05620a1d6100b0070648cf78bdsm4578581qkb.54.2023.04.05.10.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 10:34:12 -0700 (PDT)
Message-ID: <082e6ff7-6799-fa80-81e2-6f8092f8bb51@gmail.com>
Date:   Wed, 5 Apr 2023 13:34:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: sunhme: move asm includes to below linux
 includes
Content-Language: en-US
To:     Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-m68k@lists.linux-m68k.org
References: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNC81LzIzIDEzOjI5LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+IEEgcmVjZW50IHJlYXJy
YW5nZW1lbnQgb2YgaW5jbHVkZXMgaGFzIGxlYWQgdG8gYSBwcm9ibGVtIG9uIG02OGsNCj4g
YXMgZmxhZ2dlZCBieSB0aGUga2VybmVsIHRlc3Qgcm9ib3QuDQo+IA0KPiBSZXNvbHZlIHRo
aXMgYnkgbW92aW5nIHRoZSBibG9jayBhc20gaW5jbHVkZXMgdG8gYmVsb3cgbGludXggaW5j
bHVkZXMuDQo+IEEgc2lkZSBlZmZlY3QgaSB0aGF0IG5vbi1TcGFyYyBhc20gaW5jbHVkZXMg
YXJlIG5vdyBpbW1lZGlhdGVseQ0KPiBiZWZvcmUgU3BhcmMgYXNtIGluY2x1ZGVzLCB3aGlj
aCBzZWVtcyBuaWNlLg0KPiANCj4gVXNpbmcgc3BhcnNlIHYwLjYuNCBJIHdhcyBhYmxlIHRv
IHJlcHJvZHVjZSB0aGlzIHByb2JsZW0gYXMgZm9sbG93cw0KPiB1c2luZyB0aGUgY29uZmln
IHByb3ZpZGVkIGJ5IHRoZSBrZXJuZWwgdGVzdCByb2JvdDoNCj4gDQo+ICQgd2dldCBodHRw
czovL2Rvd25sb2FkLjAxLm9yZy8wZGF5LWNpL2FyY2hpdmUvMjAyMzA0MDQvMjAyMzA0MDQx
NzQ4LjBzUWM0SzRsLWxrcEBpbnRlbC5jb20vY29uZmlnDQo+ICQgY3AgY29uZmlnIC5jb25m
aWcNCj4gJCBtYWtlIEFSQ0g9bTY4ayBvbGRjb25maWcNCj4gJCBtYWtlIEFSQ0g9bTY4ayBD
PTIgTT1kcml2ZXJzL25ldC9ldGhlcm5ldC9zdW4NCj4gICAgIENDIFtNXSAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc3VuL3N1bmhtZS5vDQo+ICAgSW4gZmlsZSBpbmNsdWRlZCBmcm9tIGRy
aXZlcnMvbmV0L2V0aGVybmV0L3N1bi9zdW5obWUuYzoxOToNCj4gICAuL2FyY2gvbTY4ay9p
bmNsdWRlL2FzbS9pcnEuaDo3ODoxMTogZXJyb3I6IGV4cGVjdGVkIOKAmDvigJkgYmVmb3Jl
IOKAmHZvaWTigJkNCj4gICAgICA3OCB8IGFzbWxpbmthZ2Ugdm9pZCBkb19JUlEoaW50IGly
cSwgc3RydWN0IHB0X3JlZ3MgKnJlZ3MpOw0KPiAgICAgICAgIHwgICAgICAgICAgIF5+fn5+
DQo+ICAgICAgICAgfCAgICAgICAgICAgOw0KPiAgIC4vYXJjaC9tNjhrL2luY2x1ZGUvYXNt
L2lycS5oOjc4OjQwOiB3YXJuaW5nOiDigJhzdHJ1Y3QgcHRfcmVnc+KAmSBkZWNsYXJlZCBp
bnNpZGUgcGFyYW1ldGVyIGxpc3Qgd2lsbCBub3QgYmUgdmlzaWJsZSBvdXRzaWRlIG9mIHRo
aXMgZGVmaW5pdGlvbiBvciBkZWNsYXJhdGlvbg0KPiAgICAgIDc4IHwgYXNtbGlua2FnZSB2
b2lkIGRvX0lSUShpbnQgaXJxLCBzdHJ1Y3QgcHRfcmVncyAqcmVncyk7DQo+ICAgICAgICAg
fCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+DQoNClRo
aXMgc2VlbXMgbGlrZSBhIHByb2JsZW0gd2l0aCB0aGUgaGVhZGVyLiBtNjhrJ3MgYXNtL2ly
cS5oIHNob3VsZCBpbmNsdWRlIGxpbnV4L2ludGVycnVwdC5oIGJlZm9yZSBpdHMgZGVjbGFy
YXRpb25zLg0KDQotLVNlYW4NCg0KPiBDb21waWxlIHRlc3RlZCBvbmx5Lg0KPiANCj4gRml4
ZXM6IDFmZjRmNDJhZWY2MCAoIm5ldDogc3VuaG1lOiBBbHBoYWJldGl6ZSBpbmNsdWRlcyIp
DQo+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4g
TGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvb2Uta2J1aWxkLWFsbC8yMDIzMDQwNDE3
NDguMHNRYzRLNGwtbGtwQGludGVsLmNvbS8NCj4gU2lnbmVkLW9mZi1ieTogU2ltb24gSG9y
bWFuIDxob3Jtc0BrZXJuZWwub3JnPg0KPiAtLS0NCj4gICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9zdW4vc3VuaG1lLmMgfCA3ICsrKystLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3N1bi9zdW5obWUuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N1bi9z
dW5obWUuYw0KPiBpbmRleCBlYzg1YWVmMzViZjkuLmI5MzYxM2NkMTk5NCAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3VuL3N1bmhtZS5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3N1bi9zdW5obWUuYw0KPiBAQCAtMTQsOSArMTQsNiBAQA0KPiAg
ICAqICAgICBhcmd1bWVudCA6IG1hY2FkZHI9MHgwMCwweDEwLDB4MjAsMHgzMCwweDQwLDB4
NTANCj4gICAgKi8NCj4gICANCj4gLSNpbmNsdWRlIDxhc20vYnl0ZW9yZGVyLmg+DQo+IC0j
aW5jbHVkZSA8YXNtL2RtYS5oPg0KPiAtI2luY2x1ZGUgPGFzbS9pcnEuaD4NCj4gICAjaW5j
bHVkZSA8bGludXgvYml0b3BzLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2NyYzMyLmg+DQo+
ICAgI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+DQo+IEBAIC00NSw2ICs0MiwxMCBAQA0KPiAg
ICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC91YWNjZXNz
Lmg+DQo+ICAgDQo+ICsjaW5jbHVkZSA8YXNtL2J5dGVvcmRlci5oPg0KPiArI2luY2x1ZGUg
PGFzbS9kbWEuaD4NCj4gKyNpbmNsdWRlIDxhc20vaXJxLmg+DQo+ICsNCj4gICAjaWZkZWYg
Q09ORklHX1NQQVJDDQo+ICAgI2luY2x1ZGUgPGFzbS9hdXhpby5oPg0KPiAgICNpbmNsdWRl
IDxhc20vaWRwcm9tLmg+DQo+IA0KDQo=
