Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03582E2C7A
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 23:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgLYWOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 17:14:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726737AbgLYWOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 17:14:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608934394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djDla7QC8stvJV4tixUAcw5nNMxJs92TkvEUyKHn9Vg=;
        b=iyXFKTye7amsEzSeBW4GlB1zt7HOdXPyS3B7rFHfjOhL+ohr4S3g3kBxZ3f+NF0LEJ9vVh
        xa2XUC3BmMi8HuN+fMqzMGQwJLlJ7W6bZbPRg6WFdO8izoWr5YWXxTK9nYo6iF+pvNtJRY
        dVrZbz6PgGNxa77UgBFzdU61ZzdhkyE=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-VVWDAMOLMyqlm1yVuIPTtg-1; Fri, 25 Dec 2020 17:13:12 -0500
X-MC-Unique: VVWDAMOLMyqlm1yVuIPTtg-1
Received: by mail-oo1-f71.google.com with SMTP id a5so2407147oob.4
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 14:13:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=djDla7QC8stvJV4tixUAcw5nNMxJs92TkvEUyKHn9Vg=;
        b=Njiat9xY/86+pQG5o6jpl1w8YPCj3DzE36fG5x70IrFD9Ijz3qVqu7KqsXODyT5jux
         OQQpA4/3dHjMRDj1VLIW7UXCTKTQf8wv5gjgYd349dlQPZsAxwvncQXw8Hedt+Wyk5PE
         zt9R/DHMOJdaP6a8L6Dn28aMGfSjIp1ZivnIV0SK0Z52xhjnasb0BtHSnIpI8yraqxjs
         EthHTAmAuH6m8zBfbLPwimIvUfofioM1e3/KuqQyns0waQy6T0r7ym6vIkrDc3EKTlO2
         RNtPJan08KunweD8u6IKaiydtpNqcs87ley6ktauTwB6CWW9XIOmOEX25kHYisPzTqIV
         PtFQ==
X-Gm-Message-State: AOAM530U+R6lEsRFtQfChVeX6RC3Qg1LwTVIRa18h9CNpnSjx/rPg4Hk
        0CXt61kgBxKj5v4yyg3JNA+lMahgC9I/MsOyEacfETZddeIU0jSgLhzXYBMG8IvzLN87Evmg5tt
        xqCW5oiGdIKp8iBQ9
X-Received: by 2002:a05:6830:114:: with SMTP id i20mr25982229otp.20.1608934392166;
        Fri, 25 Dec 2020 14:13:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJpR9lfMGCJ88XnkdY/FBVOnq4zIsz+YSGbfz9PGiOt60dSXbfTPKL9rOPGWuEai5fY964Sg==
X-Received: by 2002:a05:6830:114:: with SMTP id i20mr25982216otp.20.1608934391944;
        Fri, 25 Dec 2020 14:13:11 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id n13sm7651392otk.58.2020.12.25.14.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Dec 2020 14:13:11 -0800 (PST)
Subject: Re: [PATCH] nfp: remove h from printk format specifier
To:     Joe Perches <joe@perches.com>,
        Simon Horman <simon.horman@netronome.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, gustavoars@kernel.org,
        louis.peens@netronome.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com,
        linux-kernel@vger.kernel.org
References: <20201223202053.131157-1-trix@redhat.com>
 <20201224202152.GA3380@netronome.com>
 <bac92bab-243b-ca48-647c-dad5688fa060@redhat.com>
 <18c81854639aa21e76c8b26cc3e7999b0428cc4e.camel@perches.com>
 <7b5517e6-41a9-cc7f-f42f-8ef449f3898e@redhat.com>
 <327d6cad23720c8fe984aa75a046ff69499568c8.camel@perches.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <65755252-96c3-a808-3e01-e377dd395ee7@redhat.com>
Date:   Fri, 25 Dec 2020 14:13:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <327d6cad23720c8fe984aa75a046ff69499568c8.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/25/20 9:06 AM, Joe Perches wrote:
> On Fri, 2020-12-25 at 06:56 -0800, Tom Rix wrote:
>> On 12/24/20 2:39 PM, Joe Perches wrote:
> []
>>> Kernel code doesn't use a signed char or short with %hx or %hu very often
>>> but in case you didn't already know, any signed char/short emitted with
>>> anything like %hx or %hu needs to be left alone as sign extension occurs so:
>> Yes, this would also effect checkpatch.
> Of course but checkpatch is stupid and doesn't know types
> so it just assumes that the type argument is not signed.
>
> In general, that's a reasonable but imperfect assumption.
>
> coccinelle could probably do this properly as it's a much
> better parser.  clang-tidy should be able to as well.
>
Ok.

But types not matching the format string is a larger problem.

Has there been an effort to clean these up ?

Tom

