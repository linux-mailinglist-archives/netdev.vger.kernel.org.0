Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C951BB299
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgD1AOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD1AOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 20:14:38 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61967C0610D5;
        Mon, 27 Apr 2020 17:14:38 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n17so15679577ejh.7;
        Mon, 27 Apr 2020 17:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0SHN2u7WHirj9rFGRxq0U5QdF66UP7Si1I8EoURuwhQ=;
        b=sgRLXNCktHnIDbBPPEo/9dHee2ssaliF5PBgA3gLGGKrEeGnIsWrE+Gl/OYBp2iY7q
         KDZbAewHf+Vjb/ym46ikKM8JtKZdfPVoMI6UWloUOYoxDo+17LbOjhapz7/eB0jRKpw+
         i/KqcALXG96gY2Fw3QR6ByWYJREHqaMIGKNFTo0I4UOGGMSsqXifpMQb+qZ0oNKkpgtE
         VGSL+oKhhp3gRR4jqVZnkt+g2cS9eqc1OqOQkN9pHna78neYiAQvcNm3s9+SS4Qp70mP
         UwSiROG0rAtKs4Zodt/YOv3e8WQIEuK2oVJRboH1Qz6KTGjtfhITK8WcBhm3UNeRd1Dk
         Jazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0SHN2u7WHirj9rFGRxq0U5QdF66UP7Si1I8EoURuwhQ=;
        b=HyD/vNXmc48OSkji/tnm+vmSTTQHdRO1IFHepRglhSRvAi0RQO495xxyfou/6Dn8rh
         Gkiy8znyAUZ0aMVygZvMzTJ4raBJUuBHgE06BKHU1yKagAnJh92IeHqkyEUVQF1xu/2v
         KAPNMLlaoBvIu0NpwUwCVTZOqQDbfpIrTmNlOm78Bt41klOc85KtvqjCCcL3eMu9JJCV
         YiJBRzVD6BaVvvYXYRTJjFxkH3CBfaXhoqNJj4oIN1ojhegFBuf6foqyV3VZuDHTH4LT
         5/26aULJIa/Ggc/wScZasfEka9fgum+Gmp32AII9RdVvG4NrVmKhE1/SYfg9cQ6qOwEz
         7y6w==
X-Gm-Message-State: AGi0Pub1wvumfoJEQP1fvnwYoeKfWGhwTUtWJgprcqDAdu8EFYaGncQ0
        lic/xn0UGQdE5HBh2psumrxzYSyrFeKmgLQ4LdM=
X-Google-Smtp-Source: APiQypLVxQcFf9n4f0ZANWbYr+S5VyOoeb+o5EvX5MHBzdHRbvELCXZ5w7HOS0tJCZZbXtDZ+vDtmdISvLwCpRdEdQ0=
X-Received: by 2002:a17:906:f288:: with SMTP id gu8mr23065870ejb.281.1588032876999;
 Mon, 27 Apr 2020 17:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081542.108296-1-zenczykowski@gmail.com> <20200428000525.GD24002@salvia>
In-Reply-To: <20200428000525.GD24002@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 27 Apr 2020 17:14:24 -0700
Message-ID: <CAHo-OoxP6ZrvbXFH_tC9_wdVDg7y=8bzVY9oKZTieZL_mqS1NQ@mail.gmail.com>
Subject: Re: [PATCH] iptables: flush stdout after every verbose log.
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could you check if this slows down iptables-restore?

per the iptables-restore man page
       -v, --verbose
              Print additional debug info during ruleset processing.

Well, if you run it with verbose mode enabled you probably don't care
about performance all that much...
And it only does anything if you're feeding in comments, which again -
is unlikely.

iptables-save produces two comment lines per table, so you're likely
to have a grand total of 8 of these lines
(if you have raw/nat/mangle/filter tables all listed), and if you feed
that in to iptables-restore -v then
you end up calling flush 8 times, which triggers 8 extra write()
syscalls - which aren't exactly expensive to begin with...

So I think this is a non issue.

(I could change it so that only "#PING" flushes, which is the actual
comment netd sends for healthchecking,
but I just don't think it matters)
