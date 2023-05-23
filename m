Return-Path: <netdev+bounces-4477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 388D070D146
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 992AD281173
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2901108;
	Tue, 23 May 2023 02:32:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E125EA1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:32:22 +0000 (UTC)
X-Greylist: delayed 377 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 May 2023 19:32:19 PDT
Received: from out-14.mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39C9F4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:32:19 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------GFfthMi5biGdyduudWrWSocw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684808760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kTp1df867SFJXxt8IIrlaAxbSGmv+ncI2619R+e48qY=;
	b=pCtEX+HUv0p8zw0D/4QLs5MPjgjOX7COq5yVCNmOZ+QOyAzvWD5DPN4EMDvqJxeMqbrUhq
	xLdrolGrolE0PIQEopduFKSy6sEQx8zouRh7DueS8DdFzejqDH5FSBZCo2qR13bEKidGZF
	vISxA3q4WHy+p0du4Qls43zpJrjqHWI=
Message-ID: <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
Date: Tue, 23 May 2023 10:25:56 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
Content-Language: en-US
To: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, zyjzyj2000@gmail.com
References: <000000000000a589d005fc52ee2d@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <000000000000a589d005fc52ee2d@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a multi-part message in MIME format.
--------------GFfthMi5biGdyduudWrWSocw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/23 10:13, syzbot wrote:
> Hello,
>
> syzbot tried to test the proposed patch but the build/boot failed:
>
> failed to apply patch:
> checking file drivers/infiniband/sw/rxe/rxe_qp.c
> patch: **** unexpected end of file in patch
>
>
>
> Tested on:
>
> commit:         56518a60 RDMA/hns: Modify the value of long message lo..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-rc
> dashboard link: https://syzkaller.appspot.com/bug?extid=eba589d8f49c73d356da
> compiler:
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=132bea5a280000
>

Sorry, let me attach the temp patch.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git 
for-rc
--------------GFfthMi5biGdyduudWrWSocw
Content-Type: text/x-patch; charset=UTF-8; name="temp-rxe.patch"
Content-Disposition: attachment; filename="temp-rxe.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX3FwLmMgYi9kcml2
ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9xcC5jCmluZGV4IDYxYTJlYjc3ZDk5OS4uMTdl
ZDQxMzA5NzU2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvc3cvcnhlL3J4ZV9x
cC5jCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9zdy9yeGUvcnhlX3FwLmMKQEAgLTc1OCwx
OSArNzU4LDIxIEBAIHN0YXRpYyB2b2lkIHJ4ZV9xcF9kb19jbGVhbnVwKHN0cnVjdCB3b3Jr
X3N0cnVjdCAqd29yaykKIAkJZGVsX3RpbWVyX3N5bmMoJnFwLT5ybnJfbmFrX3RpbWVyKTsK
IAl9CiAKLQlpZiAocXAtPnJlc3AudGFzay5mdW5jKQorCS8qIGZsdXNoIG91dCBhbnkgcmVj
ZWl2ZSB3cidzIG9yIHBlbmRpbmcgcmVxdWVzdHMgKi8KKwlpZiAocXAtPnJlc3AudGFzay5m
dW5jKSB7CiAJCXJ4ZV9jbGVhbnVwX3Rhc2soJnFwLT5yZXNwLnRhc2spOworCQlyeGVfcmVz
cG9uZGVyKHFwKTsKKwl9CiAKLQlpZiAocXAtPnJlcS50YXNrLmZ1bmMpCisJaWYgKHFwLT5y
ZXEudGFzay5mdW5jKSB7CiAJCXJ4ZV9jbGVhbnVwX3Rhc2soJnFwLT5yZXEudGFzayk7CisJ
CXJ4ZV9yZXF1ZXN0ZXIocXApOworCX0KIAotCWlmIChxcC0+Y29tcC50YXNrLmZ1bmMpCisJ
aWYgKHFwLT5jb21wLnRhc2suZnVuYykgewogCQlyeGVfY2xlYW51cF90YXNrKCZxcC0+Y29t
cC50YXNrKTsKLQotCS8qIGZsdXNoIG91dCBhbnkgcmVjZWl2ZSB3cidzIG9yIHBlbmRpbmcg
cmVxdWVzdHMgKi8KLQlyeGVfcmVxdWVzdGVyKHFwKTsKLQlyeGVfY29tcGxldGVyKHFwKTsK
LQlyeGVfcmVzcG9uZGVyKHFwKTsKKwkJcnhlX2NvbXBsZXRlcihxcCk7CisJfQogCiAJaWYg
KHFwLT5zcS5xdWV1ZSkKIAkJcnhlX3F1ZXVlX2NsZWFudXAocXAtPnNxLnF1ZXVlKTsK

--------------GFfthMi5biGdyduudWrWSocw--

