Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5FCD2496
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389490AbfJJIru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:47:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389526AbfJJIrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 04:47:49 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B85258
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 08:47:49 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id o10so2385582wrm.22
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 01:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yMEA1vwAxxDR9KMsFNEltEDGLvMYr7N57Wh6Y66WRc0=;
        b=Nd3L2sV7Oe5SlWVlWuoXdGaAC6x0QxjPRdWj3rUXKUP+9Q7fuuLfHCqhGlchS9jKnz
         sLJZyKni4EePCJbuWhlKFyGe7r9FZNdVRD6i1gb/XftJGd+Fd4UHyDA9eqKa1b873Rya
         nGx1rAbtoj20t+BByn0+lsAWpQKTNxPRgzDV+3rM7qiut5/J150pVV9Lhv0kKijxDRLz
         OBP8VSH7Is6D4cUccifV4Vm2NcFbnpyhuiZjgnNpiv/N5ZEDnNpCD6d4sDzLfXUioSl0
         KyDohwUEjDJ+6wYIxpupblAxtu45H8Ie3U8efiR2wQTuHin3EHqzvGt7mDatctspHZ57
         vYsg==
X-Gm-Message-State: APjAAAWIXzGDTwllxw2pirWN1a2Df3JUO3vAv/jlJbN4jYjYVFxHq4Zf
        7o7c/VXP6SY6myho71C0eF0IRX/K9xqF9LHpVsM4AJJ3JjROBHxOD1OBlMFL/Ilj0cR5BJZaKTo
        f4ll7gVXz6tszppGw
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr6460274wmk.135.1570697267774;
        Thu, 10 Oct 2019 01:47:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwGlOe+0u6KXBMrN0A6Ztn9RSeVar+fTIwwT5kQa51LZTkc+efRSchIZ3bkrYo/CFxMwyo8bg==
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr6460257wmk.135.1570697267541;
        Thu, 10 Oct 2019 01:47:47 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id z9sm5103737wrp.26.2019.10.10.01.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:47:46 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:47:44 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/11] VSOCK: add AF_VSOCK test cases
Message-ID: <20191010084744.n46t3ryv7rilkpk2@steredhat>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-8-sgarzare@redhat.com>
 <CAGxU2F4N5ACePf6YLQCBFMHPu8wDLScF+AGQ2==JAuBUj0GB-A@mail.gmail.com>
 <20191009151503.GA13568@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009151503.GA13568@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 04:15:03PM +0100, Stefan Hajnoczi wrote:
> On Wed, Oct 09, 2019 at 12:03:53PM +0200, Stefano Garzarella wrote:
> > Hi Stefan,
> > I'm thinking about dividing this test into single applications, one
> > for each test, do you think it makes sense?
> > Or is it just a useless complication?
> 
> I don't mind either way but personally I would leave it as a single
> program.
> 

Okay, since I had the doubt it was a useless complication and you prefer
a single application, I continue on this way :-)

Thanks,
Stefano
