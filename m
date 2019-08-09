Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7588530
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 23:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfHIVpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 17:45:13 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:42206 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHIVpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 17:45:13 -0400
Received: by mail-qt1-f180.google.com with SMTP id t12so8685212qtp.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 14:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oop+AI5c482oQpT0qZjGNJLdeB7Bty54SwaOuvEy/7A=;
        b=nz+gw1pGviyEjsT2Pp5j981uYjbNd6UavWAXDhz/PuiAZHq9GJGHaBbO1heePqw+AR
         HNJCZ6VL2HnI55H6MxWQqVsd+Psbngvg9NYV1OoZbnuqnCx1vcHpaCjnANx+693/lRjc
         0le7B+qJzemNOswwLdV+WKkc1IJEAPRugHIxbvkF5JIlf5bT+/wZi70DvbqyTOLzzIk2
         Um3EyNAbfQidxQoPPAa0DaNzEJqQy3BHV2ZlGYuuLZEVv22z93CTczeuJDHW0C3loRGJ
         AIy7ykSlDTu0PGrt+kCxv9uVYeRjgX7qjuDWf/zgvoRGYoIhRcfbQyiROSZ9qDOc4VY8
         fwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oop+AI5c482oQpT0qZjGNJLdeB7Bty54SwaOuvEy/7A=;
        b=mvhrq4mKrV/oEDqfNnmD7XG2FF5KAqiZiMYgXcbWHgOueVE8Ise68CW+DvWgENORUU
         qFsqxRbCf8SBGpgB79aHxgh0d17XHFf6WuWHJIlqRdCbwKo0Po9WMSMU28uv1+Ufw0S5
         XkjwoPx+EgOsnXTaC2cLLvKIjmjY+rCXWCSmQEcRcmtDa43zZyc+Hog86O+yqo0f5HgH
         6AVTDPv2BErnn/36EPwe2DUcIPGpbCJwxCjcUypN5g5SNwjORjDM207s16qpy5FI16k4
         AVEDfqqoKC1ipz7gOsbTqn/Sy/IKV8EuA8aoCh9alMMQRNJ3o1Di2/DCZqEywNTTIe1f
         W4rg==
X-Gm-Message-State: APjAAAWZZ/D3fvQfahzYEjkjlUwB9F+I6D8Po0Zfscs0EmP/HBlWvrHf
        Y2Zr7GFIBrh+RmhQ5bfujWn0iw==
X-Google-Smtp-Source: APXvYqxUGt2HPpiDgUAoI+sRiwk39O6vocCatpWedFsSsf3coSkUqQ+u9Txx8WGk5TondZwj3pI26Q==
X-Received: by 2002:a0c:895b:: with SMTP id 27mr19582421qvq.94.1565387112083;
        Fri, 09 Aug 2019 14:45:12 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t1sm7424600qkb.68.2019.08.09.14.45.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 14:45:11 -0700 (PDT)
Date:   Fri, 9 Aug 2019 14:45:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [v4,0/4] tools: bpftool: add net attach/detach command to
 attach XDP prog
Message-ID: <20190809144509.066d16f8@cakuba.netronome.com>
In-Reply-To: <20190809133248.19788-1-danieltimlee@gmail.com>
References: <20190809133248.19788-1-danieltimlee@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Aug 2019 22:32:44 +0900, Daniel T. Lee wrote:
> Currently, bpftool net only supports dumping progs attached on the
> interface. To attach XDP prog on interface, user must use other tool
> (eg. iproute2). By this patch, with `bpftool net attach/detach`, user
> can attach/detach XDP prog on interface.
> 
>     # bpftool prog
>         16: xdp  name xdp_prog1  tag 539ec6ce11b52f98  gpl
>         loaded_at 2019-08-07T08:30:17+0900  uid 0
>         ...
>         20: xdp  name xdp_fwd_prog  tag b9cb69f121e4a274  gpl
>         loaded_at 2019-08-07T08:30:17+0900  uid 0
> 
>     # bpftool net attach xdpdrv id 16 dev enp6s0np0
>     # bpftool net
>     xdp:
>         enp6s0np0(4) driver id 16
> 
>     # bpftool net attach xdpdrv id 20 dev enp6s0np0 overwrite
>     # bpftool net
>     xdp:
>         enp6s0np0(4) driver id 20
> 
>     # bpftool net detach xdpdrv dev enp6s0np0
>     # bpftool net
>     xdp:
> 
> 
> While this patch only contains support for XDP, through `net
> attach/detach`, bpftool can further support other prog attach types.
> 
> XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.

Looks good to me now*, thanks!

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

* apart from the entire duplication thing.
