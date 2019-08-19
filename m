Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010B592759
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfHSOqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:46:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32872 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSOqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:46:37 -0400
Received: by mail-qt1-f193.google.com with SMTP id v38so2166913qtb.0;
        Mon, 19 Aug 2019 07:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vgFQFQ3GZPjYMyP+LOQm1u/Kt9yQ5YLSm11v3IXc8GM=;
        b=Xl6gvk/wTATqgt1ygrQa4YZhgb2Nm2tnej3thVYUfjlvBENSqG2yJRVdqxZg5FLTQY
         cHaF24KkE4e3Zanms4IZB5urXI0TABhVTFZ+iSnvBeG6JmA+Wu8f6ao4ituMP3R9d0MU
         ciyw7aZeD7h1hzJTAKjtRJkfcSOmBzYm3VsC/HNdoVZASRLVj3S4vBf6AXUVz39uDIwd
         i8SBbV3RuluFaqjdMYlBdhR/N0WJjoRUKsSIALFgB9c7ZfLjtqj03svd3ZtgxXhltcKe
         svvOK3wQKfO6LUTZVT6jRXSKTZHEootyBU73qfv4I+n3326Y00qE4PaFPIRGlHMjH6yM
         U46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vgFQFQ3GZPjYMyP+LOQm1u/Kt9yQ5YLSm11v3IXc8GM=;
        b=EAniLKGXVlAF0kzDw54oG/iAYNYbGyWe8runoGylxcXAQdGvEuJsLMKFSZioVeL335
         CeIMzRhfkkiYBuxITsBqM6bdg6p4WQ2OPnd7+A8QM0tjNX0Yu3evmd3exTX9pXOH7dFD
         fGHLjmTSIVCh8WuWPhRfNylNDY+/JB/M0yAHwgxioukcDiEuTO+gz4GRALWWVqzJLq+r
         N90fyXJiEzuT77PJPmfAQX7kPes44d5wSuhZJYbpbbgQinMlwQwBGvzAEgNvqDXYDiNz
         AsKKpkWZuG5bGAgPp8Z789SOA5AFp4GnEKE7cK54iEFxhjIzW+zyxhnG+TxrDWsuoMsL
         hcYQ==
X-Gm-Message-State: APjAAAVP7xT34AXDFZqX+kOpZJD7d8ehxc0pPiSKawVgKY7nKF8DTxm3
        YIFCqkkrb71zKMli+XXe9Kg=
X-Google-Smtp-Source: APXvYqxn9an7pkjrZAjjSZwkPHrqfOcKdc01svcSd6iAUirRf7eprwpHXa4akG0dwK9Og06HXOLj8w==
X-Received: by 2002:ac8:7354:: with SMTP id q20mr20679419qtp.60.1566225996461;
        Mon, 19 Aug 2019 07:46:36 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.68])
        by smtp.gmail.com with ESMTPSA id f23sm6940635qkk.80.2019.08.19.07.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 07:46:35 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 586F9C1F09; Mon, 19 Aug 2019 11:46:33 -0300 (-03)
Date:   Mon, 19 Aug 2019 11:46:33 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
Message-ID: <20190819144633.GD2870@localhost.localdomain>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
 <20190819143052.GC2870@localhost.localdomain>
 <CADvbK_dT6p7z0YUcEKakGr-+x+a7je_jNnGHOAnVs5mxtrSN1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_dT6p7z0YUcEKakGr-+x+a7je_jNnGHOAnVs5mxtrSN1g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 10:43:03PM +0800, Xin Long wrote:
> On Mon, Aug 19, 2019 at 10:30 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Mon, Aug 19, 2019 at 10:02:46PM +0800, Xin Long wrote:
> > > SCTP_ASCONF_SUPPORTED sockopt is used to set enpoint's asconf
> > > flag. With this feature, each endpoint will have its own flag
> > > for its future asoc's asconf_capable, instead of netns asconf
> > > flag.
> >
> > Is this backed by a RFC? If yes, it should be noted in the patch
> > description.
> > Quickly searching, I found only FreeBSD references.
> RFC doesn't define this sockopt clearly, unlike prsctp and reconfig,
> not sure why.
> but BSD supports it, so does some userland SCTP.

Ok. Thanks.
