Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C4110A594
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 21:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfKZUkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 15:40:49 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:41772 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfKZUkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 15:40:47 -0500
Received: by mail-qv1-f68.google.com with SMTP id g18so7903605qvp.8
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 12:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hZS0DOzhdXc14SRcDepXoDm9fZsWuamRk2Ch1O62Y6M=;
        b=AyMO8rPj9LC6qYrwszqbZ4FAZrfDRjArzZAfENajH2/k54YS7qEovG3akaP1pfq998
         oupGI0fYi00PGvxzZzGMaLi+EWH6KEMUbqza6qlQCmZQCOsuqrj+BFPw02uFj6PZV+pN
         NErENlOUIIeSCg8QvAUE7qBGs8sCvr79sXlSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hZS0DOzhdXc14SRcDepXoDm9fZsWuamRk2Ch1O62Y6M=;
        b=XO+VTayRYxgC/hDRIr4hA5wBu8pY+x4GemQZQCTGbITCM8YEg1CXaJ92Uxji/1W/L4
         9VIVJyuL2L7PlL3c2jntXO5+TsVniy76NrjOeAXZTMVdfgbRC03NbCves9kSA5onMWOY
         ChsQcQeXqLHVDffBwECDrYaFpJbwU1jevWHp3d1RRWT2WFgPUxWyElHToDbaTAb/nvPZ
         OBTTOLjwmTjT839imkEA/JS6Rvu+k1m7ucAdVuI/9j8PPJLlne1348jzmSn6dQkm/QoW
         2ZYfms7niYY4Cc9ZHox90CpbhINoDWGwjfJ1optQg4Wznym5CG9c57JYb4GrvbM62Ct4
         AOeQ==
X-Gm-Message-State: APjAAAUp0j9wyya/8bKmP6CM8R3D4BpAgZqECyExogEJrQ3T0f97XSXw
        NcFNyEExfxhtMF8Pu3DKZSixY7+LjPLZG7SR7LTGOQ==
X-Google-Smtp-Source: APXvYqyHWYlmAddGhtDAqk04GEexsdJ04kAI1FRb4pWTtUfU042FjywMeWoKRVllBy2/VViLe4Hc7w3el+bRbeVWXlU=
X-Received: by 2002:ad4:568d:: with SMTP id bc13mr768895qvb.102.1574800844776;
 Tue, 26 Nov 2019 12:40:44 -0800 (PST)
MIME-Version: 1.0
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
 <1CEDCBDC-221C-4E5F-90E9-898B02304562@holtmann.org> <CANFp7mXNPsmfC_dDcxP1N9weiEFdogOvgSjuBLJSd+4-ONsoOQ@mail.gmail.com>
 <1CEB6B69-09AA-47AA-BC43-BD17C00249E7@holtmann.org>
In-Reply-To: <1CEB6B69-09AA-47AA-BC43-BD17C00249E7@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Tue, 26 Nov 2019 12:40:34 -0800
Message-ID: <CANFp7mU=URXhZ8V67CyGs1wZ2_N_jTk42wd0XveTpBDV4ir75w@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Bluetooth: hci_bcm: Additional changes for BCM4354 support
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Marcel,

The series looks good to me.

Thanks
Abhishek

On Mon, Nov 25, 2019 at 11:19 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > It looks about the same as one of my earlier patch series. Outside a
> > few nitpicks, I'm ok with merging this.
>
> I fixed the nitpicks up and send a v2.
>
> However we should still work towards a generic description of Bluetooth PCM settings for all vendors. Any ideas are welcome.
>
> Regards
>
> Marcel
>
