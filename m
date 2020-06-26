Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEDF20B724
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgFZReg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgFZRee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:34:34 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DA7C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:34:34 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id d27so8062729qtg.4
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYXPiCYsvYlFs4imcsWudI035VGrcsIVZBTqmYPf890=;
        b=DV/PavkgqpVFxBQnxeOI27JnwzENigPC1Z850Fmqx+Zrvxlh5LHQOme0Z6owFueGG5
         6kFD3BEVNXG43hClatlAmTWA439YaL5ALmjeInmp17CNznRiv4CxwE81EaMt1GYnJH9F
         9iiAnrKezMo0Ct9ntvNbgEhuU+KFBTKGFkbk8cdP1hqyEzYzES+kb/haLLiUJ5ikW5Vj
         P0IiYP6/SlxmE8MTGwafy3v9a9YsX0FvB8qwNWrnnPC57Jz2E06AhiBey9ckaZzdnbkb
         5bD/qlNaI9I1SnKGwjSPaLDLw32ruMrqD9MUfUv3W07dT+xXcbNLgiNm4t/GRE3AxJVR
         h6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oYXPiCYsvYlFs4imcsWudI035VGrcsIVZBTqmYPf890=;
        b=NVjtqpUNgnLxVxIlcaQKxRYiaAxYRcmVZT0Of4A95QkbGjTpNkylJPTN7GpYoEMmW4
         fI3vbiL9PIz/90VPTW0w0+rNRoaUeUcxt11jprcxeTzq/GIbi1Epekt3IX5kq2UFOwn5
         CK8gmKnOIzNKnZCstceDxy++DCIAgwp680rO+aeWimdtRuCMTe3sN7V0DACiEiqsNmRX
         LmoLrpHxfNGYHZhefCcwilp7xs+eusGpS7Y12LXpLQygrLmpOCWpqBV/7I+vz+qw6OP4
         xePG5s+nLVMBR5jIZEyjqgHn2KFC+uxf7WMGc44wtuld4Ezpnz0gC8NY6MbCiSQAfWlG
         yhEQ==
X-Gm-Message-State: AOAM532nN0p4SAOpyIa5dUs7ufz4kqpbaXLkz8ly01WErGZj8z+lO7xf
        h0HF+kKcVI1plwiSj3ZSq23JfhEjKQGBYkr+UCM=
X-Google-Smtp-Source: ABdhPJxTSXQk4HNAzIWCHH1eR0403fs3u2TEKN23ZrLXmoPr3YCeQoE6VSNokvP0Rpf3NpnCye3VV3+mFQyY5BYhxiM=
X-Received: by 2002:ac8:4746:: with SMTP id k6mr3934360qtp.234.1593192873152;
 Fri, 26 Jun 2020 10:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200626144724.224372-1-idosch@idosch.org> <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch>
In-Reply-To: <20200626151926.GE535869@lunn.ch>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Fri, 26 Jun 2020 18:33:55 +0100
Message-ID: <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for QSFP-DD transceivers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Is page 03h valid for a QSFP DD? Do we add pages 10h and 11h after
> page 03h, or instead of? How do we indicate to user space what pages
> of data have been passed to it?
>
>    Andrew

From QSFP-DD CMIS Rev 4.0: "In particular, support of the Lower Memory
and of Page 00h is required for all modules, including passive copper
cables. These pages are therefore always implemented. Additional
support for Pages 01h, 02h and bank 0 of Pages 10h and 11h is required
for all paged memory modules."

According to the same document, page 0x03 contains "User EEPROM
(NVRs)". Byte 142, bit 2, page 0x01 indicates if the user page 0x03
was implemented. I did not find anything about page 0x02 (where the
user EEPROM is stored) in the documentation for QSFP. I suppose it is
always implemented? If we really want to have it so it is similar to
QSFP, one could send 896 bytes (instead of 768) and just fill that
portion with 0 in case it's not implemented. Note that this is just an
idea, I'm not aware of best practices in cases like this.

Adrian
