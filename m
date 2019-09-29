Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9DBC1413
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 11:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfI2J2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 05:28:53 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37193 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfI2J2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 05:28:53 -0400
Received: by mail-yw1-f65.google.com with SMTP id u65so2457081ywe.4;
        Sun, 29 Sep 2019 02:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LhqJy+3E+saXTZH05/yHEc9OZ1EPzeScFRjq1EhuFKY=;
        b=SUVfiIRPjJYBCgAG6b/jkbsZBh8Pt5tkrR1SNdVcUeovQSuPGe2r888pdOn1zYIk4f
         tLSgxvm5Db86SbdsOPN7guECTghcoJaQJIqNEDqerY8md3sis3DODubfVbMF7y/uDziJ
         hxU3csMf9gWpHKrvldBsU+kLWMju78P8XDmAcjg/HV5vdrh3WrcmQxAHUX5Pe1ClH3bV
         IYnup343opYNSdPE3n5WINJk6zdje1tkwmUU7TQeHDImNinE/JdXosj67luUI5QrF0Po
         dA3JsPqRq177/PS/1LZV15iDt62psOU6qFTeWreKGzn+HeFABib4+9gRoy8VQujp3HE5
         hvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LhqJy+3E+saXTZH05/yHEc9OZ1EPzeScFRjq1EhuFKY=;
        b=ChTS4uHqgEj8jlp/Zfe+V3YYGRomH8J8hiQ/xduXHxtd66t/BXMMc3wer3B2oyLlrS
         TgmHGpgsxmCq4gO2SXIrWxI9tpoiEaWrzdTaXgpxvJTZMBjJ9MmE5Y1bm9At07JVjOws
         KkxHuptCFt0mxLDEgRk77V0GfyZOa3s8X94LnlR+T/xbyMvRxnsBshx2Qf+sOREWA6dc
         /fHTxFPRPTmDWWwq5zntMP1uPMv46w+qdYfj5bFsta+pAErbwQDsWBY1QqALfxwyunqO
         JFpUIpfMFa3/JLCR4t0TaHO7YKGpFJsgxQSfVNCEcvDYMOmW9wm3HiQq4ZJCnE5fyNR6
         8lHg==
X-Gm-Message-State: APjAAAU6V1zj4fv/jZXBUcKC4wzSZxKfrCUBx+yWqGiTb8k7yVtZN1S+
        mUG48+YuwGMVBO6q7JICyjyuwATPBSp2NbMDGMQ=
X-Google-Smtp-Source: APXvYqwXCmu2mATLgc/3/EkZUKydu74jEomPES8eFT1J9JvSUr9NxL9rPnKEAEjkZyKnFbATlstg5uK7HkLy3nU5bR8=
X-Received: by 2002:a0d:d605:: with SMTP id y5mr9542930ywd.510.1569749330770;
 Sun, 29 Sep 2019 02:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 29 Sep 2019 12:28:39 +0300
Message-ID: <CAJ3xEMgJrj3JT-NS7xf8cpAWrQzDi-UAQ0f8S1rsk9Mv7jCsgA@mail.gmail.com>
Subject: Re: [RFC 00/20] Intel RDMA/IDC Driver series
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 7:46 PM Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
> This series is sent out as an RFC to verify that our implementation of
> the MFD subsystem is correct to facilitate inner driver communication
> (IDC) between the new "irdma" driver to support Intel's ice and i40e
> drivers.
>
> The changes contain the modified ice and i40e driver changes using the
> MFD subsystem.  It also contains the new irdma driver which is replacing
> the i40iw driver and supports both the i40e and ice drivers.

Hi Jeff,

Can this be fetched from somewhere? didn't see a related branch at
your trees with these bits..

Or.
