Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4C4A5A6
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfFRPm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:42:26 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43034 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbfFRPm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:42:26 -0400
Received: by mail-lf1-f68.google.com with SMTP id j29so9647410lfk.10
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 08:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bjd5132eo7jNT+3OWPZ+DQKihSgNN8ZcFc+D65z8nSA=;
        b=Q9mv6pX/yUBjnXWohELYWjTm9BZWbUiU1J0Ux8WLu2+zEaFQeUIkyQt60xNXhAu3cL
         WOLiiBmAEtwZWP/ZAnd3iK0etr6hgnpBQjDa4OyFg6hsQmVyuBNpnj2N2Tj1e3l8eW1k
         INfYb6dL4fkKdh6U8tpbHSwk11+UIBAlKGD/MjOPIIUUM2ocIS7azxEbn1PWinXNRzX4
         8c1GkZOmSTi05hYg+eVMklV/PTQYsgeise41j/ZHGfJNan4jcXZwVr0hFxO8nkTcY3jH
         miOIKQP2ZQMehTXetQ8H3qw1iH6VHObbhvhgGxYabXhAO3gzyvQZSnrhL/8GVTBy0Q27
         48sw==
X-Gm-Message-State: APjAAAUrl2VZ3X4QUjI+AcKUgFPQl3Tg4aQhAE34WWNKGyxXRzWx4Wo8
        clhK9OdwNT6Unzd3pmb1NeN+2Sip27pn2yL1BzYRC4qj
X-Google-Smtp-Source: APXvYqyRtXm6TJzYcPCTh1DhMLSdjypQsdmkQqnOtPtuuK9lSEWpSKIahiXdp6wqWAtTyjyx4BuvHo+o9ge+LhE5otY=
X-Received: by 2002:a19:ed07:: with SMTP id y7mr62176012lfy.56.1560872544098;
 Tue, 18 Jun 2019 08:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190618144935.31405-1-mcroce@redhat.com>
In-Reply-To: <20190618144935.31405-1-mcroce@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 18 Jun 2019 17:41:48 +0200
Message-ID: <CAGnkfhzdNsSeQAd_-KRNNd897_ETzkWB7p0ZEVJsMkF0+_9pMA@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
To:     netdev <netdev@vger.kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Andrea Claudi <aclaudi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 4:49 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> Refactor the netns and ipvrf code so less steps are needed to exec commands
> in a netns or a VRF context.
> Also remove some code which became dead. bloat-o-meter shows a tiny saving.
>
> Matteo Croce (3):
>   netns: switch netns in the child when executing commands
>   ip vrf: use hook to change VRF in the child
>   netns: make netns_{save,restore} static
>
>  include/namespace.h |  2 --
>  include/utils.h     |  6 ++---
>  ip/ip.c             |  1 -
>  ip/ipnetns.c        | 61 ++++++++++++++++++++++++++++++++++-----------
>  ip/ipvrf.c          | 12 ++++++---
>  lib/exec.c          |  7 +++++-
>  lib/namespace.c     | 31 -----------------------
>  lib/utils.c         | 27 --------------------
>  8 files changed, 63 insertions(+), 84 deletions(-)
>
> --
> 2.21.0
>

Hi all,

this should really be the v3, I did an off-by-one.

Sorry,
-- 
Matteo Croce
per aspera ad upstream
