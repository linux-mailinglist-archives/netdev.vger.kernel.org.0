Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091692CF6D
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfE1TZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:25:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38783 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfE1TZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:25:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id b76so12083668pfb.5
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 12:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bMllhffribfpwywcmheNotHO1BFen1QpcmxwkEaZ8Tc=;
        b=MiT+lpXRowdMWxQAo38eMyQimWSBvMDETFgCxXg2CuQTExUQnF/f6kVKZm9pplvnK9
         efvVr55hETu1LXIVyWt/qi0waMIUX0XMQnvTZdSTrIcl+ACrPMekHaln6RGrDlwBoyya
         HNdjR+Zj6So4SgxRVKwS55CrPM7eW00dUnEtfasqiIApgoPYDrm73UqJtLZ/Acg1oBNi
         0kNwhdCoqfSh6CWrgg9yZmW399N3CA21bVuiF/VJwO/A9DV2MjWzq4V+GNzBvqtYpcHa
         Dudjadv2BgoQMrtNevVTsKP+Y4BLwxtI5o4+lrqyyh9RAkfjHpoON7iP0p5dFMGeGm/+
         DZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bMllhffribfpwywcmheNotHO1BFen1QpcmxwkEaZ8Tc=;
        b=a5SuJPQyI4mFNprhaPciKHWfjd66H4YY9Y0mwqkoIVPA63TC6Lxb5HxHQitBuKcHIx
         aDsyMscS/Xj/A/d3xgiTm5T3OcQhJN/oB0aH8EuZfi3jf9JC5B0SgfqQzUUwbjhrN3lR
         OuxNsln9lHVNEyG209y5MZjK3qR11k+8VjtlNDNhgOJlWcxoDHZvDXiH/O2mAmBBvZ69
         Z1L55nfLO4PTFUEORJBBdL4C0q/0gmly670Od45SRw0p7w65ZnTLy6ovY5HcOLWI2UVJ
         NNFkub/C0u4tObY48u7Zpp4PKGDnnqDTrCiqwTf39xo7gUY/P6n5tsOhkjwmAIaNEJ2B
         Vq5w==
X-Gm-Message-State: APjAAAW1ibzTBQI0wrU/9VyJ94XRgWAFxLFtjxBr2ftDmG69wuhCxby6
        4hD2RcoFROhtSgZFBf4emShFBOnQdqQ=
X-Google-Smtp-Source: APXvYqwgYdnA4f6trd2hhFjWlC7alrXNMiAv/4lQTLt7ApmMgb0z6luz4EUJ2dSV07KbRYVAbhcr8A==
X-Received: by 2002:a63:c30e:: with SMTP id c14mr14407132pgd.41.1559071557718;
        Tue, 28 May 2019 12:25:57 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q4sm13259534pgb.39.2019.05.28.12.25.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 12:25:57 -0700 (PDT)
Date:   Tue, 28 May 2019 12:25:54 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netdev@vger.kernel.org,
        Philippe Guibert <philippe.guibert@6wind.com>
Subject: Re: [PATCH iproute2] lib: suppress error msg when filling the cache
Message-ID: <20190528122554.0f7dda5a@hermes.lan>
In-Reply-To: <bc4ad34f-96d4-68e2-a67e-afa9e391906e@gmail.com>
References: <20190524085910.16018-1-nicolas.dichtel@6wind.com>
        <bc4ad34f-96d4-68e2-a67e-afa9e391906e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 10:08:28 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 5/24/19 2:59 AM, Nicolas Dichtel wrote:
> > Before the patch:
> > $ ip netns add foo
> > $ ip link add name veth1 address 2a:a5:5c:b9:52:89 type veth peer name veth2 address 2a:a5:5c:b9:53:90 netns foo
> > RTNETLINK answers: No such device
> > RTNETLINK answers: No such device
> > 
> > But the command was successful. This may break script. Let's remove those
> > error messages.
> > 
> > Fixes: 55870dfe7f8b ("Improve batch and dump times by caching link lookups")
> > Reported-by: Philippe Guibert <philippe.guibert@6wind.com>
> > Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > ---
> >  lib/ll_map.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/ll_map.c b/lib/ll_map.c
> > index 2d7b65dcb8f7..e0ed54bf77c9 100644
> > --- a/lib/ll_map.c
> > +++ b/lib/ll_map.c
> > @@ -177,7 +177,7 @@ static int ll_link_get(const char *name, int index)
> >  		addattr_l(&req.n, sizeof(req), IFLA_IFNAME, name,
> >  			  strlen(name) + 1);
> >  
> > -	if (rtnl_talk(&rth, &req.n, &answer) < 0)
> > +	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
> >  		goto out;
> >  
> >  	/* add entry to cache */
> >   
> 
> In general, ll_link_get suppressing the error message seems like the
> right thing to do.
> 
> For the example above, seems like nl_get_ll_addr_len is the cause of the
> error messages, and it should not be called for this use case (NEWLINK
> with NLM_F_CREATE set)

Agree. I merged the patch to ll_link_get but send another to avoid
the cause of unnecessary query.
