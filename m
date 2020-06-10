Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ACD1F4BB0
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgFJDKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgFJDKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 23:10:45 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A8AC05BD1E;
        Tue,  9 Jun 2020 20:10:43 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id e1so228946vkd.1;
        Tue, 09 Jun 2020 20:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KZBhwJpe3f99/5LDVB8Bc5/cCcPk7wAvZ6DTVQ9hBQo=;
        b=avSeW6EdipkgvBtqfFwap8GyOTxynTVR7JqrquqYKuotU0/nUvlM7xlHlJ1tAitGDu
         QUYLYb87xZef7qj3qeDE1k4EmFE1cbYmQBfwIp09ULfRs+wYjiabO06Gibetk1NLU5gJ
         rz5CnO6egYTloKqDOFWswZX+Qro6lyuXdsGra+adGQtRrNeqz0rCxNlGxP7ZObqx4AUF
         stvyFWZSCqViy5vTX6NLyPyMg06O5duxH5cDOYMXNueL8NZbQl9UJrPYb9l3LdrILH6E
         mdsSwmmV1rLAh1NQeFdUB2r7ptxXppY9s3qS69KO4aMfegJuLl9rYGsN+J8hVyUg8zJP
         qYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZBhwJpe3f99/5LDVB8Bc5/cCcPk7wAvZ6DTVQ9hBQo=;
        b=DWA14aZkwaQ44lR6kIP/BMdQn4DL4eG6pG7wJnebWakrj9MO9orf8XJX+UG8M0BpgG
         S3C/EObVpyMUfau8z9puNbItd7aMAav0hZcBdcF4Ol+rEuJ0kU/sqB5rjO0mv4dMV0A+
         3FjC1LJWCDCyw68s/RTa6DrRXby8dc1ige7lg9XPj45QlHBw5tdkIHuOvi5T1GKanGbU
         nx2BjSqqiE5xQp/3QeP9AmvwTCb/+aVvqLe50B0ZArdkRbu0mIpzpDVB8uIpf3o1JiiP
         DtXdOGNCOXeyolQoavxa/7o8QdQsoW5EPVLTTub2KGpz7OnFHyLaWGU0+IFVMXRyTGyr
         IHFA==
X-Gm-Message-State: AOAM533ajg6jBaBWKQ/YfLn6b5quzMNkN8X9ME5uK5DMTUz/4jdVOShM
        OzOXjOR5uKdvDbKHtOKT5kxF7sqpINDNxldHZFI=
X-Google-Smtp-Source: ABdhPJwhJJbrVDdVhPbiFe8woY8RZS6gzI8WAuQcnLKqPCqx6QB1rkMVrPvxE9COyN4yin3SLa4xOGD0F8W2ftqaENc=
X-Received: by 2002:a1f:9094:: with SMTP id s142mr886695vkd.6.1591758642398;
 Tue, 09 Jun 2020 20:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609111323.GA19604@bombadil.infradead.org> <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
 <9a79aded6981ec47f1f8b317b784e6e44158ac61.camel@perches.com>
 <CAJfuBxwyDysP30cMWDusw4CsSQitchA5hOKkpk1PktbsbCKTSw@mail.gmail.com> <6115b15ced02686f7408417411ff758445b42421.camel@perches.com>
In-Reply-To: <6115b15ced02686f7408417411ff758445b42421.camel@perches.com>
From:   jim.cromie@gmail.com
Date:   Tue, 9 Jun 2020 21:10:15 -0600
Message-ID: <CAJfuBxzd1Jmd726_zYxfjPy1YgTpcLzLU_fh=pd5FEBaVFCWrw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
To:     Joe Perches <joe@perches.com>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 4:23 PM Joe Perches <joe@perches.com> wrote:
>
> On Tue, 2020-06-09 at 15:21 -0600, jim.cromie@gmail.com wrote:
> >
> > As Joe noted, there is a lot of ad-hockery to possibly clean up,
> > but I dont grok how these levels should be distinguished from
> > KERN_(WARN|INFO|DEBUG) constants.
>
> These are not KERN_<LEVEL> at all, all are emitted at KERN_DEBUG

yes indeed.  but they are chosen by programmer, fixed by compiler.  not dynamic.
<pmladek@suse.com> also noted the conceptual adjacency (ambiguity),
and referenced KERN_<lvl>



If we need this extra query-term, lets call it   mbits / mflags /
module_flags / module_bits
it needs to be module specific, so also requiring "module foo" search
term in the query.
( "modflags" is no good, cuz "mod" also means "modified" - just mflags
is better )

Already, we have function, file, module, all of which convey semantic
structure of the code,
and they also match wildcards, so " function foo_*_* " is an effective grouping.
Id think this would cover most cases.

Finally, all "module venus +p " callsites could be explicitly
specified individually in
universe=`grep venus control | wc -l`
lines, likely a small set.
Using the semantic structure exposed by `grep venus control`, it would
likely be far less.
