Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6603A0759
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhFHXCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhFHXCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 19:02:30 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FCEC061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 16:00:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C1EB54D2DFB12;
        Tue,  8 Jun 2021 16:00:32 -0700 (PDT)
Date:   Tue, 08 Jun 2021 16:00:28 -0700 (PDT)
Message-Id: <20210608.160028.2094273846699936083.davem@davemloft.net>
To:     m.chetan.kumar@intel.com
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: Re: [PATCH V4 00/16] net: iosm: PCIe Driver for Intel M.2 Modem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210608170449.28031-1-m.chetan.kumar@intel.com>
References: <20210608170449.28031-1-m.chetan.kumar@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Jun 2021 16:00:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpQbGVhc2UgZml4IHRoZXNlIGJ1aWxkIGZhaWx1cmVzLCB0aGFuayB5b3U6DQoNCmRyaXZlcnMv
bmV0L3d3YW4vaW9zbS9pb3NtX2lwY193d2FuLmM6MjMxOjIxOiBlcnJvcjogdmFyaWFibGUgoWlv
c21fd3dhbl9vcHOiIGhhcyBpbml0aWFsaXplciBidXQgaW5jb21wbGV0ZSB0eXBlDQogIDIzMSB8
IHN0YXRpYyBjb25zdCBzdHJ1Y3Qgd3dhbl9vcHMgaW9zbV93d2FuX29wcyA9IHsNCiAgICAgIHwg
ICAgICAgICAgICAgICAgICAgICBefn5+fn5+fg0KZHJpdmVycy9uZXQvd3dhbi9pb3NtL2lvc21f
aXBjX3d3YW4uYzoyMzI6MzogZXJyb3I6IKFjb25zdCBzdHJ1Y3Qgd3dhbl9vcHOiIGhhcyBubyBt
ZW1iZXIgbmFtZWQgoXByaXZfc2l6ZaINCiAgMjMyIHwgIC5wcml2X3NpemUgPSBzaXplb2Yoc3Ry
dWN0IGlvc21fbmV0ZGV2X3ByaXYpLA0KICAgICAgfCAgIF5+fn5+fn5+fg0KZHJpdmVycy9uZXQv
d3dhbi9pb3NtL2lvc21faXBjX3d3YW4uYzoyMzI6MTU6IHdhcm5pbmc6IGV4Y2VzcyBlbGVtZW50
cyBpbiBzdHJ1Y3QgaW5pdGlhbGl6ZXINCiAgMjMyIHwgIC5wcml2X3NpemUgPSBzaXplb2Yoc3Ry
dWN0IGlvc21fbmV0ZGV2X3ByaXYpLA0KICAgICAgfCAgICAgICAgICAgICAgIF5+fn5+fg0KZHJp
dmVycy9uZXQvd3dhbi9pb3NtL2lvc21faXBjX3d3YW4uYzoyMzI6MTU6IG5vdGU6IChuZWFyIGlu
aXRpYWxpemF0aW9uIGZvciChaW9zbV93d2FuX29wc6IpDQpkcml2ZXJzL25ldC93d2FuL2lvc20v
aW9zbV9pcGNfd3dhbi5jOjIzMzozOiBlcnJvcjogoWNvbnN0IHN0cnVjdCB3d2FuX29wc6IgaGFz
IG5vIG1lbWJlciBuYW1lZCChc2V0dXCiDQogIDIzMyB8ICAuc2V0dXAgPSBpcGNfd3dhbl9zZXR1
cCwNCiAgICAgIHwgICBefn5+fg0KZHJpdmVycy9uZXQvd3dhbi9pb3NtL2lvc21faXBjX3d3YW4u
YzoyMzM6MTE6IHdhcm5pbmc6IGV4Y2VzcyBlbGVtZW50cyBpbiBzdHJ1Y3QgaW5pdGlhbGl6ZXIN
CiAgMjMzIHwgIC5zZXR1cCA9IGlwY193d2FuX3NldHVwLA0KICAgICAgfCAgICAgICAgICAgXn5+
fn5+fn5+fn5+fn4NCmRyaXZlcnMvbmV0L3d3YW4vaW9zbS9pb3NtX2lwY193d2FuLmM6MjMzOjEx
OiBub3RlOiAobmVhciBpbml0aWFsaXphdGlvbiBmb3IgoWlvc21fd3dhbl9vcHOiKQ0KZHJpdmVy
cy9uZXQvd3dhbi9pb3NtL2lvc21faXBjX3d3YW4uYzoyMzQ6MzogZXJyb3I6IKFjb25zdCBzdHJ1
Y3Qgd3dhbl9vcHOiIGhhcyBubyBtZW1iZXIgbmFtZWQgoW5ld2xpbmuiDQogIDIzNCB8ICAubmV3
bGluayA9IGlwY193d2FuX25ld2xpbmssDQogICAgICB8ICAgXn5+fn5+fg0KZHJpdmVycy9uZXQv
d3dhbi9pb3NtL2lvc21faXBjX3d3YW4uYzoyMzQ6MTM6IHdhcm5pbmc6IGV4Y2VzcyBlbGVtZW50
cyBpbiBzdHJ1Y3QgaW5pdGlhbGl6ZXINCiAgMjM0IHwgIC5uZXdsaW5rID0gaXBjX3d3YW5fbmV3
bGluaywNCiAgICAgIHwgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fg0KZHJpdmVycy9uZXQv
d3dhbi9pb3NtL2lvc21faXBjX3d3YW4uYzoyMzQ6MTM6IG5vdGU6IChuZWFyIGluaXRpYWxpemF0
aW9uIGZvciChaW9zbV93d2FuX29wc6IpDQpkcml2ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNf
d3dhbi5jOjIzNTozOiBlcnJvcjogoWNvbnN0IHN0cnVjdCB3d2FuX29wc6IgaGFzIG5vIG1lbWJl
ciBuYW1lZCChZGVsbGlua6INCiAgMjM1IHwgIC5kZWxsaW5rID0gaXBjX3d3YW5fZGVsbGluaywN
CiAgICAgIHwgICBefn5+fn5+DQpkcml2ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNfd3dhbi5j
OjIzNToxMzogd2FybmluZzogZXhjZXNzIGVsZW1lbnRzIGluIHN0cnVjdCBpbml0aWFsaXplcg0K
ICAyMzUgfCAgLmRlbGxpbmsgPSBpcGNfd3dhbl9kZWxsaW5rLA0KICAgICAgfCAgICAgICAgICAg
ICBefn5+fn5+fn5+fn5+fn5+DQpkcml2ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNfd3dhbi5j
OjIzNToxMzogbm90ZTogKG5lYXIgaW5pdGlhbGl6YXRpb24gZm9yIKFpb3NtX3d3YW5fb3BzoikN
CmRyaXZlcnMvbmV0L3d3YW4vaW9zbS9pb3NtX2lwY193d2FuLmM6IEluIGZ1bmN0aW9uIKFpcGNf
d3dhbl9pbml0ojoNCmRyaXZlcnMvbmV0L3d3YW4vaW9zbS9pb3NtX2lwY193d2FuLmM6MzE5OjY6
IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbiChd3dhbl9yZWdpc3Rlcl9v
cHOiIFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KICAzMTkgfCAgaWYg
KHd3YW5fcmVnaXN0ZXJfb3BzKGlwY193d2FuLT5kZXYsICZpb3NtX3d3YW5fb3BzLCBpcGNfd3dh
bikpIHsNCiAgICAgIHwgICAgICBefn5+fn5+fn5+fn5+fn5+fg0KZHJpdmVycy9uZXQvd3dhbi9p
b3NtL2lvc21faXBjX3d3YW4uYzogSW4gZnVuY3Rpb24goWlwY193d2FuX2RlaW5pdKI6DQpkcml2
ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNfd3dhbi5jOjMzMzoyOiBlcnJvcjogaW1wbGljaXQg
ZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24goXd3YW5fdW5yZWdpc3Rlcl9vcHOiIFstV2Vycm9yPWlt
cGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KICAzMzMgfCAgd3dhbl91bnJlZ2lzdGVyX29w
cyhpcGNfd3dhbi0+ZGV2KTsNCiAgICAgIHwgIF5+fn5+fn5+fn5+fn5+fn5+fn4NCmRyaXZlcnMv
bmV0L3d3YW4vaW9zbS9pb3NtX2lwY193d2FuLmM6IEF0IHRvcCBsZXZlbDoNCmRyaXZlcnMvbmV0
L3d3YW4vaW9zbS9pb3NtX2lwY193d2FuLmM6MjMxOjMwOiBlcnJvcjogc3RvcmFnZSBzaXplIG9m
IKFpb3NtX3d3YW5fb3BzoiBpc26idCBrbm93bg0KICAyMzEgfCBzdGF0aWMgY29uc3Qgc3RydWN0
IHd3YW5fb3BzIGlvc21fd3dhbl9vcHMgPSB7DQogICAgICB8ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXn5+fn5+fn5+fn5+fg0KY2MxOiBzb21lIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQg
YXMgZXJyb3JzDQptYWtlWzRdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6MjcyOiBkcml2
ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNfd3dhbi5vXSBFcnJvciAxDQptYWtlWzRdOiAqKiog
V2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2JzLi4uLg0KbWFrZVszXTogKioqIFtzY3JpcHRzL01h
a2VmaWxlLmJ1aWxkOjUxNTogZHJpdmVycy9uZXQvd3dhbi9pb3NtXSBFcnJvciAyDQptYWtlWzJd
OiAqKiogW3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6NTE1OiBkcml2ZXJzL25ldC93d2FuXSBFcnJv
ciAyDQptYWtlWzJdOiAqKiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2JzLi4uLg0KbWFrZVsx
XTogKioqIFtzY3JpcHRzL01ha2VmaWxlLmJ1aWxkOjUxNTogZHJpdmVycy9uZXRdIEVycm9yIDIN
Cm1ha2VbMV06ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpvYnMuLi4uDQo=
