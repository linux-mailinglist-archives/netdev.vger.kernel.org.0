Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 754BD18746A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbgCPVBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:01:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41986 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732571AbgCPVBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:01:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id h8so10420230pgs.9
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FykSs6ArRQ1VTW0edGQU9r+oRpdoLevjlWnrbNH8SzQ=;
        b=F/mKIGm2VSDsMdeG2UN7tdnBaLkXajwusX1FSQGsszz2c2mkMYP00hgIofJTgrQDW1
         SlYcjtn0dgAw7izmdBv71zLnPNljO/N2mb5wfEaVhtU0iQ3ICwa7+j1vTDbBcOdxXrmc
         L4SVReMbOZrT0y9fUuU3TP449id5RqEw/5/u0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FykSs6ArRQ1VTW0edGQU9r+oRpdoLevjlWnrbNH8SzQ=;
        b=ZFuq+TWTmx1QyILv82eE04TLJhEpbfrwqdzCqjxH7PWSurb/U2Q6UWc3/OZJqmP+dm
         dv4HSmY7AvHpQlJPVh7weQ4KdWBG30NfyIbgV0xtQVifSRPsWEp4f05yQsAe+GHPnV7Q
         +8124mLXd+p+eluazad+nvO9fjb6RzLD4qO6OTS6eCVVjqG0GRjHQf6fPfB2WAXV/IIH
         aH3IY4TDNyFHHgE2Ea6xS3VFju5ay8K+dJ12zmaJxZ6b/bGFXltRvondjxZNyu5igwuC
         xwzkjwPYsg0R0fKoX+o7eqQS3VGC/6RmGKVLCiI+U325oTUs46jjeeaSMbpSnKrRk/2X
         /JqQ==
X-Gm-Message-State: ANhLgQ05oB6wVUh5MtLmUkZYYVi2Qe9tYgdIogGbzmUS1hS6bP+U+tDS
        IaeCzwu06Nm/h9noP1My/QBRMg==
X-Google-Smtp-Source: ADFU+vspzRBYngPdmN2Sb7yi3ynFWRC4K625gLz2x5YvOEj/9r9JVqHRh4cG4ZtIaq7Mzq78lwob+g==
X-Received: by 2002:a63:7c4:: with SMTP id 187mr1570289pgh.369.1584392495839;
        Mon, 16 Mar 2020 14:01:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p4sm747093pfg.163.2020.03.16.14.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 14:01:34 -0700 (PDT)
Date:   Mon, 16 Mar 2020 14:01:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Bird, Tim" <Tim.Bird@sony.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH v2 0/4] kselftest: add fixture parameters
Message-ID: <202003161356.6CD6783@keescook>
References: <20200314005501.2446494-1-kuba@kernel.org>
 <202003132049.3D0CDBB2A@keescook>
 <MWHPR13MB08957F02680872A2C30DD7F4FDF90@MWHPR13MB0895.namprd13.prod.outlook.com>
 <20200316130416.4ec9103b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316130416.4ec9103b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 01:04:16PM -0700, Jakub Kicinski wrote:
> Variant sounds good too, although the abbreviation would be VAR?
> Which isn't ideal. 
> 
> But I really don't care so whoever cares the most please speak up :P

Let's go with "variant" and just spell it out.

> > BTW - Fuego has a similar feature for naming a collection of test
> > parameters with specific values (if I understand this proposed
> > feature correctly).  Fuego's feature was named a long time ago
> > (incorrectly, I think) and it continues to bug me to this day.
> > It was named 'specs', and after giving it considerable thought
> > I've been meaning to change it to 'variants'.
> > 
> > Just a suggestion for consideration.  The fact that Fuego got this
> > wrong is what motivates my suggestion today.  You have to live
> > with this kind of stuff a long time. :-)
> > 
> > We ran into some issues in Fuego with this concept, that motivate
> > the comments below.  I'll use your 'instance' terminology in my comments
> > although the terminology is different in Fuego.
> > 
> > > Also a change in reporting:
> > > 
> > > 	struct __fixture_params_metadata no_param = { .name = "", };
> > > 
> > > Let's make ".name = NULL" here, and then we can detect instantiation:
> > > 
> > > 	printf("[ RUN      ] %s%s%s.%s\n", f->name, p->name ? "." : "",
> > > 				p->name ?: "", t->name);
> 
> Do I have to make it NULL or is it okay to test p->name[0] ?
> That way we can save one ternary operator from the litany..

I did consider Tim's idea of having them all say 'default', but since
the bulk of tests aren't going to have variants, I don't want to spam
the report with words I have to skip over.

And empty-check (instead of NULL) is fine by me.

> To me global.default.XYZ is a mouthful. so in my example (perhaps that
> should have been part of the cover letter) I got:
> 
> [ RUN      ] global.keysizes             <= non-fixture test
> [       OK ] global.keysizes             
> [ RUN      ] tls_basic.base_base         <= fixture: "tls_basic", no params
> [       OK ] tls_basic.base_base         
> [ RUN      ] tls12.sendfile              <= fixture: "tls", param: "12"
> [       OK ] tls12.sendfile                 
> [ RUN      ] tls13.sendfile              <= fixture: "tls", param: "13"
> [       OK ] tls13.sendfile                 (same fixture, diff param)
> 
> And users can start inserting underscores themselves if they really
> want. (For TLS I was considering different ciphers but they don't impact
> testing much.)

The reason I'd like a dot is just for lay-person grep-ability and
to avoid everyone needing to remember to add separator prefixes --
there should just be a common one. e.g.  searching for "tls13" in the
tree wouldn't find the test (since it's actually named "tls" and "13"
is separate places). (I mean, sure, searching for "tls" is also insane,
but I think I made my point.)

-Kees

-- 
Kees Cook
