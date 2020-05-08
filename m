Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24891C9FB1
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgEHAdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEHAdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:33:22 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C0EC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:33:22 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q10so3006635ile.0
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 17:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HEgZghBRE5caRpA+b3xP0tZuQX+UeTdUYn81e/Sbp2I=;
        b=sH3GxCfUfTAveY1ze+9FoxuupXdF2xGQ+zECzyLLrBtHkGdu9yYZAB10p5lbxgtyjH
         FWsPBlIbbI2OQ30nuzBD4fzZgI3Qb7umesdpFfs1eoxICBAZTfuXIX+NBbwAeKhOjGCf
         qekLL9lcysD9jKewm442Cq6vcPdciBgAtGahPNlicYuyXCnhZA64RIx3gFzbofvgxeTs
         mCmGhZePY137qxrcbFar0KTzmR8xUIU2hfXrvbVVEv+aUxwHFXK+eYxwDBmcXxuK+ABm
         g1qZf7z/nc+xG27ShXOElZhV6AnzDYwWtG0hREW44h0S/7CjGcEB7DrD8ohlg+E58xh3
         CthA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HEgZghBRE5caRpA+b3xP0tZuQX+UeTdUYn81e/Sbp2I=;
        b=F6dsIR249OJEs9M0fBS/vR4jkgqutGfcDFTFZHa5Kj0tr52xRm8SZjiR9oBgbBOrke
         DnnlH5iTCc3OBdRDkehpfpnJFiQtkj+39PeZHrR4CupRMrk25Vzb6jUaRkLWC2Z/zqGs
         UteX3v5K9EkKOMyZ2jxMCIz6nmBF6vOnLnq7hnd7nIuT4h5fK+1I+tb8Le+ycHghqrS9
         AyqXoOEH7lvL4mkA8N+3osIUkUyXNa7SrSgGrBlA9bI8EEL3QrZsuurnJYog8tIxM310
         bSrXFiGpJjyTo0mjrU2nik6GHb3quh5w4DkIaXwjKkeIredvOTzmG3LsM2VvurUa9YuY
         3qTQ==
X-Gm-Message-State: AGi0PuYVYdILvqBfeFf+NtKoya9PIvwN5wjPvNsmrVozlyNIqAJn/33y
        Phd0dZxKOpYeEG58PfXjBqAZQ1JUlJ+kg3fUbhjK3g==
X-Google-Smtp-Source: APiQypLCXx4cxYvjViSL/kQGW+iSxgRlRVlcBn1LQ9x6VdTRrdobG2W6tP+/M7jHLZki5Kz0fgSDLT9zDurTxc1fBYw=
X-Received: by 2002:a92:c8d0:: with SMTP id c16mr16583185ilq.278.1588898001333;
 Thu, 07 May 2020 17:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200505185723.191944-1-zenczykowski@gmail.com> <20200507.173004.1881498730999455740.davem@davemloft.net>
In-Reply-To: <20200507.173004.1881498730999455740.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 7 May 2020 17:33:08 -0700
Message-ID: <CANP3RGd652sWgu3dmtK6yz_CxH61Jh0hiF832cDrzAwq28NaQA@mail.gmail.com>
Subject: Re: [PATCH] Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem Bruijn <willemb@google.com>, lucien.xin@gmail.com,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I've thought about this some more and decided to apply this and
> queue it up for -stable, thank you.

Thank you!
