Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AF16C60EB
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 08:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCWHj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 03:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCWHj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 03:39:57 -0400
Received: from mail-m312.qiye.163.com (mail-m312.qiye.163.com [103.74.31.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2CA10CE;
        Thu, 23 Mar 2023 00:39:55 -0700 (PDT)
Received: from ucloud.cn (unknown [127.0.0.1])
        by mail-m312.qiye.163.com (Hmail) with ESMTP id C3F7480354;
        Thu, 23 Mar 2023 15:39:15 +0800 (CST)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AM6AJgA1I0agUTVKvSmG4qrN.3.1679557155794.Hmail.mocan@ucloud.cn>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6UmU6IFtQQVRDSF0gbmV0L25ldF9mYWlsb3ZlcjogZml4IHF1ZXVlIGV4Y2VlZGluZyB3YXJuaW5n?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2015-163.com
X-Originating-IP: 106.75.220.2
In-Reply-To: <7755c026ea1f2c5f6d00aa4ba17233eb511ce3dd.camel@redhat.com>
References: <7755c026ea1f2c5f6d00aa4ba17233eb511ce3dd.camel@redhat.com>
MIME-Version: 1.0
Received: from mocan@ucloud.cn( [106.75.220.2) ] by ajax-webmail ( [127.0.0.1] ) ; Thu, 23 Mar 2023 15:39:15 +0800 (GMT+08:00)
From:   Faicker Mo <faicker.mo@ucloud.cn>
Date:   Thu, 23 Mar 2023 15:39:15 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHkkeVhpITUhOSkgdGB9NS1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUpLTVVMTlVJSUtVSVlXWRYaDxIVHRRZQVlPS0hVSkpLSEpMVUpLS1VLWQY+
X-HM-Sender-Digest: e1kJHlYWEh9ZQUpOSUJCSExPS0NKSjdXWQweGVlBDwkOHldZEh8eFQ9Z
        QVlHOjZNOjEcOkoySxocLi8tMA0oFjxPCgk1VUhVSk1MQk5OTEpOTU5CS1UzFhoSF1UdGhIYEB4J
        VRYUOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVMTlVJSUtVSVlXWQgBWUFPSU5KN1dZFAsPEhQVCFlB
        SzcG
X-HM-Tid: 0a870d0acc0900d2kurm186c125ca63
X-HM-MType: 1
X-Spam-Status: No, score=0.0 required=5.0 tests=MSGID_FROM_MTA_HEADER,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzLiBJIHdpbGwgc2VuZCB0aGUgdjIgZml4IGxhdGVyLgoKWWVzLCB0aGUgYmV0dGVyIG1l
dGhvZCBpcyB0byBsZXQgdGhlIGZhaWxvdmVyIGRldmljZSBmb2xsbG93cyB0aGUgcHJpbWFyeSBk
ZXYKYW5kIHJlbW92ZSB0aGUgd2FybmluZywgYnV0IG1vcmUgd29yayBuZWVkIHRvIGJlIGRvbmUu
CgoKRnJvbTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPgpEYXRlOiAyMDIzLTAzLTIy
IDE5OjQwOjQ0ClRvOiAgRmFpY2tlciBNbyA8ZmFpY2tlci5tb0B1Y2xvdWQuY24+CkNjOiAgU3Jp
ZGhhciBTYW11ZHJhbGEgPHNyaWRoYXIuc2FtdWRyYWxhQGludGVsLmNvbT4sIkRhdmlkIFMuIE1p
bGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+LEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xl
LmNvbT4sSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4sbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZyxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnClN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5l
dC9uZXRfZmFpbG92ZXI6IGZpeCBxdWV1ZSBleGNlZWRpbmcgd2FybmluZz5PbiBUdWUsIDIwMjMt
MDMtMjEgYXQgMTA6MjkgKzA4MDAsIEZhaWNrZXIgTW8gd3JvdGU6Cj4+IElmIHRoZSBwcmltYXJ5
IGRldmljZSBxdWV1ZSBudW1iZXIgaXMgYmlnZ2VyIHRoYW4gdGhlIGRlZmF1bHQgMTYsCj4+IHRo
ZXJlIGlzIGEgd2FybmluZyBhYm91dCB0aGUgcXVldWUgZXhjZWVkaW5nIHdoZW4gdHggZnJvbSB0
aGUKPj4gbmV0X2ZhaWxvdmVyIGRldmljZS4KPj4gCj4+IFNpZ25lZC1vZmYtYnk6IEZhaWNrZXIg
TW8gPGZhaWNrZXIubW9AdWNsb3VkLmNuPgo+Cj5UaGlzIGxvb2tzIGxpa2UgYSBmaXhlcywgc28g
aXQgc2hvdWxkIGluY2x1ZGUgYXQgbGVhc3QgYSBmaXhlcyB0YWcuCj4KPk1vcmUgaW1wb3J0YW50
bHkgYSBsb25nZXIvY2xlYXJlciBkZXNjcmlwdGlvbiBvZiB0aGUgaXNzdWUgaXMgbmVlZGVkLAo+
aW5jbHVkaW5nIHRoZSB3YXJuaW5nIGJhY2t0cmFjZS4KPgo+SSB0aGluayB0aGlzIHdhcm5pbmc6
Cj4KPmh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvaW5jbHVk
ZS9saW51eC9uZXRkZXZpY2UuaCNMMzU0Mgo+Cj5zaG91bGQgbm90IGJlIGlnbm9yZWQvc2lsZW5j
ZWQ6IGl0J3MgdGVsbGluZyB0aGF0IHRoZSBydW5uaW5nCj5jb25maWd1cmF0aW9uIGlzIG5vdCB1
c2luZyBhIG51bWJlciBvZiB0aGUgYXZhaWxhYmxlIHR4IHF1ZXVlcywgd2hpY2gKPmlzIHBvc3Np
Ymx5IG5vdCB0aGUgdGhpbmcgeW91IHdhbnQuCj4KPkluc3RlYWQgdGhlIGZhaWxvdmVyIGRldmlj
ZSBjb3VsZCB1c2UgYW4gaGlnaGVyIG51bWJlciBvZiB0eCBxdWV1ZXMgYW5kCj5ldmVudHVhbGx5
IHNldCByZWFsX251bV90eF9xdWV1ZXMgZXF1YWwgdG8gdGhlIHByaW1hcnlfZGV2IHdoZW4gdGhl
Cj5sYXR0ZXIgaXMgZW5zbGF2ZWQuCj4KPlRoYW5rcywKPgo+UGFvbG8KPgo+Cj4KDQoNCg==
