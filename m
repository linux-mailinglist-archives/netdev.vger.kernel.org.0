Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A65206817
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388668AbgFWXLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388471AbgFWXLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:11:48 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B6EC061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:11:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q8so107345iow.7
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wr7D9qr23jJoi0F0i5hYffC0PVGDdnNDhckq1mg1t2s=;
        b=OSNwLeemY9rtEB1iTQWkQR68Anwn6/4GraoyNdS+hChQUBdhrOrB2Q+K3/x6FFs8Lr
         bHYWu3UAtEa/gmj9j8DcTtaWQ4bbz/jNTZUWrfLVxZ7kbkj9LLvw6XpaJEx00K79asfu
         x8C0qdmkWnNHdN23nIjkGQO5q55aRKaV+t3mXi5UnGhwbTAh4AlmuL03ShDBMM7itPXH
         zUWaHKKKkaRZDNT2aADwPsqrSepK1KNFuuMf9pryMFr/t5KvSrofaH2+e+6C4vf84nYW
         2+bFF+oWjejxa+v0X+O5fbcfjsgAtPLA/4NlW9ABOp6Zk/+9CTnkTp7RS8Vp5NlqKZkj
         u8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wr7D9qr23jJoi0F0i5hYffC0PVGDdnNDhckq1mg1t2s=;
        b=kOZeduAiI9g8qRBoKU7VAtDMwPkL3WB1lrEHJfnXhc2gnjnyfDF0wGzeVU1FPXUiqv
         XnrrKqiVmGYgY4LHqCGEnq73JenWbYOOFzN6p3gh03L3E+I1AISkaAIJB4+ntLfoYeAI
         npXtn+N801z6XPQIVSQkU+/AsW+3xxOPxponOk+84AWNnADJ6e7FDBETN6/EDCZyr7nX
         ifh/arUGhOcqXfem0ftr3nH8jsWT+m+42eCTa/Gc7sRe+obBN7/reDVz4FgbKWEAzNMn
         5BgnlECGLb843O8dVESQ7RA2YOmXSvjJgwdXS8fzU2rcwz7EigfOLfqnswwXMRU8oSIo
         WOHg==
X-Gm-Message-State: AOAM532qe6M4lOc0I19wj1iZVMeyEaYhbs3vE9amMA/I3UUO58fkC63L
        OxWZRptxguVQQbaj0Ol9qq+xnkulNUaD2Be7zZyrA3OJQkY=
X-Google-Smtp-Source: ABdhPJweyGcVWHbG+ZRb3nEK/m//+hAK2CbPENKG+Ihf6r3tV2OVc+9EMa1MWUtSLCY9CJ5B/KcILeuy8o6m/scSKaE=
X-Received: by 2002:a02:3c08:: with SMTP id m8mr1151969jaa.107.1592953907499;
 Tue, 23 Jun 2020 16:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200623230902.236511-1-zenczykowski@gmail.com>
In-Reply-To: <20200623230902.236511-1-zenczykowski@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 23 Jun 2020 16:11:36 -0700
Message-ID: <CANP3RGfGE2PnaZUJ0Yz79sUf=zsQ1hjxHWhP8pEvQD+y2BWq5g@mail.gmail.com>
Subject: Re: [PATCH iptables] libxtables/xtables.c - compiler warning fixes
 for NO_SHARED_LIBS
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  void xtables_fini(void)
>  {
> +#ifndef NO_SHARED_LIBS
>         dlreg_free();
> +#endif
>  }

Note: I also considered just adding an empty 'void dlreg_free(void)
{}' function in the NO_SHARED_LIBS case, but that doesn't seem to be
the prevalent style...
