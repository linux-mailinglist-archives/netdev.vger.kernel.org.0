Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0AA140FEA
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAQRcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:32:10 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51455 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgAQRcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:32:10 -0500
Received: by mail-wm1-f67.google.com with SMTP id d73so8231972wmd.1
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 09:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8AdlSujZNGcAzjDA2GVDXNPKHtDnq9lxAbgdmEvnVI=;
        b=byCBCbfZAIr2KjmFnP4t8otAGJdF8GOpBz85JvDe1LpEh60u9dAVfLnI1zbSCQbgeW
         q6oFEt/3npLx9ssubZLAYMkif2kcKVA8F3SBazrwnDTUiO5KgI3qMYQxeJ0SLW3TzY9+
         BRflYPxu/P86oU2v3uIy7wZzWzxKA5GhSLaQ+J8cG4/M2imckrg1ne0OT5RWmXo5Y+df
         SmitCZsBh6tgz0BYdbRcZMXACSfuIGQmy/dKNJVkB8d3KRIQZFw+kMVoqfqkINACDoe2
         oSVO5v3rnWFBDuz1nmq6Y/z85Au0FWPKHct+n+V3GUn/vUeZRmZEVHQamd48VugcnZhi
         C+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8AdlSujZNGcAzjDA2GVDXNPKHtDnq9lxAbgdmEvnVI=;
        b=p1F6CDgwRjRX7aDCdZ/n9gTbruJeAm8umiLeo9Rbp7g95ESxHF59HNH+Nro4wXPcyw
         5k7HSkdpdMldV+jLn9SFx1KDikKT+4VWR2lsSVg1ILRzWMqFTaLd7ZgAIa49tyLcip/S
         iFdHf31N3jBQpBzWdD1di/33uI3fKuWCcTCCsVACwlM8IGLOXPoRYce0Fpw3NT2A+AK5
         OxBr6nhVsRqxtutEUwcsm0x2iNkc8SWPrMEcL/zT+haMYkgoOMOR/GvUcM3NeYx0WOti
         N18DCWA34+hD5C39De2HFiKcutp78iX7cGkU5hON7Ay0CHK0bm6+TSr4ScArWjsspn+Q
         GYAw==
X-Gm-Message-State: APjAAAWPxNQssBlV5ta5RlLTrl1Z0yvscfScw2QUu7nsYahmj4JzhbdE
        kQxpiXooibM7zw84jcg28ovusiu8gfM/YwXjbx8=
X-Google-Smtp-Source: APXvYqylLMjFS8G3n6RMR6gHIb9Oyk4+6tjgBzJkDmrr9O2tazP6bn1VAaumIo7FDFBbYUf78efS8JrvXw4LaPpMzwI=
X-Received: by 2002:a1c:a982:: with SMTP id s124mr5626463wme.132.1579282328464;
 Fri, 17 Jan 2020 09:32:08 -0800 (PST)
MIME-Version: 1.0
References: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579204053-28797-15-git-send-email-sunil.kovvuri@gmail.com> <20200116173322.47271aad@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200116173322.47271aad@cakuba.hsd1.ca.comcast.net>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 17 Jan 2020 23:01:57 +0530
Message-ID: <CA+sq2CeAo7AaWHpTsdaj=uXvY=UxVNa-6Z-e3N=qEOT7yaxoCQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/17] octeontx2-pf: Add basic ethtool support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 7:03 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 17 Jan 2020 01:17:30 +0530, sunil.kovvuri@gmail.com wrote:
> > +#define DRV_NAME     "octeontx2-nicpf"
> > +#define DRV_VERSION  "1.0"
>
> > +     strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> > +     strlcpy(info->version, DRV_VERSION, sizeof(info->version));
>
> We generally discourage the user of DRV_VERSION these days and suggest
> to return the kernel version here. With backports and heavily patched
> distro kernels this number quickly becomes counter-informative.
>
> Thanks for the changes to the stats!

Okay, will remove the version info.

Thanks,
Sunil.
