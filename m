Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE55D2437C7
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 11:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHMJjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 05:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgHMJjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 05:39:17 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C628CC061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 02:39:16 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id k18so3790325qtm.10
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 02:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ulQzuiDpUqLEqeHOXUjra/6wwjdZ2iIrqjW5uiesgA=;
        b=h0Em26xLF09pdlmsWUB4G08wMfw5HKFOKFLlkzCdfsf1ZX4BLPWqyYPtMtQ/pl98jy
         zmR87ui8YLrRJyb1Q+LloZffTB8oEdpD9jTmgip9ysvDGbzUrXlnPiMxySqrWB9pkGss
         zPIauuvRAq1B1rtP8GlN6mLfHz6kZWrwa8CBFtWJucHDbDfZ/XiLNRom3Nz9xUCJ7ozy
         x/1pLZMaiHijD2NpIPv1pMPJE9qpsZ2l9b0DR1mO1PxNITevmI7sm0e7nx0h2v3jw7HC
         QiHvxeLdnJnsXrd8TiehQ7kZA/v+XmGZkFNwuwWuCUurX3dtgi4MRCUPuNrN50JEUc6l
         ntLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ulQzuiDpUqLEqeHOXUjra/6wwjdZ2iIrqjW5uiesgA=;
        b=cLkYiFgBW+76O0G+kHZ+1pcJIagmysK8x52C+uVOHw4i9hdtIQWgSt3qy76cBQRe5Z
         aqWMrVEx4IR9tbhc0wJ4OpUV1XbLfNWUiBXiRps5keNs4Iy4QXjg/kEq36kHXI0THz2I
         Wwv/Uzi/CrdKsUbeb8c99BoexJseFfScoqW8zBz15Mme0sRiqUaQTQNVSymlg27NF93w
         K9OHDDtxSL7RoegT7BB6qJvDTen6XewpeVJRSjJtiEBKNoFA3PFu3Gw6nZR8WJatsG+s
         dNIT3QIVMxkd6I1fRuiRJA+iLZJa0a18hG+im+6IR1bNJfdIXta/Q3ELMzDogS+TYUZM
         93yg==
X-Gm-Message-State: AOAM533ErXdOKgW+OEpTRw6rqQZipDTzaIqeQmbdBBwIvC3aINVCltKz
        goNYD4zeEETvn5IDriX9aA47PVNZBNVJC7aUOTFLfTNBMN0=
X-Google-Smtp-Source: ABdhPJwRRXJ5zjFyHBTeXNepaN+PwY+0iqgYwznwWbxos1VToS+Kd9TEllKaCNd/yl8At8cmMeAGLBqNbLciXbhNV/g=
X-Received: by 2002:ac8:6e9b:: with SMTP id c27mr4175090qtv.189.1597311555714;
 Thu, 13 Aug 2020 02:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200813071735.7970-1-popadrian1996@gmail.com> <20200813092402.GA3426088@shredder>
In-Reply-To: <20200813092402.GA3426088@shredder>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Thu, 13 Aug 2020 10:38:38 +0300
Message-ID: <CAL_jBfRMf9rif+oSA7kUdj5E1DAqrZ43FwWPAU3pcqRqskbnkQ@mail.gmail.com>
Subject: Re: [PATCH ethtool v3] Add QSFP-DD support
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paul Schmidt <paschmidt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Sorry for that. I'll resubmit v4 and I'll add diff from v1, diff from
v2 and diff from v3.
I will also add Michal Kubecek.

Adrian

On Thu, 13 Aug 2020 at 12:24, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Aug 13, 2020 at 10:17:35AM +0300, Adrian Pop wrote:
> > The Common Management Interface Specification (CMIS) for QSFP-DD shares
> > some similarities with other form factors such as QSFP or SFP, but due to
> > the fact that the module memory map is different, the current ethtool
> > version is not able to provide relevant information about an interface.
> >
> > This patch adds QSFP-DD support to ethtool. The changes are similar to
> > the ones already existing in qsfp.c, but customized to use the memory
> > addresses and logic as defined in the specifications document.
> >
> > Several functions from qsfp.c could be reused, so an additional parameter
> > was added to each and the functions were moved to sff-common.c.
> >
> > Changelog (diff from v2):
> > * Remove functions assuming the existance of page 0x10 and 0x11
> > * Remove structs and constants related to the page 0x10 and 0x11
>
> Adrian, you're missing diff from v1 and Signed-off-by tag.
>
> Please send v4 with these changes.
>
> And please CC Michal Kubecek <mkubecek@suse.cz> on ethtool patches since
> he maintains the tool.
>
> Thanks
>
> > ---
