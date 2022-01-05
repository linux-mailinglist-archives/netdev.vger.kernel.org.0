Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D85485303
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 13:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbiAEMta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 07:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiAEMt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 07:49:26 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B4AC061761;
        Wed,  5 Jan 2022 04:49:25 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id j11so87121472lfg.3;
        Wed, 05 Jan 2022 04:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=uBxaYOlKR0ToYVXuF/1xoWyiN6Wy6vsyVIMnJ/g5hOI=;
        b=S9nsO8+C0RflUbe72fWrFhQnZWg5jNMqRbY55wZFgUGkv9u9f7wJOKIdtP84e1SWma
         owvhOJhJVtATwKGW//nLd6m7KZqSvxV3qyt3/z8Gj05pqwgzykW2j9oKlaIr/4ZK3Qnd
         fM4/op7oO7qHQAeocgz04rTb4bw89O1jimKi84UmQaSYyHT7BExfUv1g1/KFKMeRCrp1
         +Xz+o/eoUZ838AVjwzq/PP3i3aEJzlEjkpNkGHvr2QLhgkV+KHh2l6g9+mj9ZCz8pOi/
         Ve0fXQgEOEFWyw97cpFCW9+vMQI26WuymSFCyweE2xaxZEIe8vuP4/W2mIHuxNjaStxm
         EUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=uBxaYOlKR0ToYVXuF/1xoWyiN6Wy6vsyVIMnJ/g5hOI=;
        b=nJqMq0OBy4Hths6xCWmBgcJybF4fqe5kaxlpVUVvmMfu5xXAZnoE0oR7p+zSm6eq/c
         UJZCf5/Oepq+JSEuFV0d/N9K5sTtorFKzX06A/wSPXQm26rXUbeScjKhnnZxyTFU8UAu
         nwfK0Wyewdzq284r/WQnaNtZdSYYZERll08vnhCJmfgD7dz3d1gzrl2mHfiOVqQ6gztd
         BlzLHKVAEONkU4lEVE86ReP+Lb5tciev8DzzHqX0YVfBmAxnKV7xjK/HZJwWd+4UCJ8h
         0crj9gRqgBnyDV9SZnaGaZTO8KH8o/au14534F3dt8BaFwI+bFs9D/vfigbQ91mrmBQz
         GnvQ==
X-Gm-Message-State: AOAM533SXCmdb/MJtvrve+/UnTGvoXLaB3aZGDu809v7zaY1tuq3AkE/
        NYNfrdeHpQQ/8UjLQDb792Y=
X-Google-Smtp-Source: ABdhPJxcgBCA7/UtpNHWqPqmIlQV3tZp5X+xIxu58RNiQ4V3fYYzrnBBWBl5z3etRgx+TVbTjA1v9g==
X-Received: by 2002:a05:6512:3b07:: with SMTP id f7mr46453153lfv.567.1641386963530;
        Wed, 05 Jan 2022 04:49:23 -0800 (PST)
Received: from [192.168.1.11] ([94.103.235.38])
        by smtp.gmail.com with ESMTPSA id o19sm3059505ljp.58.2022.01.05.04.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 04:49:22 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------OozWciv4hOffijXngRVx3KIi"
Message-ID: <66341bb1-a479-cdc8-0928-3c882ac77712@gmail.com>
Date:   Wed, 5 Jan 2022 15:49:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [syzbot] KMSAN: uninit-value in ax88178_reset
Content-Language: en-US
To:     syzbot <syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com>,
        andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000cf7a2405d4d48d3b@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000cf7a2405d4d48d3b@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------OozWciv4hOffijXngRVx3KIi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/5/22 15:04, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b0a8b5053e8b kmsan: core: add dependency on DEBUG_KERNEL
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=159cf693b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
> dashboard link: https://syzkaller.appspot.com/bug?extid=6ca9f7867b77c2d316ac
> compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14413193b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127716a3b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
> 
> asix 1-1:0.0 eth1: Failed to read reg index 0x0000: -32
> asix 1-1:0.0 eth1: Failed to read reg index 0x0000: -32
> =====================================================
> BUG: KMSAN: uninit-value in ax88178_reset+0xfd2/0x1590 drivers/net/usb/asix_devices.c:946 drivers/net/usb/asix_devices.c:946
>   ax88178_reset+0xfd2/0x1590 drivers/net/usb/asix_devices.c:946 drivers/net/usb/asix_devices.c:946
>   usbnet_open+0x16d/0x1940 drivers/net/usb/usbnet.c:894 drivers/net/usb/usbnet.c:894
>   __dev_open+0x920/0xb90 net/core/dev.c:1490 net/core/dev.c:1490
>   __dev_change_flags+0x4da/0xd40 net/core/dev.c:8796 net/core/dev.c:8796
>   dev_change_flags+0xf5/0x280 net/core/dev.c:8867 net/core/dev.c:8867
>   devinet_ioctl+0xfc1/0x3060 net/ipv4/devinet.c:1144 net/ipv4/devinet.c:1144
>   inet_ioctl+0x59f/0x820 net/ipv4/af_inet.c:969 net/ipv4/af_inet.c:969
>   sock_do_ioctl net/socket.c:1118 [inline]
>   sock_do_ioctl net/socket.c:1118 [inline] net/socket.c:1235
>   sock_ioctl+0xa3f/0x13d0 net/socket.c:1235 net/socket.c:1235
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:874 [inline]
>   vfs_ioctl fs/ioctl.c:51 [inline] fs/ioctl.c:860
>   __do_sys_ioctl fs/ioctl.c:874 [inline] fs/ioctl.c:860
>   __se_sys_ioctl+0x2df/0x4a0 fs/ioctl.c:860 fs/ioctl.c:860
>   __x64_sys_ioctl+0xd8/0x110 fs/ioctl.c:860 fs/ioctl.c:860
>   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>   do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
>   do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Local variable status created at:
>   ax88178_reset+0x69/0x1590
>   usbnet_open+0x16d/0x1940 drivers/net/usb/usbnet.c:894 drivers/net/usb/usbnet.c:894

Again usbnet_read_cmd() returns 0.

It seems reasonable to mark asix_read_cmd() as __must_check, so let's do 
it and add missing error handling

#syz test: https://github.com/google/kmsan.git master



With regards,
Pavel Skripkin
--------------OozWciv4hOffijXngRVx3KIi
Content-Type: text/plain; charset=UTF-8; name="ph"
Content-Disposition: attachment; filename="ph"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9hc2l4LmggYi9kcml2ZXJzL25ldC91c2Iv
YXNpeC5oCmluZGV4IDJhMWUzMWRlZmU3MS4uNDMzNGFhZmFiNTlhIDEwMDY0NAotLS0gYS9k
cml2ZXJzL25ldC91c2IvYXNpeC5oCisrKyBiL2RyaXZlcnMvbmV0L3VzYi9hc2l4LmgKQEAg
LTE5Miw4ICsxOTIsOCBAQCBleHRlcm4gY29uc3Qgc3RydWN0IGRyaXZlcl9pbmZvIGF4ODgx
NzJhX2luZm87CiAvKiBBU0lYIHNwZWNpZmljIGZsYWdzICovCiAjZGVmaW5lIEZMQUdfRUVQ
Uk9NX01BQwkJKDFVTCA8PCAwKSAgLyogaW5pdCBkZXZpY2UgTUFDIGZyb20gZWVwcm9tICov
CiAKLWludCBhc2l4X3JlYWRfY21kKHN0cnVjdCB1c2JuZXQgKmRldiwgdTggY21kLCB1MTYg
dmFsdWUsIHUxNiBpbmRleCwKLQkJICB1MTYgc2l6ZSwgdm9pZCAqZGF0YSwgaW50IGluX3Bt
KTsKK2ludCBfX211c3RfY2hlY2sgYXNpeF9yZWFkX2NtZChzdHJ1Y3QgdXNibmV0ICpkZXYs
IHU4IGNtZCwgdTE2IHZhbHVlLCB1MTYgaW5kZXgsCisJCQkgICAgICAgdTE2IHNpemUsIHZv
aWQgKmRhdGEsIGludCBpbl9wbSk7CiAKIGludCBhc2l4X3dyaXRlX2NtZChzdHJ1Y3QgdXNi
bmV0ICpkZXYsIHU4IGNtZCwgdTE2IHZhbHVlLCB1MTYgaW5kZXgsCiAJCSAgIHUxNiBzaXpl
LCB2b2lkICpkYXRhLCBpbnQgaW5fcG0pOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNi
L2FzaXhfY29tbW9uLmMgYi9kcml2ZXJzL25ldC91c2IvYXNpeF9jb21tb24uYwppbmRleCA3
MTY4Mjk3MGJlNTguLmRmNjM3ZDgyODRhYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNi
L2FzaXhfY29tbW9uLmMKKysrIGIvZHJpdmVycy9uZXQvdXNiL2FzaXhfY29tbW9uLmMKQEAg
LTExLDggKzExLDggQEAKIAogI2RlZmluZSBBWF9IT1NUX0VOX1JFVFJJRVMJMzAKIAotaW50
IGFzaXhfcmVhZF9jbWQoc3RydWN0IHVzYm5ldCAqZGV2LCB1OCBjbWQsIHUxNiB2YWx1ZSwg
dTE2IGluZGV4LAotCQkgIHUxNiBzaXplLCB2b2lkICpkYXRhLCBpbnQgaW5fcG0pCitpbnQg
X19tdXN0X2NoZWNrIGFzaXhfcmVhZF9jbWQoc3RydWN0IHVzYm5ldCAqZGV2LCB1OCBjbWQs
IHUxNiB2YWx1ZSwgdTE2IGluZGV4LAorCQkJICAgICAgIHUxNiBzaXplLCB2b2lkICpkYXRh
LCBpbnQgaW5fcG0pCiB7CiAJaW50IHJldDsKIAlpbnQgKCpmbikoc3RydWN0IHVzYm5ldCAq
LCB1OCwgdTgsIHUxNiwgdTE2LCB2b2lkICosIHUxNik7CkBAIC0yNyw5ICsyNywxMiBAQCBp
bnQgYXNpeF9yZWFkX2NtZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHU4IGNtZCwgdTE2IHZhbHVl
LCB1MTYgaW5kZXgsCiAJcmV0ID0gZm4oZGV2LCBjbWQsIFVTQl9ESVJfSU4gfCBVU0JfVFlQ
RV9WRU5ET1IgfCBVU0JfUkVDSVBfREVWSUNFLAogCQkgdmFsdWUsIGluZGV4LCBkYXRhLCBz
aXplKTsKIAotCWlmICh1bmxpa2VseShyZXQgPCAwKSkKKwlpZiAodW5saWtlbHkocmV0IDwg
c2l6ZSkpIHsKKwkJcmV0ID0gcmV0IDwgMCA/IHJldCA6IC1FTk9EQVRBOworCiAJCW5ldGRl
dl93YXJuKGRldi0+bmV0LCAiRmFpbGVkIHRvIHJlYWQgcmVnIGluZGV4IDB4JTA0eDogJWRc
biIsCiAJCQkgICAgaW5kZXgsIHJldCk7CisJfQogCiAJcmV0dXJuIHJldDsKIH0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9hc2l4X2RldmljZXMuYyBiL2RyaXZlcnMvbmV0L3Vz
Yi9hc2l4X2RldmljZXMuYwppbmRleCA0NTE0ZDM1ZWY0YzQuLjZiMmZiZGY0ZTBmZCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9uZXQvdXNiL2FzaXhfZGV2aWNlcy5jCisrKyBiL2RyaXZlcnMv
bmV0L3VzYi9hc2l4X2RldmljZXMuYwpAQCAtNzU1LDcgKzc1NSwxMiBAQCBzdGF0aWMgaW50
IGF4ODg3NzJfYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVjdCB1c2JfaW50ZXJmYWNl
ICppbnRmKQogCXByaXYtPnBoeV9hZGRyID0gcmV0OwogCXByaXYtPmVtYmRfcGh5ID0gKChw
cml2LT5waHlfYWRkciAmIDB4MWYpID09IDB4MTApOwogCi0JYXNpeF9yZWFkX2NtZChkZXYs
IEFYX0NNRF9TVEFUTU5HU1RTX1JFRywgMCwgMCwgMSwgJmNoaXBjb2RlLCAwKTsKKwlyZXQg
PSBhc2l4X3JlYWRfY21kKGRldiwgQVhfQ01EX1NUQVRNTkdTVFNfUkVHLCAwLCAwLCAxLCAm
Y2hpcGNvZGUsIDApOworCWlmIChyZXQgPCAwKSB7CisJCW5ldGRldl9kYmcoZGV2LT5uZXQs
ICJGYWlsZWQgdG8gcmVhZCBTVEFUTU5HU1RTX1JFRzogJWRcbiIsIHJldCk7CisJCXJldHVy
biByZXQ7CisJfQorCiAJY2hpcGNvZGUgJj0gQVhfQ0hJUENPREVfTUFTSzsKIAogCXJldCA9
IChjaGlwY29kZSA9PSBBWF9BWDg4NzcyX0NISVBDT0RFKSA/IGF4ODg3NzJfaHdfcmVzZXQo
ZGV2LCAwKSA6CkBAIC05MjAsMTEgKzkyNSwyMSBAQCBzdGF0aWMgaW50IGF4ODgxNzhfcmVz
ZXQoc3RydWN0IHVzYm5ldCAqZGV2KQogCWludCBncGlvMCA9IDA7CiAJdTMyIHBoeWlkOwog
Ci0JYXNpeF9yZWFkX2NtZChkZXYsIEFYX0NNRF9SRUFEX0dQSU9TLCAwLCAwLCAxLCAmc3Rh
dHVzLCAwKTsKKwlyZXQgPSBhc2l4X3JlYWRfY21kKGRldiwgQVhfQ01EX1JFQURfR1BJT1Ms
IDAsIDAsIDEsICZzdGF0dXMsIDApOworCWlmIChyZXQgPCAwKSB7CisJCW5ldGRldl9kYmco
ZGV2LT5uZXQsICJGYWlsZWQgdG8gcmVhZCBHUElPUzogJWRcbiIsIHJldCk7CisJCXJldHVy
biByZXQ7CisJfQorCiAJbmV0ZGV2X2RiZyhkZXYtPm5ldCwgIkdQSU8gU3RhdHVzOiAweCUw
NHhcbiIsIHN0YXR1cyk7CiAKIAlhc2l4X3dyaXRlX2NtZChkZXYsIEFYX0NNRF9XUklURV9F
TkFCTEUsIDAsIDAsIDAsIE5VTEwsIDApOwotCWFzaXhfcmVhZF9jbWQoZGV2LCBBWF9DTURf
UkVBRF9FRVBST00sIDB4MDAxNywgMCwgMiwgJmVlcHJvbSwgMCk7CisJcmV0ID0gYXNpeF9y
ZWFkX2NtZChkZXYsIEFYX0NNRF9SRUFEX0VFUFJPTSwgMHgwMDE3LCAwLCAyLCAmZWVwcm9t
LCAwKTsKKwlpZiAocmV0IDwgMCkgeworCQluZXRkZXZfZGJnKGRldi0+bmV0LCAiRmFpbGVk
IHRvIHJlYWQgRUVQUk9NOiAlZFxuIiwgcmV0KTsKKwkJcmV0dXJuIHJldDsKKwl9CisKIAlh
c2l4X3dyaXRlX2NtZChkZXYsIEFYX0NNRF9XUklURV9ESVNBQkxFLCAwLCAwLCAwLCBOVUxM
LCAwKTsKIAogCW5ldGRldl9kYmcoZGV2LT5uZXQsICJFRVBST00gaW5kZXggMHgxNyBpcyAw
eCUwNHhcbiIsIGVlcHJvbSk7Cg==

--------------OozWciv4hOffijXngRVx3KIi--
