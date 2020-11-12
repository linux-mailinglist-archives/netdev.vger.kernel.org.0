Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3462B0EE1
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgKLUNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:13:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbgKLUNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 15:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605211986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UcIMxlPA0Ij3wo3HO+1X+MRzqmBG91sW8UXbWK56NoM=;
        b=WTBnNJpgOqsAjYa9OhQmn+cUj9pVbbU7Vc5FawOSniCZI/vA5anuTI96gyjZf/x7uOPR+O
        YIEFSuXWQJbQomyyjpMWn6mLXaNK+ZwIxTj9xJEmSGUZUfxn8hFjLFDK3+p4YKcxqje88f
        SVtPdSHaXB7pDwd8Nyeg/zmGMY395MU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-rL4q32IBPZ2Zo5k_lZTKmw-1; Thu, 12 Nov 2020 15:13:05 -0500
X-MC-Unique: rL4q32IBPZ2Zo5k_lZTKmw-1
Received: by mail-io1-f70.google.com with SMTP id z18so4760228ioz.6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 12:13:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=UcIMxlPA0Ij3wo3HO+1X+MRzqmBG91sW8UXbWK56NoM=;
        b=XKnd6XdEoMqrLt4AvMqorbiJkcKRQ9GMbrQjjt992vd7VOH/f0Ci0YGim036PCZFDF
         TKx4oKWEV0M49zUYpdkMKqrX+EZrEszJrGKr91GiiSMueKesZ3Th+oGK/xCQTH0nRQOl
         zj0QxNudu/UDSZHrfD0wxtDISMSePVqb9xuRf9gj9ePi+HyroEFldr0qyT571LKt8ZnQ
         ss4aF6VNikuY5se2v6T09wm1B9kBkK2WQH/mfUay6hd4RXDPX67Ed5CwhaTnZeOsb1Ck
         FSBI7cwcVFDNfM8YsR0ViwXJ43lZ+OJdNfrVK2haodU4g4VyJ2o+DCPxGir3dApZobdb
         RvJA==
X-Gm-Message-State: AOAM532MXbpC6uAFj8UXmwwC48AmGh1I1QP+CYEIdixAF7WEtBTX20C6
        /3PPgvBzT9KrZUK/90uSK4YF05U/5yQQQHWNfwjC98EU9fiZNybe+qR3xSyHQ/XkPdBd5C9xUoF
        62TmT12RxhgXii0sj
X-Received: by 2002:a92:ca8f:: with SMTP id t15mr1068450ilo.19.1605211983953;
        Thu, 12 Nov 2020 12:13:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmFZEJYIs8c9FS5nyeyPzl8LXmXSjj6Obb0ZeFnlGDMRAunYnqNkvQnu+MeTxI6g3LgylZlw==
X-Received: by 2002:a92:ca8f:: with SMTP id t15mr1068434ilo.19.1605211983725;
        Thu, 12 Nov 2020 12:13:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z6sm3627612ilm.69.2020.11.12.12.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 12:13:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5794F1833E9; Thu, 12 Nov 2020 21:13:01 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf] MAINTAINERS/bpf: Update Andrii's entry.
In-Reply-To: <8d6d521d-9ed7-df03-0a9b-d31a0103938c@iogearbox.net>
References: <20201112180340.45265-1-alexei.starovoitov@gmail.com>
 <8d6d521d-9ed7-df03-0a9b-d31a0103938c@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 12 Nov 2020 21:13:01 +0100
Message-ID: <87lff68hbm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 11/12/20 7:03 PM, Alexei Starovoitov wrote:
>> From: Alexei Starovoitov <ast@kernel.org>
>> 
>> Andrii has been a de-facto maintainer for libbpf and other components.
>> Update maintainers entry to acknowledge his work de-jure.
>> 
>> The folks with git write permissions will continue to follow the rule
>> of not applying their own patches unless absolutely trivial.
>> 
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> Full ack, thanks for all the hard work, Andrii!

+1 :)

-Toke

