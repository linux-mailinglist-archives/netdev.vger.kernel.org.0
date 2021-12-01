Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A6E464734
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346956AbhLAGfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346953AbhLAGfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:35:07 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAA4C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:31:47 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id i12so19424690wmq.4
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6JWpElPMkPueMIQhdLB5N3Me+Mz+TDvCpLi/wnhBJNM=;
        b=j9dEzyzQ77K1zM8cHr27IJEHvW++7u84Nx0nYP/crhrBY3S68SjkohCnEz71967zf4
         HaK347qCvPpT5rW8bgR4MhqMQNNnlw6iwYRHrhs+U2btE60g9j4tRFCL2Iv1/B6i7P7B
         gX21RTefiO7mdSwnw2FHwfDXJJd8wfzFO6mLiFEUSJGSUqITcD28cn+aiw1gTk531buD
         q4eY1aY44KdPxDeuETnNsGViAjnhJ52LeZTJX8mpYKCewif6a/tzf3q530PBTrma3LOo
         D2AR2cm3+LPtGg5nrvqUAqR5JORU0fdhMDuz3+m9AmR5IhrFbmD1QtDT8EBUc2mwnGfH
         ncoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6JWpElPMkPueMIQhdLB5N3Me+Mz+TDvCpLi/wnhBJNM=;
        b=LEBzdh64ftugjSsfBOzOZyckH31Vr6IdsAYXM5XMYtBtN9tdXyXnGTIM7gcqK33Tw1
         3CQcc0waqeQMEFs9VigCJqmui7s8K11WdVHyg6oFDCSf3itay137k50x3fltpqOWloF3
         WKgAoBgJ9W0ghciRCKv1BKJ5AnSW99zUilouMHkYhquOaBvYaCnMcpKiFffor0vnkSaD
         pgN0PerJseMV26Qp8lFoga0N4yuE7PKOy7m7/DlBRIRVY1TZK02XTz7nA3/WoHw+PfKc
         tJ5xyjXX16aRct2JN1Ri7lIaqhxS+lYdmbJdDo3zJ9FWTWCBxlYRy2HTEmivRdiqPayP
         Uu9g==
X-Gm-Message-State: AOAM532SF+0jMIpzrdV0w/2v9RupuLOYgfrf00P8Dt37K9yCXqBqmMck
        07elmrh1Zn0oWoo2ZJPqNZJRwrP/sihd4iV76cM=
X-Google-Smtp-Source: ABdhPJwCP6fq0zj3gVESywvPcdXFH9VND4OGcv1TFDkziuzJlc/imlod7KVtekApUZ1oBz/ZnY5uMCBL+khKiEaFP6s=
X-Received: by 2002:a05:600c:3c85:: with SMTP id bg5mr4540615wmb.58.1638340306063;
 Tue, 30 Nov 2021 22:31:46 -0800 (PST)
MIME-Version: 1.0
References: <CACS3ZpA=QDLqXE6RyCox8sCX753B=8+JC3jSxpv+vkbKAOwkYQ@mail.gmail.com>
 <ab9b65b4-04d6-0bfe-4fd1-91af9ac5aa0d@gmail.com>
In-Reply-To: <ab9b65b4-04d6-0bfe-4fd1-91af9ac5aa0d@gmail.com>
From:   Juhamatti Kuusisaari <juhamatk@gmail.com>
Date:   Wed, 1 Dec 2021 08:31:34 +0200
Message-ID: <CACS3ZpBdTWXoQVhNFks4VqEUxCC8WmurjnD8WUH7LVedxHjSGA@mail.gmail.com>
Subject: Re: IPv6 Router Advertisement Router Preference (RFC 4191) behavior issue
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 29 Nov 2021 at 01:11, David Ahern <dsahern@gmail.com> wrote:
>
> On 11/18/21 3:35 AM, Juhamatti Kuusisaari wrote:
> > Hello,
> >
> > I have been testing IPv6 Router Advertisement Default Router
> > Preference on 5.1X and it seems it is not honoured by the Linux
> > networking stack. Whenever a new default router preference with a
> > higher or lower preference value is received, a new default gateway is
> > added as an ECMP route in the routing table with equal weight. This is
> > a bit surprising as RFC 4191 Sec. 3.2 mentions that the higher
> > preference value should be preferred. This part seems to be missing
> > from the Linux implementation.
> >
> > The problem has existed apparently for a while, see below discussion
> > for reference:
> > https://serverfault.com/questions/768932/can-linux-be-made-to-honour-ipv6-route-advertisement-preferences
> >
> > I am happy to test any improvements to this, in case someone takes a look.
> >
>
> do you have CONFIG_IPV6_ROUTER_PREF enabled and accept_ra_rtr_pref set
> for the device?

Yes, I have these set.

BR,
--
 Juhamatti
