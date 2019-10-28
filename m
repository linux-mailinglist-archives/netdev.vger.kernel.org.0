Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D936E7D49
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfJ1Xzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:55:33 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41585 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfJ1Xzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:55:33 -0400
Received: by mail-lj1-f196.google.com with SMTP id m9so3574116ljh.8
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 16:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dwI+zoCzXRRzjFzJ0zxBWXS8GLtaA4GmRIN1zQWq4No=;
        b=S/9H0g04AOxq87HXv1ZpPxgCrvFGgBgLhPUzLAiJ/Uc9X4d2094JameOTwRfoThM1v
         L28aunqS0tC3g4tfwiuZJqsEEakeXcYgt8rZ4TDEeIUn2j+rNixu2MQTRjY/50SW48HX
         qRuBCS4SyKTvh2NUZEJXNI8+nDBI/GGh4ZhNoFWuXw9CfELp27Wsj0xXoHGCoiMywKH4
         13DakAkbN4DXYmhEUMaEucPwhzDiUUgmx8/u7DVbzawKCEqd8MYI3dMRcGD1FFCYfml/
         DmbZ9FK3kn3iOTnu41SEnIGWh1vDc0juk8ghzh+bHwvoVeFyyA5UjvoqeQ0WN+/tGBWS
         paZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dwI+zoCzXRRzjFzJ0zxBWXS8GLtaA4GmRIN1zQWq4No=;
        b=NRVEdduEfzWyJ7oZN7bzv34HlfLpBndU6QTNZ2dNqacwZjRW56bgsmQUl67rM7gx/z
         yQTvFMLfKl6ndm5oyGBwrbzLOSaQn8hmxYlrm0HJgMHOfvi4f8Pb5Jij1sUSDpOWFoEE
         TPAKSEtS1UQzcjQcKrzQL0ESEYq/cOcJMrrkD+6UBOaFCQDETeyCJK4sOyMmzwCLhWnS
         LWW4AGpyvatWpdlWxg8kxiNgrP1UYqpZgZrH/ZOCDrrzDmMlvsgeWKc4SZqJoMn3dbY0
         u87zAtqhwC9Vmh7iG99AustrP44vaglrY2IpaDS2rmh6h+wZj8Nn8Fmq2kAF36kP+npy
         dkMQ==
X-Gm-Message-State: APjAAAVor+M+QRATFvNaMv1sNmtLiFTX6ULibFTz8V2j3CPVFfEDPjJi
        1Lf73RmIZL2wJ0jG09oGgemIssqt3UmnsF1QOT3KXQ==
X-Google-Smtp-Source: APXvYqwaIZ9cQCCyyFBhGTXg+2phAAgAz1wEhyhTb1KUu/jVTlCmaKTce08YHsg8Zphbg3q+issrIavHOP86zsQO9S8=
X-Received: by 2002:a2e:868d:: with SMTP id l13mr278340lji.136.1572306931406;
 Mon, 28 Oct 2019 16:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191028221131.2315-1-jakub.kicinski@netronome.com>
In-Reply-To: <20191028221131.2315-1-jakub.kicinski@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 28 Oct 2019 16:55:19 -0700
Message-ID: <CAADnVQL3=0nMOhfLHXYpQ=-LkE0+56EBcyPer2kpCkW9=9f8SA@mail.gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: remove Dave Watson as TLS maintainer
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 4:43 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> Dave's Facebook email address is not working, and my attempts
> to contact him are failing. Let's remove it to trim down the
> list of TLS maintainers.
>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
> David W please speak up if you're seeing this, if you're
> interested in continuing the TLS work we'd much rather just
> update your email..

I really hope he will continue working on it one day,
but for now it's appropriate to remove.
