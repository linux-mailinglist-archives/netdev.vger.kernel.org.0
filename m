Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5921270AE
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfLSW3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:29:38 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43245 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfLSW3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:29:38 -0500
Received: by mail-ot1-f68.google.com with SMTP id p8so9117567oth.10
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 14:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mVfH/DcBVTGGcN06CBWiYIkpYmFLLGeZfHdqym/IvI4=;
        b=TwUgs2DzOb6iEdvi+U5v9+i/CUHRM89Ke2f9204/Tbra1lJjOa4P+jETDPgYi6lbrr
         PG94qJYZ1TvqUTKYZ4g8eVIvcnwIme/hNHBHcvtjooKWIXMEHibkdgBzCxobW6uupOYP
         ixPrl1N0ManGLDWzZyBCRhiflaT44iHQRRmWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mVfH/DcBVTGGcN06CBWiYIkpYmFLLGeZfHdqym/IvI4=;
        b=ny8b4WGcI89rQGFKB1WXenL40CmFYdsNu67/8dDp4lGELxx69ayBKftYopNwxYBJNx
         rQcMSZpenysq3E+Bj9uwRkf+5SMCeej5lFrkmgnbvJjIEROAP66rFwNWYDivxM+ZXL7v
         qQdkX3Gwp/K9akHdjIeqWVQkb86skhN9LayhuwRyFy0WejNK4sqL8n6QF/JhBnHyXg+E
         FKe2r9NFLSWFMXiT4043MCNcbHE2k3X3rdz3H4MR3ONaGA7kHbWp5IrIWVM+QLvsx7aG
         MPaRc8jS1VGigH5PuCuSzPXDyu4x+EGMl7DDf9XgsUFuYkbvNIN+kHgG85KC5CdYTW3W
         Z1Jg==
X-Gm-Message-State: APjAAAVVmJ0JNztXiHndHgxDexZnxgstMgI6nDFJXsh7REkbTZIwOm+E
        BOZnDQAQFLsujvWOjnRER9txAUVCTC/wulX1d+IrgmWW
X-Google-Smtp-Source: APXvYqwe87jaNmincKXmouV0Bg+5H/JmnuyMhZ4FFQ5LCiZmLNkIJSE0B90jgcTjfumNwbFH2YrEzolM3lzqT83Pxww=
X-Received: by 2002:a9d:784b:: with SMTP id c11mr10811917otm.246.1576794577471;
 Thu, 19 Dec 2019 14:29:37 -0800 (PST)
MIME-Version: 1.0
References: <20191219183516.7017-1-manishc@marvell.com>
In-Reply-To: <20191219183516.7017-1-manishc@marvell.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 19 Dec 2019 14:29:26 -0800
Message-ID: <CACKFLi=SPzHRXXMYXNecRjYNaKVZ5uOz1DAhZXXLLF4A+Wh2mA@mail.gmail.com>
Subject: Re: [PATCH net 1/1] qede: Disable hardware gro when xdp prog is installed
To:     Manish Chopra <manishc@marvell.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, aelior@marvell.com,
        skalluru@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 10:35 AM Manish Chopra <manishc@marvell.com> wrote:
>
> commit 18c602dee472 ("qede: Use NETIF_F_GRO_HW.") introduced
> a regression in driver that when xdp program is installed on
> qede device, device's aggregation feature (hardware GRO) is not
> getting disabled, which is unexpected with xdp.
>
> Fixes: 18c602dee472 ("qede: Use NETIF_F_GRO_HW.")
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
