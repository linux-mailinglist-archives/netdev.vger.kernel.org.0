Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7892CB4CBD
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 13:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfIQLW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 07:22:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:39092 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbfIQLW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 07:22:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 77CF8B0E6;
        Tue, 17 Sep 2019 11:22:54 +0000 (UTC)
Message-ID: <1568719373.23075.4.camel@suse.com>
Subject: Re: divide error in usbnet_update_max_qlen
From:   Oliver Neukum <oneukum@suse.com>
To:     syzbot <syzbot+6102c120be558c885f04@syzkaller.appspotmail.com>,
        davem@davemloft.net, andreyknvl@google.com,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 17 Sep 2019 13:22:53 +0200
In-Reply-To: <000000000000b83b550592ab965b@google.com>
References: <000000000000b83b550592ab965b@google.com>
Content-Type: multipart/mixed; boundary="=-Yd95Qj5bjthxkmik5dv9"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-Yd95Qj5bjthxkmik5dv9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Am Montag, den 16.09.2019, 06:29 -0700 schrieb syzbot:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    f0df5c1b usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=117659fa600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5c6633fa4ed00be5
> dashboard link: https://syzkaller.appspot.com/bug?extid=6102c120be558c885f04
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12107ba9600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146014e6600000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6102c120be558c885f04@syzkaller.appspotmail.com

#syz test: https://github.com/google/kasan.git f0df5c1b
--=-Yd95Qj5bjthxkmik5dv9
Content-Disposition: attachment; filename="0001-usbnet-sanity-checking-of-packet-sizes.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-usbnet-sanity-checking-of-packet-sizes.patch";
	charset="UTF-8"

RnJvbSA1N2MyNDQzYjJhNzY3OGE2ZjdmNjQzN2Y3NDFmNDlmMDZhNTEwNGZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBUdWUsIDE3IFNlcCAyMDE5IDExOjUxOjU1ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gdXNibmV0
OiBzYW5pdHkgY2hlY2tpbmcgb2YgcGFja2V0IHNpemVzCgpNYWxpY2lvdXMgZGV2aWNlcyBjYW4g
c2V0IHRoaXMgdG8gemVybyBhbmQgd2UgZGl2aWRlIGJ5IGl0LgpJbnRyb2R1Y2Ugc2FuaXR5IGNo
ZWNraW5nLgoKU2lnbmVkLW9mZi1ieTogT2xpdmVyIE5ldWt1bSA8b25ldWt1bUBzdXNlLmNvbT4K
LS0tCiBkcml2ZXJzL25ldC91c2IvdXNibmV0LmMgfCAzICsrKwogMSBmaWxlIGNoYW5nZWQsIDMg
aW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi91c2JuZXQuYyBiL2Ry
aXZlcnMvbmV0L3VzYi91c2JuZXQuYwppbmRleCA1ODk1MmE3OWIwNWYuLmU0NDg0OTQ5OWI4OSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jCisrKyBiL2RyaXZlcnMvbmV0L3Vz
Yi91c2JuZXQuYwpAQCAtMzM5LDYgKzMzOSw4IEBAIHZvaWQgdXNibmV0X3VwZGF0ZV9tYXhfcWxl
bihzdHJ1Y3QgdXNibmV0ICpkZXYpCiB7CiAJZW51bSB1c2JfZGV2aWNlX3NwZWVkIHNwZWVkID0g
ZGV2LT51ZGV2LT5zcGVlZDsKIAorCWlmICghZGV2LT5yeF91cmJfc2l6ZSB8fCAhZGV2LT5oYXJk
X210dSkKKwkJZ290byBpbnNhbml0eTsKIAlzd2l0Y2ggKHNwZWVkKSB7CiAJY2FzZSBVU0JfU1BF
RURfSElHSDoKIAkJZGV2LT5yeF9xbGVuID0gTUFYX1FVRVVFX01FTU9SWSAvIGRldi0+cnhfdXJi
X3NpemU7CkBAIC0zNTUsNiArMzU3LDcgQEAgdm9pZCB1c2JuZXRfdXBkYXRlX21heF9xbGVuKHN0
cnVjdCB1c2JuZXQgKmRldikKIAkJZGV2LT50eF9xbGVuID0gNSAqIE1BWF9RVUVVRV9NRU1PUlkg
LyBkZXYtPmhhcmRfbXR1OwogCQlicmVhazsKIAlkZWZhdWx0OgoraW5zYW5pdHk6CiAJCWRldi0+
cnhfcWxlbiA9IGRldi0+dHhfcWxlbiA9IDQ7CiAJfQogfQotLSAKMi4xNi40Cgo=


--=-Yd95Qj5bjthxkmik5dv9--

