Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3EB66570
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 06:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfGLEN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 00:13:29 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:40023 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbfGLEN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 00:13:29 -0400
Received: by mail-ed1-f46.google.com with SMTP id k8so7924062eds.7
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 21:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I4aZ0fLIzpsE39Yd5dCJJePsXl3cSELYBbPmXuG8rgo=;
        b=InzeTS5AwkxK2TyPE1W30IvyG6QJhBa66oewXh14y0ap8uSRtnkAxzFwd9TpDHnovN
         SnZJUslMahXsh16wJjK4zSb/5yNFTAhy3jmdbMkF0KQxWaDCmMVaRz3wAFSrYbNAGRDH
         3d8TzvRI7gRq00/S8RpSBHb2120Mm857p2h5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I4aZ0fLIzpsE39Yd5dCJJePsXl3cSELYBbPmXuG8rgo=;
        b=tFMBQxUbUfSJ23TC3xhknAkTkcsM1/c4+2NJv+WfsGTIzmC5Iwke+/COWKmgGnzJjg
         RhE3Tbv1Wd1IBqz2RuMBsdpaJPod9+DT6qGS/5OceQg9rThRxMmISCPs3N6606DNDwZ+
         mOHjmIcjjcuKH4YgApXG/Oee2FqbY6KnYmw6h+/piMrUeXlY76bKQKop9ABfpxdoJA2I
         ZZ+zb06gqX61OEpHubnvTt91KIll1AaBo2GnWB91Mx4WzDzHdzN1eXuqd+n6cHEFR167
         2ofs2TANHqRNrGjaVND7Fpd+7HOlYqtOKTsm11o6u1T+EmdyvGb4tuTRB6CP0xZFFXE5
         D52w==
X-Gm-Message-State: APjAAAWvgXn6Yp9v9y9yE3CrORinRtXYhyyFp4fG4dJTZPH5xVwee7tV
        qIY0erp9yJFKf4zCCisR8qC+NVhwKE1OOoi0NDi29FgqYpE=
X-Google-Smtp-Source: APXvYqxED7C4tHdO0zf6JRHARu/TbtO7V8xCOSDKvdanMQTJxeQJ8Umek6peoOyyogQ3UAFNrwjIgUNTK10QOaQbHkg=
X-Received: by 2002:a17:906:6c85:: with SMTP id s5mr6368411ejr.199.1562904807972;
 Thu, 11 Jul 2019 21:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190705184643.249884-1-ppenkov@google.com> <20190708.161239.1059009680713827908.davem@davemloft.net>
In-Reply-To: <20190708.161239.1059009680713827908.davem@davemloft.net>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Thu, 11 Jul 2019 21:13:16 -0700
Message-ID: <CAJieiUhMbPkEbSqL2dpjx+HBtVPa6cEVk-2ivQAy2NrFCJzW5g@mail.gmail.com>
Subject: Re: [net-next] net: fib_rules: do not flow dissect local packets
To:     David Miller <davem@davemloft.net>
Cc:     ppenkov@google.com, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 4:12 PM David Miller <davem@davemloft.net> wrote:
>
> From: Petar Penkov <ppenkov@google.com>
> Date: Fri,  5 Jul 2019 11:46:43 -0700
>
> > Rules matching on loopback iif do not need early flow dissection as the
> > packet originates from the host. Stop counting such rules in
> > fib_rule_requires_fldissect
> >
> > Signed-off-by: Petar Penkov <ppenkov@google.com>
>
> Roopa, please review.

sorry about the delay. I was traveling the last few days.

looks ok to me. thanks.
