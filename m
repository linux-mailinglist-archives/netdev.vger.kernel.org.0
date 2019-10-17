Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED40FDAF03
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 16:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439778AbfJQOCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 10:02:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:48700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727542AbfJQOCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 10:02:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7B36B5C9;
        Thu, 17 Oct 2019 14:02:22 +0000 (UTC)
Message-ID: <1571320940.5264.11.camel@suse.com>
Subject: Re: KMSAN: uninit-value in ax88172a_bind
From:   Oliver Neukum <oneukum@suse.com>
To:     syzbot <syzbot+a8d4acdad35e6bbca308@syzkaller.appspotmail.com>,
        davem@davemloft.net, swinslow@gmail.com, glider@google.com,
        syzkaller-bugs@googlegroups.com, opensource@jilayne.com,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 17 Oct 2019 16:02:20 +0200
In-Reply-To: <00000000000064555d0594ebff2f@google.com>
References: <00000000000064555d0594ebff2f@google.com>
Content-Type: multipart/mixed; boundary="=-1FI935soZhHIsJol0ILN"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-1FI935soZhHIsJol0ILN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Am Montag, den 14.10.2019, 22:10 -0700 schrieb syzbot:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    fa169025 kmsan: get rid of unused static functions in kmsa..
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=1432a653600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=49548798e87d32d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=a8d4acdad35e6bbca308
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14743a6f600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125bdbc7600000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a8d4acdad35e6bbca308@syzkaller.appspotmail.com

#syz test: https://github.com/google/kmsan.git fa169025


--=-1FI935soZhHIsJol0ILN
Content-Disposition: attachment;
	filename="0001-asix-fix-information-leak-on-short-answers.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-asix-fix-information-leak-on-short-answers.patch";
	charset="UTF-8"

RnJvbSBhNmZkN2EwNGEzMzBhOGJmYWQ4MzZiMjA4NDNlYTVmZTI2ZTBhZTM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBUaHUsIDE3IE9jdCAyMDE5IDE1OjEyOjMzICswMjAwClN1YmplY3Q6IFtQQVRDSF0gYXNpeDog
Zml4IGluZm9ybWF0aW9uIGxlYWsgb24gc2hvcnQgYW5zd2VycwoKSWYgYSBtYWxpY2lvdXMgZGV2
aWNlIGdpdmVzIGEgc2hvcnQgTUFDIGl0IGNhbiBlbGljaXQgdXAgdG8KNSBieXRlcyBvZiBsZWFr
ZWQgbWVtb3J5IG91dCBvZiB0aGUgZHJpdmVyLiBXZSBuZWVkIHRvIGNoZWNrIGZvcgpFVEhfQUxF
Ti4KClNpZ25lZC1vZmYtYnk6IE9saXZlciBOZXVrdW0gPG9uZXVrdW1Ac3VzZS5jb20+Ci0tLQog
ZHJpdmVycy9uZXQvdXNiL2F4ODgxNzJhLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC91c2IvYXg4
ODE3MmEuYyBiL2RyaXZlcnMvbmV0L3VzYi9heDg4MTcyYS5jCmluZGV4IDAxMWJkNGNiNTQ2ZS4u
YWYzOTk0ZTA4NTNiIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC91c2IvYXg4ODE3MmEuYworKysg
Yi9kcml2ZXJzL25ldC91c2IvYXg4ODE3MmEuYwpAQCAtMTk2LDcgKzE5Niw3IEBAIHN0YXRpYyBp
bnQgYXg4ODE3MmFfYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVjdCB1c2JfaW50ZXJmYWNl
ICppbnRmKQogCiAJLyogR2V0IHRoZSBNQUMgYWRkcmVzcyAqLwogCXJldCA9IGFzaXhfcmVhZF9j
bWQoZGV2LCBBWF9DTURfUkVBRF9OT0RFX0lELCAwLCAwLCBFVEhfQUxFTiwgYnVmLCAwKTsKLQlp
ZiAocmV0IDwgMCkgeworCWlmIChyZXQgPCBFVEhfQUxFTikgewogCQluZXRkZXZfZXJyKGRldi0+
bmV0LCAiRmFpbGVkIHRvIHJlYWQgTUFDIGFkZHJlc3M6ICVkXG4iLCByZXQpOwogCQlnb3RvIGZy
ZWU7CiAJfQotLSAKMi4xNi40Cgo=


--=-1FI935soZhHIsJol0ILN--

