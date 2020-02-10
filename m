Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E514D157199
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 10:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgBJJZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 04:25:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgBJJZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 04:25:17 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87AA51489E0BF;
        Mon, 10 Feb 2020 01:25:15 -0800 (PST)
Date:   Mon, 10 Feb 2020 10:25:13 +0100 (CET)
Message-Id: <20200210.102513.350862069369965887.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix successful connect() but timed out
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200210083544.31501-1-tuong.t.lien@dektech.com.au>
References: <20200210083544.31501-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Feb 2020 01:25:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVHVvbmcgTGllbiA8dHVvbmcudC5saWVuQGRla3RlY2guY29tLmF1Pg0KRGF0ZTogTW9u
LCAxMCBGZWIgMjAyMCAxNTozNTo0NCArMDcwMA0KDQo+IEluIGNvbW1pdCA5NTQ2YTBiN2NlMDAg
KCJ0aXBjOiBmaXggd3JvbmcgY29ubmVjdCgpIHJldHVybiBjb2RlIiksIHdlDQo+IGZpeGVkIHRo
ZSBpc3N1ZSB3aXRoIHRoZSAnY29ubmVjdCgpJyB0aGF0IHJldHVybnMgemVybyBldmVuIHRob3Vn
aCB0aGUNCj4gY29ubmVjdGluZyBoYXMgZmFpbGVkIGJ5IHdhaXRpbmcgZm9yIHRoZSBjb25uZWN0
aW9uIHRvIGJlICdFU1RBQkxJU0hFRCcNCj4gcmVhbGx5LiBIb3dldmVyLCB0aGUgYXBwcm9hY2gg
aGFzIG9uZSBkcmF3YmFjayBpbiBjb25qdW5jdGlvbiB3aXRoIG91cg0KPiAnbGlnaHR3ZWlnaHQn
IGNvbm5lY3Rpb24gc2V0dXAgbWVjaGFuaXNtIHRoYXQgdGhlIGZvbGxvd2luZyBzY2VuYXJpbw0K
PiBjYW4gaGFwcGVuOg0KIC4uLg0KPiBVcG9uIHRoZSByZWNlaXB0IG9mIHRoZSBzZXJ2ZXIgJ0FD
SycsIHRoZSBjbGllbnQgYmVjb21lcyAnRVNUQUJMSVNIRUQnDQo+IGFuZCB0aGUgJ3dhaXRfZm9y
X2Nvbm4oKScgcHJvY2VzcyBpcyB3b2tlbiB1cCBidXQgbm90IHJ1bi4gTWVhbndoaWxlLA0KPiB0
aGUgc2VydmVyIHN0YXJ0cyB0byBzZW5kIGEgbnVtYmVyIG9mIGRhdGEgZm9sbG93aW5nIGJ5IGEg
J2Nsb3NlKCknDQo+IHNob3J0bHkgd2l0aG91dCB3YWl0aW5nIGFueSByZXNwb25zZSBmcm9tIHRo
ZSBjbGllbnQsIHdoaWNoIHRoZW4gZm9yY2VzDQo+IHRoZSBjbGllbnQgc29ja2V0IHRvIGJlICdE
SVNDT05ORUNUSU5HJyBpbW1lZGlhdGVseS4gV2hlbiB0aGUgd2FpdA0KPiBwcm9jZXNzIGlzIHN3
aXRjaGVkIHRvIGJlIHJ1bm5pbmcsIGl0IGNvbnRpbnVlcyB0byB3YWl0IHVudGlsIHRoZSB0aW1l
cg0KPiBleHBpcmVzIGJlY2F1c2Ugb2YgdGhlIHVuZXhwZWN0ZWQgc29ja2V0IHN0YXRlLiBUaGUg
Y2xpZW50ICdjb25uZWN0KCknDQo+IHdpbGwgZmluYWxseSBnZXQgoS1FVElNRURPVVSiIGFuZCBm
b3JjZSB0byByZWxlYXNlIHRoZSBzb2NrZXQgd2hlcmVhcw0KPiB0aGVyZSByZW1haW5zIHRoZSBt
ZXNzYWdlcyBpbiBpdHMgcmVjZWl2ZSBxdWV1ZS4NCj4gDQo+IE9idmlvdXNseSB0aGUgaXNzdWUg
d291bGQgbm90IGhhcHBlbiBpZiB0aGUgc2VydmVyIGhhZCBzb21lIGRlbGF5IHByaW9yDQo+IHRv
IGl0cyAnY2xvc2UoKScgKG9yIHRoZSBudW1iZXIgb2YgJ0RBVEEnIG1lc3NhZ2VzIGlzIGxhcmdl
IGVub3VnaCksDQo+IGJ1dCBhbnkga2luZCBvZiBkZWxheSB3b3VsZCBtYWtlIHRoZSBjb25uZWN0
aW9uIHNldHVwL3NodXRkb3duICJoZWF2eSIuDQo+IFdlIHNvbHZlIHRoaXMgYnkgc2ltcGx5IGFs
bG93aW5nIHRoZSAnY29ubmVjdCgpJyByZXR1cm5zIHplcm8gaW4gdGhpcw0KPiBwYXJ0aWN1bGFy
IGNhc2UuIFRoZSBzb2NrZXQgaXMgYWxyZWFkeSAnRElTQ09OTkVDVElORycsIHNvIGFueSBmdXJ0
aGVyDQo+IHdyaXRlIHdpbGwgZ2V0ICctRVBJUEUnIGJ1dCB0aGUgc29ja2V0IGlzIHN0aWxsIGFi
bGUgdG8gcmVhZCB0aGUNCj4gbWVzc2FnZXMgZXhpc3RpbmcgaW4gaXRzIHJlY2VpdmUgcXVldWUu
DQo+IA0KPiBOb3RlOiBUaGlzIHNvbHV0aW9uIGRvZXNuJ3QgYnJlYWsgdGhlIHByZXZpb3VzIG9u
ZSBhcyBpdCBkZWFscyB3aXRoIGENCj4gZGlmZmVyZW50IHNpdHVhdGlvbiB0aGF0IHRoZSBzb2Nr
ZXQgc3RhdGUgaXMgJ0RJU0NPTk5FQ1RJTkcnIGJ1dCBoYXMgbm8NCj4gZXJyb3IgKGkuZS4gc2st
PnNrX2VyciA9IDApLg0KPiANCj4gRml4ZXM6IDk1NDZhMGI3Y2UwMCAoInRpcGM6IGZpeCB3cm9u
ZyBjb25uZWN0KCkgcmV0dXJuIGNvZGUiKQ0KPiBBY2tlZC1ieTogWWluZyBYdWUgPHlpbmcueHVl
QHdpbmRyaXZlci5jb20+DQo+IEFja2VkLWJ5OiBKb24gTWFsb3kgPGpvbi5tYWxveUBlcmljc3Nv
bi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFR1b25nIExpZW4gPHR1b25nLnQubGllbkBkZWt0ZWNo
LmNvbS5hdT4NCg0KQXBwbGllZC4NCg==
