Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B8B249303
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 04:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHSCsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 22:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbgHSCsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 22:48:15 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C30C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 19:48:15 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id h16so17950957oti.7
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 19:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lXeL2NqENRyGepDGalfKTgrjgpPAYVjCiCWgtC+osv8=;
        b=a4omXrGFt2mE73+iut1A5IhTEFfx6pamQME9IhWd57cwGlHU0WCx/xyCsDMW9oCRx/
         r5Je+Jnqvv1oGb7qtzaDv7HdK8PFQzuo5T1zxSjyPR57HwOTgkaLE65klwpLM+bA3M/d
         6UjCbZvUpey/j0kaj3lyZFqRoIQMTdTLmSwIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXeL2NqENRyGepDGalfKTgrjgpPAYVjCiCWgtC+osv8=;
        b=Uul8BDzRWEW/Ovyk90aF14a5LSaztqHVUFvnRYohUBKWMNAvoHgxvsXBIz8ktQZIID
         OUmZtVLHXEZ6ha8R0gQq6dYZ6dqc6hRDVbvK68vFixayPebzgE9EtpZMWdP4mrSW3nDv
         9HN++bbrwjVuQa6LzM3aMEYXejIE6ifMGyjVbk5UL0LbECl4QzCPQZ8H1uY4CH8p6d4y
         BKer6jxcCI6Vz70uz0t7do96PTBT4p7j/EpxyCTyN2OBCo8SqZKOBnWzBxXARleGMwDZ
         BycyOdHCB1Ar4NzPWOYyHetPQDQMyzJmbMLWxCfXXrXMZMR1R5MNIMsfcpMucIbbgwe7
         WWDQ==
X-Gm-Message-State: AOAM532tqnKtn2lzR5pv9HNFisKE6SNfnMoTUPR8GFj8YqNivCSSmKx5
        dshgtO2gJNks7ssRdvEA545Ks8gz4TSgUWofzqMc9g==
X-Google-Smtp-Source: ABdhPJx7w/5ngmosBOb0nMnQpaaLLJ1ixcBwEM2m0noWsqACqIeFsrPmFWmcpoi9Um2KGR21e//49yJBL9TQ+yUx080=
X-Received: by 2002:a9d:6f85:: with SMTP id h5mr17108737otq.81.1597805294630;
 Tue, 18 Aug 2020 19:48:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200813084129.332730-1-josephsih@chromium.org>
In-Reply-To: <20200813084129.332730-1-josephsih@chromium.org>
From:   Shyh-In Hwang <josephsih@chromium.org>
Date:   Wed, 19 Aug 2020 10:48:03 +0800
Message-ID: <CAC9bf3SZKuCan1uDLZ55e0kHychy=6BHb1Cn4O0e5yJwBe1Wzg@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] To support the HFP WBS, a chip vendor may choose a particular
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     Joseph Hwang <josephsih@google.com>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers:

These two patches are to expose the WBS sco packet length to the user
space. Since different vendors may choose different USB alternate
settings which result in different packet lengths, we need the kernel
to expose the lengths to the user space to handle the packets
properly.

Thanks!

Joseph


On Thu, Aug 13, 2020 at 4:42 PM Joseph Hwang <josephsih@chromium.org> wrote:
>
> USB alternate seeting of which the packet size is distinct.
> The patches are to expose the packet size to user space so that
> the user space does not need to hard code those values.
>
> We have verified this patch on Chromebooks which use
> - Realtek 8822CE controller with USB alt setting 1
> - Intel controller with USB alt setting 6
> Our user space audio server, cras, can get the correct
> packet length from the socket option.
>
>
> Joseph Hwang (2):
>   Bluetooth: btusb: define HCI packet sizes of USB Alts
>   Bluetooth: sco: expose WBS packet length in socket option
>
>  drivers/bluetooth/btusb.c         | 43 +++++++++++++++++++++++--------
>  include/net/bluetooth/bluetooth.h |  2 ++
>  include/net/bluetooth/hci_core.h  |  1 +
>  net/bluetooth/sco.c               |  8 ++++++
>  4 files changed, 43 insertions(+), 11 deletions(-)
>
> --
> 2.28.0.236.gb10cc79966-goog
>
