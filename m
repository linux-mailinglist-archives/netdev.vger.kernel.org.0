Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADC1BB1D9
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgD0XJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgD0XJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:09:42 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A420C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:09:42 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e6so276974pjt.4
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktpkAkv+FQC2/aYMscfJ1QK9ucmacWt4hvMl30x9ydU=;
        b=dIiN2euSBy9WtcgpVDDTUqqjneiygI2JkvnvbY3C+Ak53Mvc/flwgv08WIz/4kntfl
         vblKiZ9U4+61OWhOo1vU3aILEyMSTsC8Fe2bhKB/z7fD78lmeem8jJsTQtjHhh224ncF
         8IQipx+0GkO63s+9C7RPfIKAwLjSd1hpaoQdGR0Yy4G9XdgKP4rW5lWmxACEXMO3uO9K
         +HWUEQQqoijZJYqAbuW1vXj5Rg0M6dDX060kBFCs5VOlZ0csLFHCjwVgk2SzpIMZjY5j
         lwM04LgwNQ/xTPiAq7IBWPhyArp9UGupeCOO/QBAtF+7xkSSFF9rIc010LCg/qM0sLZa
         JlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktpkAkv+FQC2/aYMscfJ1QK9ucmacWt4hvMl30x9ydU=;
        b=ZC8UqeCG4Es9WNfPKPK3+dzgckQusAILfH8TQqHXwkQmiRmwaKzTnDJPwzAlSDtkbr
         +isgeNb5SidfEMAXD9QAXT8ww57oRmRHU7BMRPdKbdk9uI+xjEiMtY7pqyca7coeBkHa
         JoMqMZXwhxU1L/mPRagdy+q6ZAz+ZfpYuEGGpxm1nMHifwet+STaOBuG/dKLomCW7N2R
         EVfcLRqXgUvsTTWmVwutqji+bm5/Dbo+0q96ARVxyyYbKOnxK9DZ5SzXxLHVGlrN8dbA
         D4F9ZFrxtI2AmZC3uoyxg+ixgyC21NciSiURmRg1oX6EAqStKXRxILIQlZnYN1BEENRk
         +eDQ==
X-Gm-Message-State: AGi0PuadsNCIookohKqOfNGh8ATYClQ0rKOEeLEpVj1Z1DNCi66uCzed
        pcUJ9PPNDeKkK3jN4rtCIPqH5g==
X-Google-Smtp-Source: APiQypJoqtDjtUD2tHKpPOrP5BWi8UZsgO1P6+sMUSpFaV5+ONlzlxk8qoI+eW3D/tTmM3y5ue5dZw==
X-Received: by 2002:a17:902:b402:: with SMTP id x2mr14256051plr.42.1588028981884;
        Mon, 27 Apr 2020 16:09:41 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h5sm323611pjv.4.2020.04.27.16.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 16:09:41 -0700 (PDT)
Date:   Mon, 27 Apr 2020 16:09:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc: pedit: Support JSON dumping
Message-ID: <20200427160938.2cdce301@hermes.lan>
In-Reply-To: <cdb5f51b-a8aa-7deb-1085-4fab7e01d64f@gmail.com>
References: <19073d9bc5a2977a5a366caf5e06b392e4b63e54.1587575157.git.petrm@mellanox.com>
        <20200422130245.53026ff7@hermes.lan>
        <87imhq4j6b.fsf@mellanox.com>
        <cdb5f51b-a8aa-7deb-1085-4fab7e01d64f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Apr 2020 12:23:04 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 4/23/20 3:59 AM, Petr Machata wrote:
> > 
> > Stephen Hemminger <stephen@networkplumber.org> writes:
> >   
> >> On Wed, 22 Apr 2020 20:06:15 +0300
> >> Petr Machata <petrm@mellanox.com> wrote:
> >>  
> >>> +			print_string(PRINT_FP, NULL, ": %s",
> >>> +				     cmd ? "add" : "val");
> >>> +			print_string(PRINT_JSON, "cmd", NULL,
> >>> +				     cmd ? "add" : "set");  
> >>
> >> Having different outputs for JSON and file here. Is that necessary?
> >> JSON output is new, and could just mirror existing usage.  
> > 
> > This code outputs this bit:
> > 
> >             {
> >               "htype": "udp",
> >               "offset": 0,
> >               "cmd": "set",   <----
> >               "val": "3039",
> >               "mask": "ffff0000"
> >             },
> > 
> > There are currently two commands, set and add. The words used to
> > configure these actions are set and add as well. The way these commands
> > are dumped should be the same, too. The only reason why "set" is
> > reported as "val" in file is that set used to be the implied action.
> > 
> > JSON doesn't have to be backward compatible, so it should present the
> > expected words.
> >   
> 
> Stephen: do you agree?

Sure that is fine, maybe a comment would help?
