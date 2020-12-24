Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30142E25C3
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 10:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgLXJuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 04:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgLXJui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 04:50:38 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87129C061794;
        Thu, 24 Dec 2020 01:49:58 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id lj6so878265pjb.0;
        Thu, 24 Dec 2020 01:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pR2ACc6d8aTjF9n2K3igB+WCeCgG4pxrdUZ6N6y3XI8=;
        b=F0hRaYSIk4MzxylL/ODRdzxdbcBJG2XTEKKFPPjS/e6+wv80GeoxPfKfzYneDuCNCC
         CHiQngXEUCEHaSxZQbe0EvGvKuJBzn4uUQZsOhoNlBfM+EQD+7hcS2TdqDQDPXg7aq24
         IWm8zHFInPmY9dfoaethXfjxzbiY0N/7CjnmYXj+r/riZAy5ljkCgDOPqsUYVMlzWFt9
         qIrGIel3ehiGDT3y8ufUGJCvnvZ5BfpnpjxelSVkfc5Xl1Q968ZWdYclR7PNXWzTMlUP
         ApzZ1jaXDMRwxhwewd2oMVNALF06JfTuUJBrmCYUieUpyd1Pyu36pOE7PYZqJcYpQkcH
         hSjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pR2ACc6d8aTjF9n2K3igB+WCeCgG4pxrdUZ6N6y3XI8=;
        b=i2ZHrqwuAs/SNiS49OO37d6SjCCBboxzCW3EwMNP2sOi4UrQlszvMs9CA1AyscqfPv
         47HFDjuWHH8aSrAtaW7HhQzPobLpz8yx1MVBXzM2sJ+/Moqx6xOJoh6yWEa0OlXA54CC
         T7L3h10gOH7c0mcg9B1BsW89C5hxzC/8i+dL4VSZlBljYh0cYcAYWQGZx3RgKilPCM40
         FsxTrNN7SVKeml9ZEOf3DGKPiunthD11ciBFyXlwN3iS9a/pm0lXW42f4sD+HAm3Eq4t
         +6N4iJrHis9DbkQGfb+LjlIy71hJxQkPBw6xe1LixSJ0lh53oiA5jNtkjnEJfOAMlg9H
         VgeA==
X-Gm-Message-State: AOAM532QQhFuwl0miYMqwi2b8eeLPJFGD0FQb2wP6O+sfo3AOtijsJsC
        WkXarmHpmYfhu1RG9vdYEKXO41MxPHVbvgx9jLs=
X-Google-Smtp-Source: ABdhPJx6rI4RiBLIO4l3nCt1PYNHCcwysmC0IXsyW95+37z9CtvbEcPAuccSa7faEIs2R4EY4ijJ9MtYuA7iy5RTf/8=
X-Received: by 2002:a17:902:9a4a:b029:dc:435c:70ad with SMTP id
 x10-20020a1709029a4ab02900dc435c70admr13573744plv.77.1608803398081; Thu, 24
 Dec 2020 01:49:58 -0800 (PST)
MIME-Version: 1.0
References: <20201223021813.2791612-75-sashal@kernel.org> <20201223170124.5963-1-xie.he.0141@gmail.com>
In-Reply-To: <20201223170124.5963-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 24 Dec 2020 01:49:47 -0800
Message-ID: <CAJht_EOXf4Z3G-rq92hb_YvJEsHtDy15FE7WuthqDQsPY039QQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 075/130] net/lapb: fix t1 timer handling for LAPB_STATE_0
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 9:01 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> I don't think this patch is suitable for stable branches. This patch is
> part of a patch series that changes the lapb module from "establishing the
> L2 connection only when needed by L3", to "establishing the L2 connection
> automatically whenever we are able to". This is a behavioral change. It
> should be seen as a new feature. It is not a bug fix.

Applying this patch without other patches in the same series will also
introduce problems, because this patch relies on part of the changes
in the subsequent patch in the same series to be correct.

Hi Martin,

It's better that we avoid using words like "fix" in non-bug-fix
patches, and make every patch work on its own without subsequent
patches. Otherwise we'll make people confused.
