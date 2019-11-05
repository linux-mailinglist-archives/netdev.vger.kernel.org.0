Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C6FEFC56
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 12:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbfKEL17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 06:27:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:35292 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730624AbfKEL16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 06:27:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AE44FB3D1;
        Tue,  5 Nov 2019 11:27:56 +0000 (UTC)
Message-ID: <1572952316.2921.3.camel@suse.com>
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
From:   Oliver Neukum <oneukum@suse.com>
To:     syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date:   Tue, 05 Nov 2019 12:11:56 +0100
In-Reply-To: <00000000000013c4c1059625a655@google.com>
References: <00000000000013c4c1059625a655@google.com>
Content-Type: multipart/mixed; boundary="=-tHZcmQBfFGLiVVm2/Dfe"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-tHZcmQBfFGLiVVm2/Dfe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Am Mittwoch, den 30.10.2019, 12:22 -0700 schrieb syzbot:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    96c6c319 net: kasan: kmsan: support CONFIG_GENERIC_CSUM on..
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=11f103bce00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9e324dfe9c7b0360
> dashboard link: https://syzkaller.appspot.com/bug?extid=0631d878823ce2411636
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10dd9774e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13651a24e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0631d878823ce2411636@syzkaller.appspotmail.com
#syz test: https://github.com/google/kmsan.git 96c6c319

--=-tHZcmQBfFGLiVVm2/Dfe
Content-Disposition: attachment;
	filename="0001-CDC-NCM-handle-incomplete-transfer-of-MTU.patch"
Content-Type: text/x-patch; name="0001-CDC-NCM-handle-incomplete-transfer-of-MTU.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAwOTBhYzAzMDViYjQ3ZGE5MzM2YzAxODhlMGU1OWU1MGZmMjI0M2MzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgpEYXRl
OiBUdWUsIDUgTm92IDIwMTkgMTI6MDQ6NDQgKzAxMDAKU3ViamVjdDogW1BBVENIXSBDREMtTkNN
OiBoYW5kbGUgaW5jb21wbGV0ZSB0cmFuc2ZlciBvZiBNVFUKCkEgbWFsaWNpb3VzIGRldmljZSBt
YXkgZ2l2ZSBoYWxmIGFuIGFuc3dlciB3aGVuIGFza2VkCmZvciBpdHMgTVRVLiBUaGUgZHJpdmVy
IHdpbGwgcHJvY2VlZCBhZnRlciB0aGlzIHdpdGgKYSBnYXJiYWdlIE1UVS4gQW55dGhpbmcgYnV0
IGEgY29tcGxldGUgYW5zd2VyIG11c3QgYmUgdHJlYXRlZAphcyBhbiBlcnJvci4KClJlcG9ydGVk
LWJ5OiBzeXpib3QrMDYzMWQ4Nzg4MjNjZTI0MTE2MzZAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNv
bQpTaWduZWQtb2ZmLWJ5OiBPbGl2ZXIgTmV1a3VtIDxvbmV1a3VtQHN1c2UuY29tPgotLS0KIGRy
aXZlcnMvbmV0L3VzYi9jZGNfbmNtLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC91c2IvY2RjX25j
bS5jIGIvZHJpdmVycy9uZXQvdXNiL2NkY19uY20uYwppbmRleCAwMGNhYjNmNDNhNGMuLjkzOTQ4
N2E1ZjRiYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNiL2NkY19uY20uYworKysgYi9kcml2
ZXJzL25ldC91c2IvY2RjX25jbS5jCkBAIC01NzksNyArNTc5LDcgQEAgc3RhdGljIHZvaWQgY2Rj
X25jbV9zZXRfZGdyYW1fc2l6ZShzdHJ1Y3QgdXNibmV0ICpkZXYsIGludCBuZXdfc2l6ZSkKIAll
cnIgPSB1c2JuZXRfcmVhZF9jbWQoZGV2LCBVU0JfQ0RDX0dFVF9NQVhfREFUQUdSQU1fU0laRSwK
IAkJCSAgICAgIFVTQl9UWVBFX0NMQVNTIHwgVVNCX0RJUl9JTiB8IFVTQl9SRUNJUF9JTlRFUkZB
Q0UsCiAJCQkgICAgICAwLCBpZmFjZV9ubywgJm1heF9kYXRhZ3JhbV9zaXplLCAyKTsKLQlpZiAo
ZXJyIDwgMCkgeworCWlmIChlcnIgPCAyKSB7CiAJCWRldl9kYmcoJmRldi0+aW50Zi0+ZGV2LCAi
R0VUX01BWF9EQVRBR1JBTV9TSVpFIGZhaWxlZFxuIik7CiAJCWdvdG8gb3V0OwogCX0KLS0gCjIu
MTYuNAoK


--=-tHZcmQBfFGLiVVm2/Dfe--

