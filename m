Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A85FBF904
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfIZSQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:16:13 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41377 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbfIZSQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 14:16:13 -0400
Received: by mail-io1-f66.google.com with SMTP id r26so9000454ioh.8
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 11:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PDT0gbn8ohcmxY0XLlyySpEH1Pv+Tijeup4uSgmX/3Q=;
        b=USU7q759+TJfG0NPkL88ueUFM/JjMUX0YQFoH852XVo4BACyCmT7/1tlRlGrlvHUPc
         mkKkGdGXOzduGGiy19QkZyzNzediQwVST37Nj1ZMNwti4e1EUyuTc2fkI0p3KJB2MY3R
         nL/LY+jwWNIuFf7LfQFuDpEZBDdtXvzM5R0cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PDT0gbn8ohcmxY0XLlyySpEH1Pv+Tijeup4uSgmX/3Q=;
        b=dn261sCAd77mlPAXrfym81rHNuLSEIfMZoZiZ8id11nTkDOfEg7077K3YoOEwlnvbS
         Mw+0xdmLylxIBDAznHcJ98u9hbVJbHVrHqu3k0p7Y/FlW1Fwr8ivEiZ7mfIeeAAS5Vkn
         oJh7QP2bGsZ/FIEA8flj1RqTOA5xp6SrCFxeiZ5uovoZbusmztv/+R4rsQ/sMnYNVlHa
         fl15npmSgI+4dXZsCCNgjk6GufGwSwW1URKmJ5f2CFzhG0b+7DKI9w0aDnFAjT/ImAvD
         uzgwyZbvRWH6KLicjV8m4jdaxbEQpYXArqTb0S0tx3U1EPo3f3XagytqiDwuOtK3RDLC
         jgsQ==
X-Gm-Message-State: APjAAAWckULWvQw3hlJFTaQu1tbtiXm0xgyTDJ6HbERPgPaJiFmqMA96
        J5yJJ9m6EWRie6tBexJI8fuCpeexU54hwLeja2P5
X-Google-Smtp-Source: APXvYqzakMZ6KoFcPmiQ8fhwJzUvh4wSWX2KgkWYqPk892ITr8YJ2BPxHCYnh8owNwecOgDcc8TYLA9KGvl7eV+omrw=
X-Received: by 2002:a92:c806:: with SMTP id v6mr3829480iln.147.1569521771070;
 Thu, 26 Sep 2019 11:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190926152934.9121-1-julien@cumulusnetworks.com> <20190926090755.78b6234e@hermes.lan>
In-Reply-To: <20190926090755.78b6234e@hermes.lan>
From:   Julien Fortin <julien@cumulusnetworks.com>
Date:   Thu, 26 Sep 2019 20:16:00 +0200
Message-ID: <CAM_1_KyS8cbkWx96o1mYedAJfDMFFy1A4d8rtTRWMgjbnpR=Rw@mail.gmail.com>
Subject: Re: [PATCH iproute2(-next) v2 1/1] ip: fix ip route show json output
 for multipath nexthops
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        dsahern@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 6:07 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Thu, 26 Sep 2019 17:29:34 +0200
> Julien Fortin <julien@cumulusnetworks.com> wrote:
>
> > +                     print_string(PRINT_ANY, "dev",
> > +                                  "%s", ll_index_to_name(nh->rtnh_ifindex))
>
> you might want to use interface color for this?

Since this is not part of the existing code, I guess this can be added
in a later patch.
