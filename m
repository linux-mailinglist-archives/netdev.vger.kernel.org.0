Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23ACF4A62ED
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241748AbiBARsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241727AbiBARsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:48:46 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F1FC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 09:48:46 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o1-20020a1c4d01000000b0034d95625e1fso2589116wmh.4
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 09:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hnuqwTFkwr/iz/c/twXO2Bgyh2xwZyGmE3cnUrPpSjc=;
        b=NlTmrtWXxjiVnRW/lkPSMRXdvKQ8OHjFzJ/QfTxiM+HQPvPsC27XKuyWNNRjnuigDu
         9EW1NsDiZmHg2sS/EB477YATVaWlzn8krKNMJTlm9vueSph0E18xHsgi6lndrVLYv3FE
         S2EnnQ6cwhUVlMadaNMsHBacMa/DaUt4ymtOH+8sazY6F7rqkVBtfhvAsSdlJhVaCztG
         HBtiW8UDIClxZN684SX3DDm2j1ofEnC/RJsyXfHSWIVPK8lYql+IiiETgPgBkmyKG3r+
         yZaP1ibKracycmMF1RYB4gDQoHqevNKcAcSWWeZY8SdJBtREo35V3O8dhA9V+N/3PQQ0
         li7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hnuqwTFkwr/iz/c/twXO2Bgyh2xwZyGmE3cnUrPpSjc=;
        b=1RDu7s06DEHMhhFkky+qp3T79wAuVj9dvlOVwmABoblwLFJuwy1NuJxYxrtyXperwJ
         6xAX568GhOd+4FiReGqnn4plYGegSy5lkpk9bbS1FPFd9ORG0O5Q3lJ6Z9SsKQVo2x6+
         /n6rlEYrdxkjiFACT048c1xhSrD9zWW0d9LVvU/61FALfR7fl1ZY0bZiLi2ky/ojuSq+
         cgtRbYtdQue47IHiSze0OVJNqiXvOajKqlWE+TtNswyzmKxphSyg7ea/HPbc8NaGgqj6
         zDN14UDA9d5vVYrHfROjjAEXk+/8HG1I/iJ5m2hDdIe9HCkOcEUsADw4sAWMu6wx4iTz
         D7LQ==
X-Gm-Message-State: AOAM532nQJHs245zYBu8R1iEFYZMQVO4xPl91APJWVYWpsb0ISeziMiw
        uy17Dqhcofb0hmaDbV/FrKZfWRec7oOuNZh8G4zlI5ui/AmC9j+C
X-Google-Smtp-Source: ABdhPJwB0dohFdFWf76XesPTDuhaItsrJBww6SgM9kZeBl6+64HRC9h6DukwyjvpcEyEplyZtgU+mtkas0HK1WA612k=
X-Received: by 2002:a7b:c928:: with SMTP id h8mr2694627wml.168.1643737725015;
 Tue, 01 Feb 2022 09:48:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643225596.git.liangwen12year@gmail.com> <b357d21c3d85d877b9b426409b9d3e79af5028f8.1643225596.git.liangwen12year@gmail.com>
In-Reply-To: <b357d21c3d85d877b9b426409b9d3e79af5028f8.1643225596.git.liangwen12year@gmail.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Tue, 1 Feb 2022 14:48:34 -0300
Message-ID: <CA+NMeC9ic3B95tH65NTA7yDcpMsWufD2uYyyB46WW-r8rFbCTw@mail.gmail.com>
Subject: Re: [PATCH iproute2 v5 2/2] tc: u32: add json support in `print_raw`,
 `print_ipv4`, `print_ipv6`
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, aclaudi@redhat.com,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 4:45 PM Wen Liang <liangwen12year@gmail.com> wrote:
>
> Currently the key struct of u32 filter does not support json. This
> commit adds json support for showing key.
>
> Signed-off-by: Wen Liang <liangwen12year@gmail.com>

I tested this patch with tdc and can confirm it passes the tdc
tests.
Tested-by: Victor Nogueira <victor@mojatatu.com>
