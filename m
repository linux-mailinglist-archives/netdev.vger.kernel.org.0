Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AD33B9102
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 13:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhGALQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 07:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhGALQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 07:16:02 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D6BC061756
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 04:13:31 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i18so10162144yba.13
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 04:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=klS5qEHFw0JleAQwvbTW7kVh/K0JIRi872KOykaSGiE=;
        b=c4Pagk9xuRBQSVsL33+R7LmwKWgLEvFH9jsNxoEmy7IB4OTimeyNemw6NDRcLvraGO
         OylvNHSu5myaVOazYLXCWl+901LWaDbpAHEgMqTMJ6cPK6RPgTJygACpbjl2yruZRrxT
         7ezAgcp1l3wGoCVAdFObHDKj5VF5v8tkkMSm1d3yQfJEweqSVmNOOtSg1VWQzXY3gJ7O
         sYPafYu8rBIHj+r4bTIogZYd+A9nNm4XO9qv5KSQtCLLe2tpNd6rQDsktSdiXjjHaBlm
         DUktLxVhtlx/fAskmZonktxbb4lYoYbqMaheq9TRFuIt5YIrIkz6x5WmlW3gf93tUQFU
         X7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=klS5qEHFw0JleAQwvbTW7kVh/K0JIRi872KOykaSGiE=;
        b=YpDOvR969LScJIRJxblL5eC7WpXYBNAORv6b2X49Fp3NrJDPmeGAwPJr5j8lZUVge9
         z4r0EonrDllec4qs5I7fod1eixWC9fZystLTsDhP6Pu3Gl3aE7X6Iqz4Ryy0RywksDxK
         qM1jHzE2x1t4hEw6/KCDlEjPInE6PpLV3hljlE3CP8UjJupeeLAOB+sy9TBxADfiCip8
         cK49cVwf1ityDrWUcWcjvncBZW/ilrQ47xe7XDhJrOENLSgNbqGW9QZudvHB/MX8ykks
         faVyJ6GOZbpUCiS6X4PmRKjladTapq+ZSWQI8sJbIffdK4oInQ1zzICHIjK3fqRZF3OG
         zCjQ==
X-Gm-Message-State: AOAM530Sdad0ncLoKiUiP35H2KF4vJDIbc0dbFZ10IC8LlV9wZM6cKf9
        3Nh/mQYtrYQflxVq/8HSEiqfOTNSuyeQaCol9/w=
X-Google-Smtp-Source: ABdhPJzgSyEOV/ocQF9fZnn72QnD6A5SzgLFfEF+QzAI/KfDFyM5CfO+QbN3a40JWPiEroFXgdz9kDX9AHDBlpVK7rI=
X-Received: by 2002:a25:d64b:: with SMTP id n72mr8418229ybg.232.1625138011041;
 Thu, 01 Jul 2021 04:13:31 -0700 (PDT)
MIME-Version: 1.0
From:   Ariel Almog <arielalmogworkemails@gmail.com>
Date:   Thu, 1 Jul 2021 14:13:20 +0300
Message-ID: <CABvr3-ETCFG--19sk_mvwH5s1kcek3zfv3T0QvYZT5ZNhfQ1Sg@mail.gmail.com>
Subject: Support in Annex P of IEEE 1588-2019 - linuxptp
To:     richardcochran@gmail.com
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Elad Wind <elad@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Dotan Levi <dotanl@nvidia.com>,
        Thomas Kernen <tkernen@nvidia.com>,
        linuxptp-devel-request@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard

We were wondering whether there is ongoing work for adding support for
the 2019 ptp standard.

We are mostly interested in Annex P implementation and in particular
authentication TLV in high priority and ipsec.

Can you share some information on current status, demand, and future plans?

Thanks
Ariel Almog
SW arch
NVIDIA
