Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30334410C3
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 21:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhJaUSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 16:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhJaUSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 16:18:48 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE7CC061570;
        Sun, 31 Oct 2021 13:16:16 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id k13so26100549ljj.12;
        Sun, 31 Oct 2021 13:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=lKxvlWC3ChNGIziUsunH7azTCso8Biwy2rrv88iSo4M=;
        b=RwI6CF+hgc6m3XF4pRsGtPnwHyNHHy9R+GVlFQ2seypV1PbWoKZ1HIIEkySwqJVrGP
         6CcCW4dzGm6VgM+LlGIkn7wxkdBVOwUM79QqbvcNMB3zWiC7t+vCgodDcfTtjaoT3vVe
         olTZi9PwUFn8VF9IBYw7j/Mmo7IgxB1eAAcSCcsZg7mZ4QNnGYG+ITkQPpaojhd/5SzJ
         OJhYSvZXz93nT31ERSHZTS3qyjKxb4o5B8sXTbMca8cRm5X3awHOY1P/NnrcMSFokpqD
         nFoAd9tytF/ScneeuMqNvXamOwJnFKlGzUhkR4mFaOabBvrmecOAkxqG+LyVL7vP7IV5
         JI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=lKxvlWC3ChNGIziUsunH7azTCso8Biwy2rrv88iSo4M=;
        b=kKMlwS/uKs6CQv4I6gwOBBVYZ7ZkE77UYNOl/ERQQjmDyBVf3wei/M4FbEKAS8MO8n
         Xc36XMUdwZoXvfVJbR6R9hm4SYxSnBI4O7TNqdQA88zobYY00hjM4wisGPfyHFxfRdDa
         SHrCyCBk+ZmPt+gF6A5cZTd6IbkYjxuyC/Fi/TjE4OmHMBzaTJL3SWepHgThyb8LvGHu
         Kq3m5LGpH+016Tq/dZjQW7hCpp7IUafZDm7y8+QFQoe2VMc8dlP/8F83Ey0oeIzCfW11
         arJZn+QGqwSbFOr4eSYZ7xzyIR2oF92ghrTBbA811HacV7MKqs9ww6oOtAfstkriwvD8
         S2iQ==
X-Gm-Message-State: AOAM532G/o2U9fDgxZDDavg8B93jI7B7krZEhmfj6mp3eez5tE9v+Yz0
        76W6wleWaMVKwSHoQzGe5ZsK2wX1qMvH/A==
X-Google-Smtp-Source: ABdhPJxk6nHMr461mBuXT6XhZdocynQGf4bM8Z7MkBzvY0ciyF2gEyicAs1iMEfrVof0Sl3K19EMkA==
X-Received: by 2002:a2e:9d05:: with SMTP id t5mr5729698lji.433.1635711374582;
        Sun, 31 Oct 2021 13:16:14 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.235.8])
        by smtp.gmail.com with ESMTPSA id e11sm19827ljj.99.2021.10.31.13.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 13:16:13 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------SfNDH39slPPO9sbrxHVe2Rgq"
Message-ID: <4b2b9c55-e2e0-a149-7dfe-ca36244d2245@gmail.com>
Date:   Sun, 31 Oct 2021 23:16:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in hci_le_meta_evt (2)
Content-Language: en-US
To:     syzbot <syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000002ba17d05cfaa8446@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <0000000000002ba17d05cfaa8446@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------SfNDH39slPPO9sbrxHVe2Rgq
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/21 21:49, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         180eca54 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6362530af157355b
> dashboard link: https://syzkaller.appspot.com/bug?extid=e3fcb9c4f3c2a931dc40
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=1295a186b00000
> 
> Note: testing is done by a robot and is best-effort only.
> 

Ok, let's check more corner cases. Looks like nothing checks them.

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master




With regards,
Pavel Skripkin
--------------SfNDH39slPPO9sbrxHVe2Rgq
Content-Type: text/plain; charset=UTF-8; name="ph"
Content-Disposition: attachment; filename="ph"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL25ldC9ibHVldG9vdGgvaGNpX2V2ZW50LmMgYi9uZXQvYmx1ZXRvb3Ro
L2hjaV9ldmVudC5jCmluZGV4IDBiY2EwMzViZjJkYy4uNTBkMWQ2MmMxNWVjIDEwMDY0NAot
LS0gYS9uZXQvYmx1ZXRvb3RoL2hjaV9ldmVudC5jCisrKyBiL25ldC9ibHVldG9vdGgvaGNp
X2V2ZW50LmMKQEAgLTU3ODAsNyArNTc4MCw4IEBAIHN0YXRpYyB2b2lkIGhjaV9sZV9hZHZf
cmVwb3J0X2V2dChzdHJ1Y3QgaGNpX2RldiAqaGRldiwgc3RydWN0IHNrX2J1ZmYgKnNrYikK
IAkJc3RydWN0IGhjaV9ldl9sZV9hZHZlcnRpc2luZ19pbmZvICpldiA9IHB0cjsKIAkJczgg
cnNzaTsKIAotCQlpZiAoZXYtPmxlbmd0aCA8PSBIQ0lfTUFYX0FEX0xFTkdUSCkgeworCQlp
ZiAoZXYtPmxlbmd0aCA8PSBIQ0lfTUFYX0FEX0xFTkdUSCAmJgorCQkgICAgZXYtPmRhdGEg
KyBldi0+bGVuZ3RoIDw9IHNrYl90YWlsX3BvaW50ZXIoc2tiKSkgewogCQkJcnNzaSA9IGV2
LT5kYXRhW2V2LT5sZW5ndGhdOwogCQkJcHJvY2Vzc19hZHZfcmVwb3J0KGhkZXYsIGV2LT5l
dnRfdHlwZSwgJmV2LT5iZGFkZHIsCiAJCQkJCSAgIGV2LT5iZGFkZHJfdHlwZSwgTlVMTCwg
MCwgcnNzaSwKQEAgLTU3OTAsNiArNTc5MSwxMSBAQCBzdGF0aWMgdm9pZCBoY2lfbGVfYWR2
X3JlcG9ydF9ldnQoc3RydWN0IGhjaV9kZXYgKmhkZXYsIHN0cnVjdCBza19idWZmICpza2Ip
CiAJCX0KIAogCQlwdHIgKz0gc2l6ZW9mKCpldikgKyBldi0+bGVuZ3RoICsgMTsKKworCQlp
ZiAocHRyID4gKHZvaWQgKikgc2tiX3RhaWxfcG9pbnRlcihza2IpIC0gc2l6ZW9mKCpldikp
IHsKKwkJCWJ0X2Rldl9lcnIoaGRldiwgIk1hbGljaW91cyBhZHZlcnRpc2luZyBkYXRhLiBT
dG9wcGluZyBwcm9jZXNzaW5nIik7CisJCQlicmVhazsKKwkJfQogCX0KIAogCWhjaV9kZXZf
dW5sb2NrKGhkZXYpOwo=
--------------SfNDH39slPPO9sbrxHVe2Rgq--

