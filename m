Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200B521FEB9
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgGNUjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgGNUjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:39:20 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8BBC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 13:39:20 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id e11so16975020qkm.3
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 13:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=AP5hmXlF9W9D9O0Hrqruy/ayeuKwiiluiNGpHUfdNLQ=;
        b=Kya6bHdzFUddFVWbk7ioB5MdRiu8hGZCrnykWu/rnYlTkboPfWOMTb/14kmM+nJR5b
         wofTLWhymxV26r3rqmL/LXFNQvczjvSKNJmm6yDl/puXmo6GzbFFm4eT1po9FnZoMcIK
         5gF90d9WiQRyhHNULl0dkcUZQ+TYyAd3IkkJYz5Wlzz3ka/scplhSys0e9pHyhFu5N6h
         JgI9Xvaaf1iLmJufryd6M6TxboBz3X8Vwq/dl6FnojFtJ1Yzi350Ak/aiZiVgpribsfH
         uS77WUgAyoLxiUDdSaRYehrQ20U/J4SiSI/xrfEYGqI+iO8q6v+u+xd5cIBRaAVzU0Wx
         R6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AP5hmXlF9W9D9O0Hrqruy/ayeuKwiiluiNGpHUfdNLQ=;
        b=nUoI6RHTBtksGyjdjhKdBh6aiJtwxqi17A7GxykLZUrfuV8hC/60Orf0tp8eLes7iK
         9X+4feXvLRNcwGCk3cug5yJYFS4DCrgRG7yNsB0OgFTz/jx9Lydqtr5CFm2mrPvNoxC2
         J1FcKPC+DciPTyQQpRvDNSGa4m8ozqVr5sQ0IY2p5v16vNgoXZWpqtdbpI62osGqq1FY
         nngJxs2gWOBQfLbMKTZkFxMJAvdTznNNcdm38RPzkfgq+oIJfc5gVRgI5g4U7mUswbZ1
         l/FEIMZtLtOyCZR+SA0njFAU4aydZKLf53I14A4ZY+eznJSRdc3rm99/CoczNk7WVdTK
         SLXg==
X-Gm-Message-State: AOAM531Vy7JpDlJzCGJCFD5tVSAxhAhIj2S5zD9Ry606csu/zPTtk1nk
        yNdePL3iZF/o2pAhk62SW3A=
X-Google-Smtp-Source: ABdhPJxb218Q89Tj74y/73RVy2fhVRFgmgrUS5IMtqO6wwJrjpVUDFRcHbp7CyjAbwyMnp3vYunF+A==
X-Received: by 2002:a37:444c:: with SMTP id r73mr6364595qka.141.1594759159168;
        Tue, 14 Jul 2020 13:39:19 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:6c1:34c0:e2de:d431:127])
        by smtp.gmail.com with ESMTPSA id o21sm145999qtt.25.2020.07.14.13.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 13:39:18 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E81A6C3360; Tue, 14 Jul 2020 17:39:15 -0300 (-03)
Date:   Tue, 14 Jul 2020 17:39:15 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jarod Wilson <jarod@redhat.com>, Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC] bonding driver terminology change proposal
Message-ID: <20200714203915.GK74252@localhost.localdomain>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <87y2nlgb37.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y2nlgb37.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 09:17:48PM +0200, Toke Høiland-Jørgensen wrote:
> Jarod Wilson <jarod@redhat.com> writes:
> 
> > As part of an effort to help enact social change, Red Hat is
> > committing to efforts to eliminate any problematic terminology from
> > any of the software that it ships and supports. Front and center for
> > me personally in that effort is the bonding driver's use of the terms
> > master and slave, and to a lesser extent, bond and bonding, due to
> > bondage being another term for slavery. Most people in computer
> > science understand these terms aren't intended to be offensive or
> > oppressive, and have well understood meanings in computing, but
> > nonetheless, they still present an open wound, and a barrier for
> > participation and inclusion to some.
> >
> > To start out with, I'd like to attempt to eliminate as much of the use
> > of master and slave in the bonding driver as possible. For the most
> > part, I think this can be done without breaking UAPI, but may require
> > changes to anything accessing bond info via proc or sysfs.
> >
> > My initial thought was to rename master to aggregator and slaves to
> > ports, but... that gets really messy with the existing 802.3ad bonding
> > code using both extensively already. I've given thought to a number of
> > other possible combinations, but the one that I'm liking the most is
> > master -> bundle and slave -> cable, for a number of reasons. I'd
> > considered cable and wire, as a cable is a grouping of individual
> > wires, but we're grouping together cables, really -- each bonded
> > ethernet interface has a cable connected, so a bundle of cables makes
> > sense visually and figuratively. Additionally, it's a swap made easier
> > in the codebase by master and bundle and slave and cable having the
> > same number of characters, respectively. Granted though, "bundle"
> > doesn't suggest "runs the show" the way "master" or something like
> > maybe "director" or "parent" does, but those lack the visual aspect
> > present with a bundle of cables. Using parent/child could work too
> > though, it's perhaps closer to the master/slave terminology currently
> > in use as far as literal meaning.
> 
> I've always thought of it as a "bond device" which has other netdevs as
> "components" (as in 'things that are part of'). So maybe
> "main"/"component" or something to that effect?

Same here, and it's pretty much like how I see the bridge as well.
"bridge device" and "legs".

  Marcelo
