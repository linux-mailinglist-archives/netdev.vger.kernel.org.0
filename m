Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED5D452907
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 05:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242869AbhKPERl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 23:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241086AbhKPERg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 23:17:36 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8BEC1FE13B
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 17:07:30 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id ay21so38805188uab.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 17:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0v9/w1kwlZe3Y9CHxIJ95jhpL8Uq6xy89EP65EB4GHE=;
        b=ALaZ4vVRfcHQAkTsI8ASUsFGHmwLOMJSuIiIsJ45eUKW/brbgm7GRmyaQ1HIhVozZk
         zAxVem/ZO7o33RA/vO6xVyC93QFSOpRsCLQq6kSnzx9hiickXKnvDZ04Z5oUnQSRla1B
         VPZ0l60pIr9fVtpCbjZVM+6qLB1Da/Yp239wOeDH+/PreWgHTDYVpKBs20/sc1y9azeC
         n66Rj67mzQEJ8SlkA+4rtuW5nsG6AGUJz+EJQiamncBPHNc2s0cszkA8zY8CcldrlLs2
         Lcbrfty/yg7cZnoZtoTlmyPQ8kFSHhMzdbS0BWsUfFrZtScf380oXtd6qqs3mOC42pUH
         MjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0v9/w1kwlZe3Y9CHxIJ95jhpL8Uq6xy89EP65EB4GHE=;
        b=gMyn3ZVD6Hg5ONOsjjpr8ztQjqAJJFLUmPJUVIQaBbfs7HssN8of2wWciNiRiv2lc8
         zSqgMrgIS/K7QZFuN6hh2vLQC/25XCsBpJJ+7sw82t6HwwwjJPP0H7DzrU6QLW8kL+q0
         jdektOiCKmZ649pyvqoK+vodZWFbUAUNEHxfJVq/8ueplPrijVNHflnuVCgb75l9Thd0
         x7te0kFpBbHzb07gdfCqRh9xHk8WamLb5I8bxzKSZ8bOqfo/tRMCYsg/yhFaE7qb+LLA
         BF4/RFoRIdxWULfZUW3xSaVGl3HcoRECMH92e/ZfFiW0TRHOPsGze5IMhGjpoy5T9wfU
         XX8Q==
X-Gm-Message-State: AOAM5304koDp3WxDIrQsO/hloQoAafs17Jbpfo9ssJw/AszXQu8ishl4
        qa4AS6lDb1iiwwo010/2PAb5dkcHjFTzVjLfYDlzntoTDx0=
X-Google-Smtp-Source: ABdhPJzbcWmlRLdA6MIM0qLD1PKwDmCChyk0clrDxyXB80Eevf0CCpdAoYHBlF/79xHquhLQCeGojNnkcd5GgJc5A7Q=
X-Received: by 2002:a05:6102:d8d:: with SMTP id d13mr49477683vst.54.1637024849982;
 Mon, 15 Nov 2021 17:07:29 -0800 (PST)
MIME-Version: 1.0
References: <20211116000448.2918854-1-sdf@google.com>
In-Reply-To: <20211116000448.2918854-1-sdf@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Tue, 16 Nov 2021 01:07:18 +0000
Message-ID: <CACdoK4L-72V1wWDBZPyLMhqUE0NVj+9BEq74Kwq+PZ6q4cGg5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpftool: add current libbpf_strict mode to
 version output
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 at 00:04, Stanislav Fomichev <sdf@google.com> wrote:
>
> + bpftool --legacy --version
> bpftool v5.15.0
> features: libbfd, skeletons
> + bpftool --version
> bpftool v5.15.0
> features: libbfd, libbpf_strict, skeletons

[...]

> v3:
> - preserve proper exit status (Quentin Monnet)
>
> v2:
> - fixes for -h and -V (Quentin Monnet)
>
> Suggested-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Looks all good, thanks a lot!

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
