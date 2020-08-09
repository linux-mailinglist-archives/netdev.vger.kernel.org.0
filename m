Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA33E23FF64
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 19:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgHIRLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 13:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgHIRLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 13:11:52 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9669C061756;
        Sun,  9 Aug 2020 10:11:51 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d19so3598517pgl.10;
        Sun, 09 Aug 2020 10:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mgOLBezWt79zIQjvAdBmYqr2eyqE9EwffvrtOtN04PU=;
        b=oBLCXUjlfrw4Fre6KD2wOrQhSVwagOpit8lWuYFs+toIXiUArJWCy86Re6GKyRN6BY
         97PeSSdm39pOiofcF7ufAjWYkjLXxjTARF5pAjRPRE3dyo5ZUwOu4W5zt7nBazPcHJj+
         JVkVGvtc5r0Rn+qCg6pONe+gjA0XH/gKEoOWqmjjE4HoJ+V3HaZKe4shnUSEQpnDpAKz
         U/v8rZ/Vz7nLgX3lsvyFhGQVgd6x/Hzw38qjqYj8kF4jhHsaPlZqT6rvPTAFu2yTOqH4
         fZK5HD9vFCbrBw2nczI9YgZbbtHtzVfpwrs2NNGDRHsbEBKoQKyRAgs8zZbZk8fYa68O
         TqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mgOLBezWt79zIQjvAdBmYqr2eyqE9EwffvrtOtN04PU=;
        b=BvPrXew93w8bftw9MkUxKayh1g/2wsJiSoVOpdyCX/rBSFjFNldRTvYuPPF9FBJLOC
         ic3MRXI5bBLpLGlMCbUEBEH681rTmYwubMpXD/QbzS8/kVmQ3uEyTI7FYFnZEzWKY25O
         FQNCaR8oL+2MkTBN6ocGJQgiDQ2qGT+T7a/t19vmajUk0ov8VAdhaC/yByLNS7bQJOX4
         3GhbseMEG9qPF1FFoFVbskVFZ/Rh1hO95rBbWBhaDzs3pcQi3xjyHAr+W6Dz9y6LaHJi
         5C38nBVCBl2ovLw9EUkxlPBLgJ8gvenNVQU71lLqI4B8Aph0wydo1+pFuCJk5ZFCHFnV
         Jnqw==
X-Gm-Message-State: AOAM5306fITPalTwuPVpwZF/wzEUHmN8bUBWAzQH9NogYHucnXfZFV/O
        bKEbMb79QGT6/8ZMtxO9g0URyyxrl2TnMui971iapLVR
X-Google-Smtp-Source: ABdhPJyCUol4h225ibfdgf3Jy311kXgBRVjVSzQWrRCBbfv77xoPEuKheCtOWWFlnucf5iy3PKPK7K7qcKWfP896FJk=
X-Received: by 2002:a62:8303:: with SMTP id h3mr1814729pfe.169.1596993109816;
 Sun, 09 Aug 2020 10:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200808175251.582781-1-xie.he.0141@gmail.com> <CA+FuTSfxWhq0pxEGPtOMjFUB7-4Vax6XMGsLL++28LwSOU5b3g@mail.gmail.com>
In-Reply-To: <CA+FuTSfxWhq0pxEGPtOMjFUB7-4Vax6XMGsLL++28LwSOU5b3g@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 9 Aug 2020 10:11:39 -0700
Message-ID: <CAJht_EM9q9u34LMAeYsYe5voZ54s3Z7OzxtvSomcF9a9wRvuCQ@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Added needed_tailroom
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 9, 2020 at 1:48 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Does this solve an actual observed bug?
>
> In many ways lapbeth is similar to tunnel devices. This is not common.

Thank you for your comment!

This doesn't solve a bug observed by me. But I think this should be
necessary considering the logic of the code.

Using "grep", I found that there were indeed Ethernet drivers that set
needed_tailroom. I found it was set in these files:
    drivers/net/ethernet/sun/sunvnet.c
    drivers/net/ethernet/sun/ldmvsw.c
Setting needed_tailroom may be necessary for this driver to run those
Ethernet devices.
