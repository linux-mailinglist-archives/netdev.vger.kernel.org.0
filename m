Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA299218C63
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgGHP7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbgGHP7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:59:37 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C37CC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:59:37 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f2so18355170plr.8
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dfsy8YM0DDECiIz6MPnrjWaP9lAaD4OKRogI6YWiw3s=;
        b=sFJ0rCE7LHvqOZN0IrLznh9iYrKZVGVzBrgwa6ljr+3y6/GsYXhigq36JEmMO935X/
         DZC3o+cBed27FFbtR0i0uRTJvt4RA/nYzpVV1r6x4EvV5U/s0xWM+UCEQoln9vVsv+Ba
         UtRA6J5OBqSL+g1V87+LI7eQz2fYvMbl8aXkosYJfHiCZb+nCDPfsVjR3PczyccOCLAP
         INj8ts8Oq3GDx9aNm9OZqfOJz/tc70fxcbXbISJ3rabD8UimqbcXChu8/7tUAbOWnapL
         b1KlUNZ34mh7P1RbsAFoGqmRKKWpGowTWmGyKc9Mn9RAnOrOLzwnhPsVBzoSQ44PawIB
         2IfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfsy8YM0DDECiIz6MPnrjWaP9lAaD4OKRogI6YWiw3s=;
        b=Yui+wDTwANndTf2+7xNHoNaMUzmdjwqAIvSm2e6CVVU8w8IdpfE3Zvow5HnPX9IXgk
         KwLUf8YJmfhpe9ww0aEA4ipp/EAqIcYw7HVr886aHuGXXvgSFwE6LC/OLv8z0niEEQGA
         Q6NrYw5+Cg4Qf30X2Pq3mrsNi7SzP6RvkyugW2+Fn8C5N/fg7zYXEpgrueVR0cHZIKWS
         rJsgLYusPta31gDdcCuuaReaSb7N6AuclCmwQ0rQTpV+CiYBeWDCNZbLCyr8pLnbSTep
         GVCihrIyHCjqsnMeJwVYXLABp2sS+sfuvl3v7fG6SlOWHQMI14HxrgCvn+z4aDpVUCgV
         OmUw==
X-Gm-Message-State: AOAM533tybxSHILvIW2MHsswZDJzvcEPjGAeuUSOsZ6+1LhqHYs20MdU
        hWr5u1cU481p6MWPXLTDm6lTuA==
X-Google-Smtp-Source: ABdhPJxgB0YFveeiA/rQS1rhLcG5Jj0QD7bwS2yR8UhDe2ujNQo1rB2jxlPmVfgQoY69XUQILVuk/Q==
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr10571266pjp.228.1594223977098;
        Wed, 08 Jul 2020 08:59:37 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i13sm70444pjd.33.2020.07.08.08.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 08:59:36 -0700 (PDT)
Date:   Wed, 8 Jul 2020 08:59:33 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Evelyn Mitchell <efmphone@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] man: ip-rule.8: minor changes
Message-ID: <20200708085933.261507bb@hermes.lan>
In-Reply-To: <CABD0H0sKx14FoWthLAC9MijT4q7RYOdZhyW_x-JPHdFm+=ggXw@mail.gmail.com>
References: <CABD0H0sKx14FoWthLAC9MijT4q7RYOdZhyW_x-JPHdFm+=ggXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jul 2020 11:40:37 -0600
Evelyn Mitchell <efmphone@gmail.com> wrote:

> These are grammatical and typographical fixes, with one wording change.
> 
> Evelyn Mitchell
> tummy.com

The wording change looks fine, but the patch has a couple of issues.
First, you did not include a Signed-off-by: as required.
See Linux kernel documentation on submitting patches.

Second, the patch was not formatted in a way that it could
be automatically consumed by git (or patch) commands.

Lastly, it looks like your mail client maybe modifiying the
patch when sending. Hard to tell because of the patch formatting issues.

Please fix the above and resubmit.
