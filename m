Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A55107D58
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 07:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfKWG4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 01:56:16 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:47034 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfKWG4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 01:56:16 -0500
Received: by mail-io1-f67.google.com with SMTP id i11so10486651iol.13
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 22:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=sE60Yy1reSegXihltfRgZoXdmWro8SahMcM2s0sm+Ic=;
        b=uup36+ZAPogJJMGOfq2Oek+VtaCMtO0TOjHRVVpuC/lHzFYAW5bQVo7iqeX5sP4iCJ
         5VU0ZOTA0L6XSwCHuTkZjWYAb3yfq9cVmQWgW4fBVBszdykjjwPSaBIc69SS6w89z0OR
         puF36NwAovtNFmaByl+ZpiWGNPKSCKfp+Kt26qT0UQHb45qCBuaxo4CxKN0K3qoscueF
         BC5QT3bTYWI52l2ohgqINnh4325lEjXVcEJVGh/Trbhwkowi6RLJKxIvFMxJzz8ULvC2
         H4M3WJN1uurJrILve5OVnAgONknxhaZpH1WjepJsufSlc2GfN01GgeMfWts/WlJqnpDw
         rgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=sE60Yy1reSegXihltfRgZoXdmWro8SahMcM2s0sm+Ic=;
        b=FW5JLpf7nrF6b1RT2UatZU0uA/sLgCUr+bELexGjoZ+KEtphJXA5M8leyM+82PpvOt
         I1snCoEzcSMkXHh+JyTMH0APYVKWUzrm47iV3pz6jY8gTUCrU8tZlhU3sYzYPPBAICKe
         t3e8MsYHGdKOyE+8tWGI9M1toS0UP7KADFwD4JGogwODW8A/Rieg6D0E9QyYn2PL3WwV
         CugAtGNM2SW0+FtOtZmx35u/12FHxgseKiXUqIP75OyrirPeHQ63EfElTVflE2XR01+D
         2Bd+Wowhbd887zwcu5W58roFG46T+f5iiCjHfalDeMIWpPoQcrg0HXraEKt08r/SiH0B
         3eRw==
X-Gm-Message-State: APjAAAV0QzvRC7OfJZHR4iRURU7MX78UT6DT4KWks1FNfdUyLClw6Na+
        1JLYXaeyRbyuAqXtDE1nl+I=
X-Google-Smtp-Source: APXvYqwjWVCAgQkagiuvGfh9H7gL2jXQs6u7R1/xwkAM6Pi6h93Pu7neDBk123HUhmKR/aSU3SKGYw==
X-Received: by 2002:a6b:660b:: with SMTP id a11mr15990325ioc.283.1574492175601;
        Fri, 22 Nov 2019 22:56:15 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k199sm30204ilk.20.2019.11.22.22.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 22:56:15 -0800 (PST)
Date:   Fri, 22 Nov 2019 22:56:05 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        john.fastabend@gmail.com, daniel@iogearbox.net
Cc:     borisp@mellanox.com, aviadye@mellanox.com, netdev@vger.kernel.org,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Message-ID: <5dd8d805af315_3cdc2b06f70e05b490@john-XPS-13-9370.notmuch>
In-Reply-To: <20191122143624.5b82b1d0@cakuba.netronome.com>
References: <20191122214553.20982-1-jakub.kicinski@netronome.com>
 <20191122143624.5b82b1d0@cakuba.netronome.com>
Subject: Re: [RFC net] net/tls: clear SG markings on encryption error
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Fri, 22 Nov 2019 13:45:53 -0800, Jakub Kicinski wrote:
> > Also there's at least one more bug in this piece of code, TLS 1.3
> > can't assume there's at least one free SG entry.
> 
> And I don't see any place where the front and back of the SG circular
> buffer are actually chained :( This:

The easiest way to generate a message that needs to be chained is to
use cork but we haven't yet enabled cork. However, there is one case
with the use of apply, pass, and drop that I think this case could
also be generated. I'll add a test for it and a fix. This case should
only be hit when using with BPF and programs using apply/cork.

I have the patches for cork support on a branch as well so we should
probably just send those out.

> 
> static inline void sk_msg_init(struct sk_msg *msg)
> {
> 	BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != MAX_MSG_FRAGS);
> 	memset(msg, 0, sizeof(*msg));
> 	sg_init_marker(msg->sg.data, MAX_MSG_FRAGS);
> }
> 
> looks questionable as well, we shouldn't mark MAX_MSG_FRAGS as the end,
> we don't know where the end is going to be..

We use end->MAX_MSG_FRAGS and size==0 to indicate an fresh sk_msg. This
should only ever be called to initialize a msg never afterwards.

> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 6cb077b646a5..6c6ce6f90e7d 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -173,9 +173,8 @@ static inline void sk_msg_clear_meta(struct sk_msg *msg)
>  
>  static inline void sk_msg_init(struct sk_msg *msg)
>  {
> -       BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != MAX_MSG_FRAGS);
>         memset(msg, 0, sizeof(*msg));
> -       sg_init_marker(msg->sg.data, MAX_MSG_FRAGS);
> +       sg_chain(msg->sg.data, ARRAY_SIZE(msg->sg.data), msg->sg.data);
>  }
>  

I don't think we want to chain these here. We could drop the init
marker part but its handy when reading sg values.

>  static inline void sk_msg_xfer(struct sk_msg *dst, struct sk_msg *src,
> 
> Hm?

Nice catch on the missing chaining we dropped across various revisions
and rebases of the code. Without cork support our test cases don't hit
it now.
