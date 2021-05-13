Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB32537FE68
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 21:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhEMTxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 15:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhEMTxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 15:53:14 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19248C061574
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 12:52:03 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n2so28044128wrm.0
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 12:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yq+KQlab7nfSgMj45+2fYJqouDhnMWJkoF42R/cNlsE=;
        b=e0PGJx8JMKdV5f4uYcECH217ZODS+KnVepmu2ggBymUnF6rs+rwqqrT/EYnmKIU/ip
         soj96/ZLc9y/Eqk40Z5LQkBmJhzrOWnlpb0JLPb88DZTVAffX9iEDmDXWSg+AQSsNe2Y
         WzN7VVEkLebQDiSbvHurPDHPgoDa8i8jNkakXuKCR8QyHShXDnV08iWrXW0DgraQ4TEa
         /RX26UGvCLGJwfcd54MQDJPTwcfaDrFO7QGrP2dQb1Vh/jh4ciaT1tZF4pZdLMNU5fuR
         cQeXhhl2s0IiWKR8+qoWI2qWTQdUJrwKezKDAtcU+oEBoNS5cefiuwNqXptI/I7rSwze
         7o0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yq+KQlab7nfSgMj45+2fYJqouDhnMWJkoF42R/cNlsE=;
        b=Tw1GOQC6p7SW216N3FMFGFxY7Pg5BxJ1h76V+JbOddbvJgqckW7yfwD3CvKsvUvYWT
         KVrcHfv4OA5lm4yTQmw9T06AhXDbrZRnRhJpns2Qqjuiw5x9zRDF0tG5YqhN8wCswFDD
         w9DEapeacBUXaXvHs0edao5giy+9wPSdYSzZ2I806soZb55bCv5Bj2N8OWChaQxRqeTX
         2WKWLA9WiB3B01XRLEDMpzVBcURlMAvkl/tAHAFaXLevBe3w7aXnNVf5+0EshHCb6aa9
         WyErwHdLvhZwASENe+I9lVgU30nFpA+8JRkzDXVElEwYzG1UH6A0ak6CgDL4+O+9oPFT
         XPsg==
X-Gm-Message-State: AOAM530elZoW+ZmrjPYv1dC9EY+hA5KssorhqNKDgq5Y0v5w7RpMjmCl
        3tWdmN8Zk3yAiAG5f8ANYLMElopnzRu1iJqO9hTbJnQv260=
X-Google-Smtp-Source: ABdhPJz7amuY5OJJzfWqBBpkN1sqimEvE3w/t0v+nvZREJxMmL70kYam8XMj5KoBnCUcvIA3LOee2EBZiDod4WJsLqk=
X-Received: by 2002:a5d:58d0:: with SMTP id o16mr17318090wrf.420.1620935522354;
 Thu, 13 May 2021 12:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210419212525.12894-1-ljp@linux.ibm.com> <25e2035ea8f783d925adca94dbfef0ff5b5a06b4.camel@perches.com>
In-Reply-To: <25e2035ea8f783d925adca94dbfef0ff5b5a06b4.camel@perches.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 13 May 2021 14:51:51 -0500
Message-ID: <CAOhMmr4R61eXk+pR+8w=Nu-4wryk9VBh72UAVEt3rPxq6ze0vA@mail.gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: update
To:     Joe Perches <joe@perches.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 11:47 AM Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2021-04-19 at 16:25 -0500, Lijun Pan wrote:
> > I am making this change again since I received the following instruction.
> >
> > "You are an IBM employee 100% of the time."

I think they just want to enforce it even though their public relation
affirms something differently.

>
> Wow.
> In many countries this would not be acceptable.
> But I hope they pay you for your time 24x7.

Apparently they did not. I am in the US.
