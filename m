Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C458F1C97
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbfKFRiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:38:20 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:47046 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732176AbfKFRiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 12:38:20 -0500
Received: by mail-pl1-f196.google.com with SMTP id l4so6523836plt.13
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 09:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t938QZuinKt/I5Kmc45CqNzpKPUF+1j9MCJO0HzPDqc=;
        b=B2BTHV6hpODkesFyhzbAnB8/8Xh0kqOqKoO15FvUVYgQVadt1yDoGjmIn8Z8bEooYt
         LtfBH4vtHo6Ae51h6gYod9VujsQSFf3xJ1yM9PodhzKfmT/ZAiTBK6hmvoxg2msPVilP
         2peim3m8lJq/glNN0t2nteFtN7aX+I+0ac76QIvv3q4zUlN9GAj6z/MkvVTp6430170d
         yr1iOu8wkWtxL4p1aEiGSeAUEeoutxnJCTWAlejFg5Jtz8wIkz/4Nj5iZqdGLREAA+Mx
         BGpkZBf6uFgSrJzFtTZukCCNW7n/JsY7Li+OUQ43lPPvAACOKhqTcVeevw2PJbTI6vl5
         bWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t938QZuinKt/I5Kmc45CqNzpKPUF+1j9MCJO0HzPDqc=;
        b=feY66oQnvDCbX86XUB8Wa7CQjMcmOa0siXYJIPRX5J7dpeWBL+v0LOIxkiEX7y9t4I
         OCzBmPlYRcYxaXMVY0MQvR1v3U6OQUXCvzH/q2C14m+4+CkBRFotSJVgeeNJjaqb39Q1
         8xnMV2RV1uijR4gizX7VvPi41uAOHwNfX0fbIy3tfi8WfE3m59hMyYhJqcx0aKhSYeZ5
         L5atkAGCGwL+Ie3JAANCOGkKBPgDUe8NO/AzQiGIEbK6FGm84M40J/cL4VOGcc1NiNQp
         zpA+XvQtdOj+jc7WCnT01feCAlawR6+1uotQmjy9l2WNygl3DV26zbG2Y/nmMpyjEvqV
         lNbw==
X-Gm-Message-State: APjAAAX5qwU6zalP/1XrNb3541ropMIHHBOnmF9yrSTqtL/F5/4eI0UG
        0nNLuzcAgrBhjHjBTMLhxRY=
X-Google-Smtp-Source: APXvYqxSh0StOfnNVmXJwMZTTx+rroltnDqi3OeDEGRqFDDJz2MZebYEFnSAv0kpx/8uixTYUpygeA==
X-Received: by 2002:a17:902:a410:: with SMTP id p16mr3820552plq.184.1573061897957;
        Wed, 06 Nov 2019 09:38:17 -0800 (PST)
Received: from gmail.com ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id z25sm22935367pfa.88.2019.11.06.09.38.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 09:38:17 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:38:12 -0800
From:   William Tu <u9012063@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>, dev@openvswitch.org,
        i.maximets@ovn.org, Eelco Chaudron <echaudro@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH net-next] xsk: Enable shared umem support.
Message-ID: <20191106173812.GA24861@gmail.com>
References: <1572996938-23957-1-git-send-email-u9012063@gmail.com>
 <CAJ8uoz1voxsk9+xnKtcvrjmObO8SbOB0BZGxgkqPdejbOmM_ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz1voxsk9+xnKtcvrjmObO8SbOB0BZGxgkqPdejbOmM_ZA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 05:53:09PM +0100, Magnus Karlsson wrote:
> On Wed, Nov 6, 2019 at 12:41 AM William Tu <u9012063@gmail.com> wrote:
> >
> > Currently the shared umem feature is not supported in libbpf.
> > The patch removes the refcount check in libbpf to enable use of
> > shared umem.  Also, a umem can be shared by multiple netdevs,
> > so remove the checking at xsk_bind.
> 
> Hi William,
> 
> I do have a five part patch set sitting on the shelf that implements
> this as well as a sample, added documentation and support for Rx-only
> and Tx-only sockets. Let me just rebase it, retest it then submit it
> to the list and you can see what you think of it. It is along the
> lines of what you are suggesting here. I am travelling at the moment,
> so this might not happen until tomorrow.
> 
> Structure of the patch set that I will submit:
> 
> Patch 1: Adds shared umem support to libbpf
> Patch 2: Shared umem support and example XPD program added to xdpsock sample
> Patch 3: Adds Rx-only and Tx-only support to libbpf
> Patch 4: Uses Rx-only sockets for rxdrop and Tx-only sockets for txpush in
>          the xdpsock sample
> Patch 5: Add documentation entries for these two features
> 
Hi Magnus,

Thank you. I will wait for your patch set.

William

