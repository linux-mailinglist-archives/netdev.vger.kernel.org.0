Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1431923DC42
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgHFQsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:48:08 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39918 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgHFQmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:42:50 -0400
Received: by mail-io1-f65.google.com with SMTP id z6so50313543iow.6;
        Thu, 06 Aug 2020 09:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xm0fEuCIzwDzQykroFSnT+aLdkyYmWsu6Ftt9JukdD8=;
        b=pQJ5Wbk0onBVVfm9KbkO0nmaavZycrP8XIUYtq43nQTVhrVaoIj+HDrpXaQeHZoj59
         bNGNwgQnjRvBDVB/vPd0DsKWMA1sfz2rPl5hAU8wwG+FozqCsYo5t6auZZmEqQJVG2Mh
         /xn53eG5weFyiy3aFt7BcE6R5TgqTEFj2EdR5jSMimAxO8Lx0LgSWY/ZDfj9ItB+8pGk
         kLmKTY4CqlgBxFS59tfv9jMQGLq3KrnNAD77oiUFLKD863sr+Lr0UH5FAd0CAgAhkGpW
         vX0cWACmID12vfpA3D69yKou7Nnb2gE/F6Ew0H2+5tZbjba0LjR4QBgG1jSf3kmWOAhI
         hjHQ==
X-Gm-Message-State: AOAM530Kbs0aPqTvXwfU4E/hDBIMWRR2hASQtLdH+SGIeDHupjYJifa3
        akdjR06qiDIpvz3F5Uhx4JO9CxY=
X-Google-Smtp-Source: ABdhPJyjT8GHER76WNSFqjmQvUAzAjClMjTAIIg56K2M86QwRA9rbhDENI7nQUMj/Vpq8VKa/Li+pA==
X-Received: by 2002:a92:1589:: with SMTP id 9mr11145233ilv.234.1596725235912;
        Thu, 06 Aug 2020 07:47:15 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id s74sm4198158ilb.44.2020.08.06.07.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 07:47:15 -0700 (PDT)
Received: (nullmailer pid 834882 invoked by uid 1000);
        Thu, 06 Aug 2020 14:47:13 -0000
Date:   Thu, 6 Aug 2020 08:47:13 -0600
From:   Rob Herring <robh@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>, pisa@cmp.felk.cvut.cz
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        mkl@pengutronix.de, socketcan@hartkopp.net, wg@grandegger.com,
        davem@davemloft.net, mark.rutland@arm.com, c.emde@osadl.org,
        armbru@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com
Subject: Re: [PATCH v4 2/6] dt-bindings: net: can: binding for CTU CAN FD
 open-source IP core.
Message-ID: <20200806144713.GA829771@bogus>
References: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
 <701442883f2b439637ff84544745725bdee7bcf8.1596408856.git.pisa@cmp.felk.cvut.cz>
 <20200804091817.yuf6s26bclehpwwi@duo.ucw.cz>
 <20200804092021.yd3wisz3g2ed6ioe@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804092021.yd3wisz3g2ed6ioe@duo.ucw.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:20:21AM +0200, Pavel Machek wrote:
> On Tue 2020-08-04 11:18:17, Pavel Machek wrote:
> > Hi!
> > 
> > > The commit text again to make checkpatch happy.
> > 
> > ?
> > 
> > 
> > > +    oneOf:
> > > +      - items:
> > > +          - const: ctu,ctucanfd
> > > +          - const: ctu,canfd-2
> > > +      - const: ctu,ctucanfd
> > 
> > For consistency, can we have ctu,canfd-1, ctu,canfd-2?
> 
> Make it ctu,ctucanfd-1, ctu,ctucanfd-2... to make it consistent with
> the file names.

If you are going to do version numbers, please define where they come 
from. Hopefully some tag of the h/w IP version...

Better yet, put version numbers in the h/w registers itself and you 
don't need different compatibles.

Rob
