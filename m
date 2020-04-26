Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE41B91C4
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 18:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgDZQeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 12:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgDZQeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 12:34:23 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BACC061A0F;
        Sun, 26 Apr 2020 09:34:23 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id g4so15026630ljl.2;
        Sun, 26 Apr 2020 09:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5MhVh0cxmhr6NFxudFO48mk9t9SZKg+9Yklkqo9/++8=;
        b=otcVj5Lw70gO4jpupiekcGeWkKFnY3Gi/IRQyu8/l8G+zGMxPctPkWQoW12jvKYQl5
         OxwhPZN+TgQKTxlZ5GPjonFCpyWIWjzgsfJLBlwmq7RLkjj6UUJAO0EgkPe1JSzEmWLI
         TSt2dgWd7e92BjFsA6/u9DRD2TNSjZFZ3mrNZ47CdMOu3aRBmInZdG2zw3Egt3tgnxmF
         maWN8WQ8DUblhUK4YMcVPkWC0/2/035aEIVZ0zv3W/PZH7ToaYavWV2XDBzkhy7jN0rr
         I0XF0o+n5yoinVW3N1nc0gOonwCjxhlXNLMz8YqtLwMsCRKI3bhhZXpiRZ+7iltlRBA4
         sEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5MhVh0cxmhr6NFxudFO48mk9t9SZKg+9Yklkqo9/++8=;
        b=bQAExOwQwSDkauxF0nHSWBFMU3wN4q89egR4wad+IKekivpXUsLRhPX6PUXCcCjQG5
         mK9c0mQYNoHorVtWVecGDmQ/NuEKThKqcKWTsStEuB1is7fKHCYNJ+PMXuXI4huGhBJE
         GfX7NzpB7xplAImHgsZI8b3Zd8nsxH4QXb2NxGHnBZOxdPX09oRVpWL218QarM4z7O7q
         KuWBsXaHl3ShP7lh12YsdW/gFFCfTWs2dZUKHdEZsLU6np7Kn9H/jlxOw+hdLrC4smU0
         JaDwOvelfjZSfhvobMooPUAEi5arYks4e+FqdI1dLnJ7VDxASxjFz7lqvIwUKycYf7De
         9vKg==
X-Gm-Message-State: AGi0PuY1Uz1mc5bg5EuF09L4KTLzQXU7et/HHWbdgNKbnXY6a5ES3fWZ
        MB5fWzfj4da1IvcsPolldH8QmL9LNAhWfN2D1iE=
X-Google-Smtp-Source: APiQypJx5qbkHN4Pmyt8J85PM1/22JDoA1HFIjl4dE8AEL87JiQ3S+auZEjPGIpaPV9ZMnqCfFSvhY5TRGu6bG1OceQ=
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr11958850ljo.212.1587918861888;
 Sun, 26 Apr 2020 09:34:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200421232927.21082-1-tklauser@distanz.ch>
In-Reply-To: <20200421232927.21082-1-tklauser@distanz.ch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 26 Apr 2020 09:34:10 -0700
Message-ID: <CAADnVQKr7mPBqWhLYLJCmCkP1YSGLQHjWr0CBuh=k7oJeg+=oQ@mail.gmail.com>
Subject: Re: [PATCH] xsk: Fix typo in xsk_umem_consume_tx and xsk_generic_xmit comments
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 4:30 PM Tobias Klauser <tklauser@distanz.ch> wrote:
>
> s/backpreassure/backpressure/
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Applied. Thanks
