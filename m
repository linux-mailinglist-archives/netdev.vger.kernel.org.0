Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679246AC8D0
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCFQ4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCFQ4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:56:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D131303E8
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 08:56:06 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id a25so41640673edb.0
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 08:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678121731;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r3IkRDRVZcdagH0C98XwXxVYLAYnEe+eFu+NwL4VwjU=;
        b=eynJGeZiIqoWNHLwc7e+q1juo6pOq4zBOlFTr0JEYOdMN4cdE2MpYKj2HCGL0j5KjU
         j/NzEXRNH5EDmWha3EvDL3DyvYHEGLFla10npjtn71v9WRPUS4V5fBSNF22AQfENcLVG
         vRncZTrp7fHN2JsN/vVTg2DGlmFkjJ3jimkDkdKe6wAQbbdgPDcl5RrtMbtpxVttXXFl
         to2R7JyVY7ftm/jCn/+WljklVrwvDTNImMTMwOdT0Y3NWWC2smPHrcJLQgMNrv9d+MNg
         WBAJiMz0c+A9B5ss/pRi7cGSUg30TiCN74WYxNN22GX+LvsimfHVuw8SVWIcqjGJfQ08
         1qRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678121731;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r3IkRDRVZcdagH0C98XwXxVYLAYnEe+eFu+NwL4VwjU=;
        b=hsJObAlEYpqJMYyyg8apLbDiQT70kL7wzCAxMLLsZavKduEihwPx/nISFfhYIsQZCi
         p3T2X758SwW2THovtV7DjUw/2L++bfK2O15x7LWzw+eNAR658zHpLYn215PF6NnqbnPr
         8Bp3T3mbID5TNWWkjQ5H5KocMv5SzipAPS7OMNnwDCLzTS7LCiT0S4VC8tPYLLcF52mQ
         mBO+a235BGIca8NQOZ/kX6KzIQ+6DY7OLvIsQsdAy3ThzyyD8aGCH1cogXgG9tVVCzwL
         hUDs4M9aqSDSlPBYuTzaeJOTG3+ch/RId8GlrlpWhMJy9rJFMaFozMmlpoFWngqPRxBD
         +Dog==
X-Gm-Message-State: AO0yUKV2lMezvvdlsDm8cHrrw8lR/gpyrOHpseTRzMiKlOG+rngpTJaJ
        hso9h9XmcQZx9nxLE6VwJePziuHgEpECkb+u
X-Google-Smtp-Source: AK7set+xXkeigzeNx5vZ7ltiPS6s7lGDQ5dpOv12aEBFv4cQoQL6cxmsLiYJNqugAtJcAbV9TUCSZg==
X-Received: by 2002:aa7:d856:0:b0:4af:6e95:861b with SMTP id f22-20020aa7d856000000b004af6e95861bmr16973888eds.2.1678121730996;
        Mon, 06 Mar 2023 08:55:30 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id a25-20020a509b59000000b004c0eac41829sm5337404edj.63.2023.03.06.08.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 08:55:30 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 06 Mar 2023 17:55:29 +0100
Message-Id: <CQZGI7VY8XBX.3B5BUMEK4V9L1@vincent-arch>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCH v1] netdevice: clean old FIXME that it is not worthed
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "Stephen Hemminger" <stephen@networkplumber.org>
X-Mailer: aerc 0.14.0
References: <20230304194433.560378-1-vincenzopalazzodev@gmail.com>
 <20230304121732.3d102b7e@hermes.local>
In-Reply-To: <20230304121732.3d102b7e@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Mar 4, 2023 at 9:17 PM CET, Stephen Hemminger wrote:
> On Sat,  4 Mar 2023 20:44:33 +0100
> Vincenzo Palazzo <vincenzopalazzodev@gmail.com> wrote:
>
> > Alternative patch that removes an old FIXME because it currently
> > the change is worthed as some comments in the patch point out
> > (https://lore.kernel.org/all/20230304080650.74e8d396@hermes.local/#t)
> >=20
> > Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> > ---
> >  include/linux/netdevice.h | 1 -
> >  1 file changed, 1 deletion(-)
> >=20
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 6a14b7b11766..82af7eb62075 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -2033,7 +2033,6 @@ struct net_device {
> >  	struct dev_ifalias	__rcu *ifalias;
> >  	/*
> >  	 *	I/O specific fields
> > -	 *	FIXME: Merge these and struct ifmap into one
> >  	 */
> >  	unsigned long		mem_end;
> >  	unsigned long		mem_start;
>
> These fields actually are only used by old hardware devices that
> pre-date buses with auto discovery. I.e ISA bus not PCI.
>
> Since ISA bus support is gone, either these devices should have
> been removed as well or they really aren't using those fields..
>
> If someone wanted to clean this stuff out, start by seeing
> if any of those devices still live. For example, the E1000e has
> a couple of variants and dropping support for the non-PCI variant
> would be ok.
>
> All of arcnet could/should go away? Maybe move to staging?
>
> The wan devices might also have been ISA only devices that are now
> unusable.

Well I could do this, also because from the patch [1] that I made
looks like there are not a lot of driver that are using these fields.

However, what is the right process for this kind of clean up work?

[1] https://lore.kernel.org/all/20230304122432.265902-1-vincenzopalazzodev@=
gmail.com/
