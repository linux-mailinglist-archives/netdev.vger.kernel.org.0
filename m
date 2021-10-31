Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19AB441037
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 19:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhJaSYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 14:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhJaSYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 14:24:25 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B70BC061570;
        Sun, 31 Oct 2021 11:21:53 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id bu18so14908990lfb.0;
        Sun, 31 Oct 2021 11:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=wqYYZAw8mJDoUZwjBIh6WIZb2PEHvXCN2g38WcTqY/U=;
        b=iiqlokAg5nRHGOZIU5R6zJ2WfZPCG5jeAb4BtS5vvy42xSkhnyOGZpNje4B75GsUs1
         cJK0vnSF8QK5XNYbRe67c9JZ58kzF+OAmxgwxE/tRDJH9Eaj6laHD6XTqmVkeYtvSVhy
         E9JR7/RXtFgGyHu8TKsgCY6r/f288jP0f3cNKGWELmlVy7oIllDWSO0+4CrcNiFVKg3G
         bZ7USLVOD2F8SKA08K+C9edKYp7YcWeHQy6GvajtZpE2WX0+9PA0woU94/5ghAVesByy
         XhDj4VuDgIhbHoBUdj54yqIxkukJQqsK0BA2F02QVHGr9/JWE2JtFACTnfoJ0HpneOxC
         H6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=wqYYZAw8mJDoUZwjBIh6WIZb2PEHvXCN2g38WcTqY/U=;
        b=nCQIKY8rgt36HjzvnSW93EZFlx3aGzb5IUDuB5v7/d/LCdKKW033waVC0JH6Dlgx2U
         wvc0o2JSLLiUvDlW85IWpZcGPIl0Hr1xvA/kzyrkEJqtJw+/njlH/DlRiELv7T0Cx/fX
         e4k1FGyI/uPabKGdpEnfdOIao/TLtLdN01kTNP3TVPHeipJz+uR+yfv8YdxVvC7Fxrtq
         tB4pDOszKuATPUQG7Fgoh6I4bkKSFqrYRialE672hWg3VVKZsOV0N/5aPSE6LbuUh1wt
         deLLQS7BthcmWXVo+LV32c+PJ0nOhjyvl+DMOBFb1Jvjiq+L20zJvd/7SvESe1HQpOFW
         wTPw==
X-Gm-Message-State: AOAM5328ZL70m5A+jRp6HpGcUqrNp94XZlpFbJYDdr9Go/qy6q2lAvHz
        2AqzALz3UFch/1ULgU+XZI4=
X-Google-Smtp-Source: ABdhPJxL4jaYw4R9CcppkmueI8ST8qRQhkQvm2ulaaLDLfjCb6jg8xqTZ21JhQdgPA+h+nBt7yK4Yw==
X-Received: by 2002:a05:6512:318d:: with SMTP id i13mr2434278lfe.290.1635704510691;
        Sun, 31 Oct 2021 11:21:50 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.235.8])
        by smtp.gmail.com with ESMTPSA id g18sm1272768ljl.26.2021.10.31.11.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 11:21:50 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------Q3MtTGqjsB3eophQI8e2re8t"
Message-ID: <dd579644-7ef9-f005-0275-b7384ca731a5@gmail.com>
Date:   Sun, 31 Oct 2021 21:21:48 +0300
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
References: <00000000000035de5905cfa98e03@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <00000000000035de5905cfa98e03@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------Q3MtTGqjsB3eophQI8e2re8t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/21 20:40, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    119c85055d86 Merge tag 'powerpc-5.15-6' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1453e1f4b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6362530af157355b
> dashboard link: https://syzkaller.appspot.com/bug?extid=e3fcb9c4f3c2a931dc40
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1128465cb00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1431dfe2b00000
> 
> Bisection is inconclusive: the issue happens on the oldest tested release.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f27096b00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12f27096b00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14f27096b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com
> 
> Bluetooth: hci0: unknown advertising packet type: 0x90
> Bluetooth: hci0: Dropping invalid advertising data


If packet has invalid length we should check if we won't go beyond 
skb->tail on next iteration.


#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master




With regards,
Pavel Skripkin


--------------Q3MtTGqjsB3eophQI8e2re8t
Content-Type: text/plain; charset=UTF-8; name="ph"
Content-Disposition: attachment; filename="ph"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL25ldC9ibHVldG9vdGgvaGNpX2V2ZW50LmMgYi9uZXQvYmx1ZXRvb3Ro
L2hjaV9ldmVudC5jCmluZGV4IDBiY2EwMzViZjJkYy4uM2UyOTQ1ODRhYTdjIDEwMDY0NAot
LS0gYS9uZXQvYmx1ZXRvb3RoL2hjaV9ldmVudC5jCisrKyBiL25ldC9ibHVldG9vdGgvaGNp
X2V2ZW50LmMKQEAgLTU3OTAsNiArNTc5MCwxMSBAQCBzdGF0aWMgdm9pZCBoY2lfbGVfYWR2
X3JlcG9ydF9ldnQoc3RydWN0IGhjaV9kZXYgKmhkZXYsIHN0cnVjdCBza19idWZmICpza2Ip
CiAJCX0KIAogCQlwdHIgKz0gc2l6ZW9mKCpldikgKyBldi0+bGVuZ3RoICsgMTsKKworCQlp
ZiAocHRyID49ICh2b2lkICopIHNrYl90YWlsX3BvaW50ZXIoc2tiKSkgeworCQkJYnRfZGV2
X2VycihoZGV2LCAiTWFsaWNpb3VzIGFkdmVydGlzaW5nIGRhdGEuIFN0b3BwaW5nIHByb2Nl
c3NpbmciKTsKKwkJCWJyZWFrOworCQl9CiAJfQogCiAJaGNpX2Rldl91bmxvY2soaGRldik7
Cg==
--------------Q3MtTGqjsB3eophQI8e2re8t--

