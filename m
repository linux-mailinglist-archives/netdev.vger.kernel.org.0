Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9518C3B4A52
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 23:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFYV61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 17:58:27 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:46912 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYV60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 17:58:26 -0400
Received: by mail-pg1-f170.google.com with SMTP id w15so4732499pgk.13;
        Fri, 25 Jun 2021 14:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=COkBtu1DRhiaP0VAr6IF4em+cKZJHXcKly1cODZLhlU=;
        b=E2qXIbpbfSiZzo016OGLYvv+gB2DJ1xp6xKujSqzct07fSJX3GEMRO7v3G3/Lu0aiu
         3Nl8HpK5GQNg/Stxux/U5GYhOAyZ6KzQ7AZuw+zKcRghQSaKwVWNsgRvFv9tvQQMqjEb
         zwdMKacCiIun2hgEZmZYjCHBr3PyszJnW+vTShSs3fNF8/YovbxVAxrvQZMu095v7u/n
         K1YFlBzl83ytrDreG3Tg6utR676nuA3SWP1mz+mJgvEyn7X7Bw4L3+l0/TOrJFwxE9pO
         cUZ3qJ4Cfr0s7RW2jCagnl1SfkwxsUuxroxIAuQLPCC03LG8kreutZ7sT5TOjtPE+L3/
         1gmw==
X-Gm-Message-State: AOAM533jmlMZRq7b/8D4q3s59SG6+M7i7pg81kK0jaQ/3AMPiBwTe3MG
        STo8E+ybSWcWV/g0KuBTzNI=
X-Google-Smtp-Source: ABdhPJysJnt068twgh+M6kfI/lanpHpG9o2CTZadWdqX2+ccdXUp7CnEuUaVxvgXa6bu00QvpLZkkg==
X-Received: by 2002:a63:d74c:: with SMTP id w12mr3194280pgi.91.1624658163667;
        Fri, 25 Jun 2021 14:56:03 -0700 (PDT)
Received: from garbanzo ([191.96.121.71])
        by smtp.gmail.com with ESMTPSA id h1sm11760433pji.14.2021.06.25.14.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 14:56:02 -0700 (PDT)
Date:   Fri, 25 Jun 2021 14:55:58 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com, jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sysfs: fix kobject refcount to address races with
 kobject removal
Message-ID: <20210625215558.xn4a24ts26bdyfzo@garbanzo>
References: <20210623215007.862787-1-mcgrof@kernel.org>
 <YNRnzxTabyoToKKJ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNRnzxTabyoToKKJ@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 01:09:03PM +0200, Greg KH wrote:
> thanks for making this change and sticking with it!
> 
> Oh, and with this change, does your modprobe/rmmod crazy test now work?

It does but I wrote a test_syfs driver and I believe I see an issue with
this. I'll debug a bit more and see what it was, and I'll then also use
the driver to demo the issue more clearly, and then verification can be
an easy selftest test.

  Luis
