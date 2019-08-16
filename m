Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAF390A9F
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfHPWBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:01:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33616 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbfHPWBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:01:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so3593651pgn.0;
        Fri, 16 Aug 2019 15:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=dWMHoo7zy5ro+gPfK7r7C9aoJ9XMNHd5EkfhgDYq2io=;
        b=LwIltLncEeFNdJYXoqGTJocMGGOj0Lg9xJIqK6w4TpXIKb34G9ISsaaZzYHwGNM90e
         +p0m3Meh3mZO/YykNbhnl2K6G+Aj4A0mgoxenX5pTs4Uy0PWO4uUvZ4o4mJzrdlo+iao
         OZICN2buLu2t1qgV4K8PJ5YeynAKYeYvKxdWkhscnUl5BlJLNlRvSvMDOfWZluDnNU+B
         PEKXayPfVBJxFzA/N4DwhTgYJJf7Oa3V/j39LBm8DN64kL0J4FXYF8BtPAuyZ3rmLkmd
         cWQjZ4dnpTYL6ZLTx8nZCcaIwUGEB9AJixrtcMXOn5z1u/TKCO0KzjXpRjF7mO0Bfphd
         4wpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=dWMHoo7zy5ro+gPfK7r7C9aoJ9XMNHd5EkfhgDYq2io=;
        b=oBoTTik7lPBte4uYOWfGqwzb2QLNfWVJv4s4+MwFfgab3tANkFwmIPOhoWzBAt1wV2
         LXW52NRJ25c6b3jNA6Y76EymP7Gwgjofi/0mikeF8Bhs6FCy3hZw5zP4cRdBo+lg1Ypm
         tJbsznQTkVhvk3LPwSfzuwML3hFSYJzYwPTUBcBrR/NZSFlYXAMe5xEA9uoPMK4Ky5Nn
         bIWZmJZBVzyuhm9mBjf9QMu0R1wZ0fp6OAmRQy1RPisdCpnPkdqkDWMOs0u1PPCGLW6f
         cb6XeOnExc+2cK/ElbXBTJSt55O93f3urwVn9Xsa3vzXQODGFia5rMlY5p7NCFQOvVpQ
         EXkw==
X-Gm-Message-State: APjAAAVr2d+RD/LxC+0SDYnHtgRo+eQOMLJR+mZcnNp8BcyclPZOkT5H
        5NglqgXJvWoAJtWxssu2/SfOlAT8
X-Google-Smtp-Source: APXvYqzYae918bOj1V4zW1RDJQqkzK7RNhZCHLfvCJFTfk87w2sYSffrhNgWH0+zW1Mng7zE1hUiAw==
X-Received: by 2002:a63:31c1:: with SMTP id x184mr9881417pgx.128.1565992869213;
        Fri, 16 Aug 2019 15:01:09 -0700 (PDT)
Received: from [169.254.4.234] ([2620:10d:c090:200::3:e378])
        by smtp.gmail.com with ESMTPSA id e13sm7664950pff.181.2019.08.16.15.01.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:01:08 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Yonghong Song" <yhs@fb.com>
Cc:     "Magnus Karlsson" <magnus.karlsson@intel.com>,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: remove zc variable as it is not used
Date:   Fri, 16 Aug 2019 15:01:06 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <2B143E7F-EE34-4298-B628-E2F669F89896@gmail.com>
In-Reply-To: <f3a8ea34-bd70-8ab8-9739-bb086643fa44@fb.com>
References: <1565951171-14439-1-git-send-email-magnus.karlsson@intel.com>
 <f3a8ea34-bd70-8ab8-9739-bb086643fa44@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16 Aug 2019, at 8:37, Yonghong Song wrote:

> On 8/16/19 3:26 AM, Magnus Karlsson wrote:
>> The zc is not used in the xsk part of libbpf, so let us remove it. 
>> Not
>> good to have dead code lying around.
>>
>> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>> Reported-by: Yonghong Song <yhs@fb.com> > ---
>>   tools/lib/bpf/xsk.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index 680e630..9687da9 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -65,7 +65,6 @@ struct xsk_socket {
>>   	int xsks_map_fd;
>>   	__u32 queue_id;
>>   	char ifname[IFNAMSIZ];
>> -	bool zc;
>>   };
>>
>>   struct xsk_nl_info {
>> @@ -608,8 +607,6 @@ int xsk_socket__create(struct xsk_socket 
>> **xsk_ptr, const char *ifname,
>>   		goto out_mmap_tx;
>>   	}
>>
>> -	xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
>
> Since opts.flags usage is removed. Do you think it makes sense to
> remove
>          optlen = sizeof(opts);
>          err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, 
> &optlen);
>          if (err) {
>                  err = -errno;
>                  goto out_mmap_tx;
>          }
> as well since nobody then uses opts?

IIRC, this was added specifically in 
2761ed4b6e192820760d5ba913834b2ba05fd08c
so that userland code could know whether the socket was operating in 
zero-copy
mode or not.
-- 
Jonathan
