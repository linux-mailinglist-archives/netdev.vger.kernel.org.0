Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2454AD1560
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731894AbfJIRSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:18:52 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:43000 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731173AbfJIRSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 13:18:51 -0400
Received: by mail-pf1-f180.google.com with SMTP id q12so2023067pff.9
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 10:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZMJV/snI6C/CEZXoxKg9FufmzjYiI8z5knUXpjXkXps=;
        b=QWOUeDyizNA9aVFqmIP+SKhzpIHUb43GjehvHrqkh3P0JYA5Zef0Qzpw1f7xng+LdM
         A4NsnaCHuqq6Fd9V8C9+lgox98UWL6FmPIIzUNElte3OR2N/PULkgp362zEaW3Pf10zm
         JqG9tRNhoqiNJ+BovnfW2LhP3/lFGtEL4V+RZ9Vx9RSa/u8wyB5t/gDDeaY1PeWrNoJa
         ojA+y0oKTtl24SL2ohOfKMmcGuUgWpW2QkTq4GcnuA+1Fu50bBOZV5522LQu1SPXND9G
         slmYfZ6FE7p3TfOqGRAZqi9RVb3fGTADo4qBO1ePQpzlcjBXBYIPZkDCSJIXPqViSOUP
         88KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZMJV/snI6C/CEZXoxKg9FufmzjYiI8z5knUXpjXkXps=;
        b=BO52TUoV+q5Dcu/lumnjRlML9xB6vbxDVO+o3ViIwrrSFyFjku193iiOf2QAFv9wDz
         vrTH4EnBG6iXtU1EFY1Q0ks2upOZ0apLJqgRt7MMc7zsUIftnZGOyeH3lB8Jmr4hgwVC
         dw4Vc0N4qDS0NVi571s0yS1SXtLoE3OFgWLZ+BffYJSppesmrwHwDWBX2GCM5dn7MTJA
         XT4z3zPJjaeI2ramyUkpgiHPOT03RcFyUc6yxCajmdZDz9CKJI1CpHnYQesKPgZZVJSZ
         yfgMbmWYIyBnNDToj+l6o0DclTTt2H3VdvMY8C4xwPQGrO0oq4skHkSr3R7PUWNuYsa2
         syNg==
X-Gm-Message-State: APjAAAXgBTJGOapurJMisZJmbZUR9aNvn7ZVZKInwwUezp3nr8c+TXt/
        XF9BA6dpbDY8gOOMioE+gsI+eQ==
X-Google-Smtp-Source: APXvYqwBQ/MgCnMdknVCiCI0PghiS4n04POjb0K9O6uFQlvD6ACsAoxFfRepYvCC+AxIpkqMy5QmNQ==
X-Received: by 2002:a17:90a:ad0c:: with SMTP id r12mr5508698pjq.1.1570641530603;
        Wed, 09 Oct 2019 10:18:50 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id p66sm3201170pfg.127.2019.10.09.10.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 10:18:50 -0700 (PDT)
Date:   Wed, 9 Oct 2019 10:18:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-10-08
Message-ID: <20191009101836.46bcf268@cakuba.netronome.com>
In-Reply-To: <5fa6cece698e96345dd8cdc19ebb645ec9f6da73.camel@sipsolutions.net>
References: <20191008123111.4019-1-johannes@sipsolutions.net>
        <20191008195520.33532bbe@cakuba.netronome.com>
        <5fa6cece698e96345dd8cdc19ebb645ec9f6da73.camel@sipsolutions.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 09 Oct 2019 08:36:57 +0200, Johannes Berg wrote:
> Hi Jakub,
> 
> > Pulled into net. Let me know if did it wrong :)  
> 
> Oops, didn't know it was your "turn" again, guess I haven't been reading
> netdev enough.

It's more of a ad hoc whenever Dave needs to step away for a day 
or two thing, than a schedule. Also I'm quite happy to pick things 
up from patchwork and the mailing list, so no real need to CC me,
anyway :)

> Looks good, but I didn't think this could possibly go wrong :)
> 
> > FWIW there was this little complaint from checkpatch:  
> [...]
> > WARNING: Duplicate signature
> > #14: 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>  
> 
> Hmm, yeah, so ... I was actually not sure about that and I guess it
> slipped by. Most of the time, I've been editing it out, but what happens
> is this:
> 
>  1) I send a patch to our internal tree, to fix up some things. Unless
>     it's really urgent, I don't necessarily post it externally at the
>     same time. This obviously has my S-o-b.
>  2) Luca goes through our internal tree and sends out the patches to the
>     list, adding his S-o-b.
>  3) For the patches to the stack, I apply them, and git-am adds my S-o-b
>     again because it's not the last.
> 
> So now we have
> 
> S-o-b: Johannes
> S-o-b: Luca
> S-o-b: Johannes
> 
> If I edit it just to be "S-o-b: Johannes", then it looks strange because
> I've applied a patch from the list and dropped an S-o-b. It's still my
> code, and Luca doesn't normally have to make any changes to it, but ...
> This is what I've normally been doing I think, but it always felt a bit
> weird because then it's not the patch I actually applied, it's like I
> pretend the whole process described above never happened.
> 
> If I edit and remove my first S-o-b then it's weird because the Author
> isn't the first S-o-b, making it look like I didn't sign it off when I
> authored it?
> 
> If I edit and remove the last S-o-b, how did it end up in my tree?
> 
> So basically my first S-o-b is certifying (a) or maybe occasionally (b)
> under the DCO, while Luca's and my second are certifying (c) (and maybe
> occasionally also (a) or (b) if any changes were made.)
> 
> 
> Is there any convention on this that I could adhere to? :)

Thanks for the explanation, seems like a reasonable stand so as long as
you're aware this is happening, I'm happy :)
