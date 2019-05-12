Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359071AB07
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 09:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfELHec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 03:34:32 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33257 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfELHec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 03:34:32 -0400
Received: by mail-io1-f67.google.com with SMTP id z4so7708815iol.0;
        Sun, 12 May 2019 00:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yjV02L2Lg3a4KlZGcmCrXQyj1lmIeRP5Nl2cbSpRQtQ=;
        b=ec7zXk/3kB5xKZFXO7ghYMObJD2vDhiie5L6wEyXGc5DPQ7HrdDFgNO7dAczlOhZgp
         RknzyV0qdWHtXChfP7UxdEYrOhFaDnw38F2lsg2nU9Bt5ijzEUOK0q8EDlnLLKW+A9iQ
         JTF7fd5p33kEff5F1C6JkcifgRglY2GXHuBSkOwBLHe6Px6od3/hd4aeZfbMeK8pk/Lz
         a2kTXrHCC5ht0s5qKYsQ4i4KcaddBWvngjb40oiQ2tZSJT2P/FlPVxivfBk7o79VZVn5
         QWsCfiDbKSJcnoN9r3ifkzA8CndClrNCF4L8y26/+HVue72bJJMyV51y3mTTGkj4n90w
         nEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yjV02L2Lg3a4KlZGcmCrXQyj1lmIeRP5Nl2cbSpRQtQ=;
        b=T2stuB9JhmsLD79sLA+OgiEVi6Werq8b9IA9AULRFBWrifIVViYdmpa+DxwU5BV8bw
         rcbYrPQhLoabBRovFroawe0TTwniASUm6mu9+mMY2rTDwv/HMAw4ZdmXfK9PoOvIkd0a
         LbyovrH+68BHdMc/6m6vM1PP/GQam28DHkQQf1NkfTuGOpjFN1q1SSTOANJz8j/HRHDX
         2y2YizyiTBq1QYgP76MGK1qqhWgOZyGNNk+st2ntmn9g0MOznn4tdc+V43nLqtwWhcsl
         eIja0930/Pn0tqTXt8ggNRPTkZxKWaJR/MuOUswM/wtkLJFMuKSth1Pe2VgUuVProXvF
         oqRQ==
X-Gm-Message-State: APjAAAUoeW7oq7+EIIJDFJu9e8t6i6X9Nra3sm9E2VVam57AmguzZwRx
        I7skOsp4UPpvte6zXdqDdfc=
X-Google-Smtp-Source: APXvYqyPZFH7bWLi/IU+f0IdofbSTKGIKNbMTby9HJW92Dh1CNAI3XYselYUqh8yG0gtiOVWp6+xmA==
X-Received: by 2002:a5e:9518:: with SMTP id r24mr12103223ioj.218.1557646471624;
        Sun, 12 May 2019 00:34:31 -0700 (PDT)
Received: from asus (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id y62sm4833926ita.15.2019.05.12.00.34.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 12 May 2019 00:34:30 -0700 (PDT)
Date:   Sun, 12 May 2019 01:34:29 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] selftests: bpf: Add files generated when compiled to
 .gitignore
Message-ID: <20190512073427.GA10811@asus>
References: <20190512035009.25451-1-skunberg.kelsey@gmail.com>
 <20190512062907.GL1247@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190512062907.GL1247@mini-arch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 11, 2019 at 11:29:07PM -0700, Stanislav Fomichev wrote:
> On 05/11, Kelsey Skunberg wrote:
> > The following files are generated when /selftests/bpf/ is compiled and
> > should be added to .gitignore:
> > 
> > 	- libbpf.pc
> > 	- libbpf.so.0
> > 	- libbpf.so.0.0.3
> > 
> > Signed-off-by: Kelsey Skunberg <skunberg.kelsey@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/.gitignore | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> > index 41e8a689aa77..ceb11f98fe4f 100644
> > --- a/tools/testing/selftests/bpf/.gitignore
> > +++ b/tools/testing/selftests/bpf/.gitignore
> > @@ -32,3 +32,6 @@ test_tcpnotify_user
> >  test_libbpf
> >  test_tcp_check_syncookie_user
> >  alu32
> > +libbpf.pc
> 
> [..]
> > +libbpf.so.0
> > +libbpf.so.0.0.3
> How about libbpf.so.* so we don't have to update it on every release?
>

That seems logical. Updated in v2. I appreciate the feedback!

Cheers,
Kelsey

> > --
> > 2.20.1
> > 
