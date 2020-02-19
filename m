Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D6D16474C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 15:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgBSOlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 09:41:46 -0500
Received: from mail-qv1-f46.google.com ([209.85.219.46]:35430 "EHLO
        mail-qv1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgBSOlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 09:41:46 -0500
Received: by mail-qv1-f46.google.com with SMTP id u10so277584qvi.2
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 06:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4aDP6NKQ60FqBblPtGfroFQSVhqrL4oH8p62Os07w4M=;
        b=Vbg3XtJS0rAHVis59pR6+VFOqSrrBLNj/LliWy/dxY+9mhoHigeABMR9P67x9W0rB8
         VEFvxuRzVABiaauwLzCYywZZjE6dXkLuB+6c9xUBcfShakhbiqASqn5saKdidwHUX3F1
         d4xLkzokFn57sCV3BSppU87GOgkbDMMR5Wlww55sQyyCOP+SYfUcwrsIv7kSZMAnBYRo
         ZX0OTx0eyF+ULD2dPhNj/nTJsgUUDjNDyUaOq9K7OR3/Q6SUf+6PDsyCW11u3VEr6UCl
         JI0LD3bUpW+pjzU5/Cn8qRWydk83qVlNrCyGwp5KIV+MSDyzoA5Ja4oGlgT9rhTBvrEu
         u5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4aDP6NKQ60FqBblPtGfroFQSVhqrL4oH8p62Os07w4M=;
        b=kPxZ/3hzs7+PfKAdu+8+64QuMAsy+woXZ4WVnmsQZpEs8BVcqKsbbFfTmh7bhzN+7w
         Ab8diZSWhtKzjxhcttti/QSkGFQkFuGZZP7NjoPfymHEyId3ji/G3EG4oGt9KbAupiv5
         DHrVMDb7O1PfD5ZapZFf2X9ROZP+CSNpTvHHUcajD6TYIRUzqvopY47Pnyb6J5D1PV4F
         6MGHu09E8xbBWzm5fXd8+/1XCAXNNeHz9Vm1K2KUEHBI0xNQ5Cdw/6HU63sEmYLJmOd0
         bV19gTp1V17hjWWR27Tp5nMcguSK7FcOC9EGLDlaRCWmdPPhjMeI+gF1whD66Nd0PiL3
         w+Iw==
X-Gm-Message-State: APjAAAUkfnUDRKv/5EDO9RqikKuW1XbdyDbKkwk1da1gdShyLfPdlIrh
        E4x7dUPTtMEbwVvDklxiu0s=
X-Google-Smtp-Source: APXvYqwqQ+qH2UjFsAgkCOExHjKgjOxBUhpSO4EudT3ApLzKdDKaRhWfyqfDSM1yWhXtYUlw8R9hBw==
X-Received: by 2002:ad4:4dc3:: with SMTP id cw3mr21092832qvb.130.1582123305183;
        Wed, 19 Feb 2020 06:41:45 -0800 (PST)
Received: from ryzen ([216.154.21.195])
        by smtp.gmail.com with ESMTPSA id h6sm72118qtr.33.2020.02.19.06.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 06:41:44 -0800 (PST)
Date:   Wed, 19 Feb 2020 09:41:37 -0500
From:   Alexander Aring <alex.aring@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org
Subject: Re: [PACTH net-next 5/5] net: ipv6: add rpl sr tunnel
Message-ID: <20200219144137.omzmzgfs33fmb6yg@ryzen>
References: <20200217223541.18862-1-alex.aring@gmail.com>
 <20200217223541.18862-6-alex.aring@gmail.com>
 <20200217.214713.1884483376515699603.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200217.214713.1884483376515699603.davem@davemloft.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 17, 2020 at 09:47:13PM -0800, David Miller wrote:
> From: Alexander Aring <alex.aring@gmail.com>
> Date: Mon, 17 Feb 2020 17:35:41 -0500
> 
> > +struct rpl_iptunnel_encap {
> > +	struct ipv6_rpl_sr_hdr srh[0];
> > +};
> 
> We're supposed to use '[]' for zero length arrays these days.

When I do that I get with gcc 9.2.1:

linux/net/ipv6/rpl_iptunnel.c:16:25: error: flexible array member in a struct with no named members
   16 |  struct ipv6_rpl_sr_hdr srh[];

This struct is so defined that a simple memcmp() can decide if it's the
same tunnel or not. We don't have any "named members" _yet_ but possible
new UAPI can introduce them.

Can we make an exception here? I can remove it but then I need to
introduce the same code again when we introduce new fields in UAPI for
this tunnel.

- Alex
