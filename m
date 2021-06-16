Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A503A981E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhFPKwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbhFPKwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:52:32 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11E1C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 03:50:25 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x24so3551139lfr.10
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 03:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Goo5PYRM5K9l0HtKc4Pi5tcnXNaGZfrwehALF98shRs=;
        b=MinDoi+4KQqD3bxrxrZwzeGPrtD1LqYvDcp2V8lWroeSQ84aG8Zl7I56b2zRtLAmlR
         HvJkIqByCpHPGJgw80/Wio7FdCsw+4UnTXmd28zS9wVjSvGQQ3o7GmsRNt9Z1rHjcALv
         w6d5XD+ffwC87A8yKvPS4mFwjzEE0cHKeY8lgs+lggswHmI1EsT54VVYWWnrdpSFrb9C
         HHR1StjoVsFXgqLl2VNDbjVIuS4eddqKbrf/+HlEaBVCoegup5PEku4Dl8CB8rNh5L7v
         pZh+nzzyqnvL1Q7m5frG0oSHlZhPr3IX2BT1txXpSZGEiNHIvpXeFB0nONDZrn+e7dGf
         Uv5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Goo5PYRM5K9l0HtKc4Pi5tcnXNaGZfrwehALF98shRs=;
        b=pLNpbfs8S414VAwtQHYsDbFLBtX8WUAnlh/MsOxYnpnm4SYYQ56QTJO9rMID68l60H
         25pTfBPCKE+YA+Db3KWKx6KdnQ5qnCryK7m+C+AsRPUX1IXxukGHjo18e8nyvfoh/bol
         MT8ynGFUZ46iFvsLGlE7tva3pwT51PQHQeN34DcN/RamacIF9XVCx+iKUXH0EcGDkjq6
         zo1N4wq0GSrTLTVTg6MWIbcWIUiJTzToQaltcZCPHssk8YDbxJnmOH/oyEulUlWk5jzS
         4wJETa0BJbR2xbrPtIhy9a0OfY3PoRMb3tKof8qiW2GnnxBj+8VAu60OJFZcX+OK0TN0
         3x8A==
X-Gm-Message-State: AOAM530VB/hav9WPwgeVjs5uh8OWIrXdamz/D9xCA7NlBbZxA/z3erEs
        sl4Lxp752Fue6nDCQw89Tm7hSL4SjJLThxA/fgBFA6s+fi8=
X-Google-Smtp-Source: ABdhPJyjqL/qq4IM4uuW0kxTf2eyKdJPoeoy6EM2BhLly4swBVbyXaRfKNZPpG1srsgWLwe3cfiRO0spYaRi0Ru6S/Y=
X-Received: by 2002:ac2:5e64:: with SMTP id a4mr3258735lfr.657.1623840624230;
 Wed, 16 Jun 2021 03:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210608153309.4019-1-littlesmilingcloud@gmail.com>
 <20210608153309.4019-2-littlesmilingcloud@gmail.com> <20210614195700.260c8933@hermes.local>
In-Reply-To: <20210614195700.260c8933@hermes.local>
From:   Anton Danilov <littlesmilingcloud@gmail.com>
Date:   Wed, 16 Jun 2021 13:49:48 +0300
Message-ID: <CAEzD07KJOp9q0RfQMhjLuc2MH2-toMCECKxS594=pYJqaUNLMg@mail.gmail.com>
Subject: Re: [RFC 2/3] [RFC iproute2-next] tc: f_u32: Fix the ipv6 pretty printing.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 at 05:57, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> Ok, but better yet, upgrade f_u32 to do proper JSON output.

Yep, I'll send the JSON output patch soon.



--
Anton Danilov.
