Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6795D6AAB61
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCDRDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 12:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDRDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 12:03:34 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB8DEB64
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 09:03:33 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id d41-20020a05600c4c2900b003e9e066550fso2896560wmp.4
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 09:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677949412;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRoRMVP6YkESKWZflhbN5LHdWG/p3LxNDdy/3uOEkCo=;
        b=O69na9crOY5zAsw9EFw/FQ7POzIPLe12zx9IIDL3YwaRZm43kWeGQ0tTMqZn72k0Eb
         2cBHrKEXgOVCd1hD/YGnEl8+rFoZJgMg/sSqYn9Q0nynV3lpH84sg61DVV/qKPXvcIy/
         Sy0X4EquKLQJS2AmynBxZKagXeLyeJXc7O6f7zne04XuOnnWwrel54m3QREiGiN6/Sai
         NjnKmQewPihsEEwo/yqnbUJ8GniQNsrFtnuC6KXFmDk0TVhnHhDQi2mWJTfHgIqP8y55
         8heOugau9PBiD9Asn6ClRQss4QFZ9ETgu/JuJOuotjxEoe9pVyMwmTu52hTF1rpv/EI7
         992g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677949412;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rRoRMVP6YkESKWZflhbN5LHdWG/p3LxNDdy/3uOEkCo=;
        b=5XMNguD0xHLAtcJ7ECHCKUSHE1bvdbkI0F12/Quxq5vCcKOzSYQ0mLWAXi3i5DaO/b
         lYYNyENVuhdseBfNiBB2VSYIzrocwwA1B018oxT81DU7LjuGYBboUppoSDkA7T1DnsTL
         oJ70RXM1hbqLnwHedkYZIW++AVTWJfHUgEvU7saaalJvw4eOeew+JxE7AK6Ozdol6vdQ
         Nkq/8a4H6dh6QHdISgo3NoEMz218f7Lx8zSwNrndD+wWawOpjduvH1EWoCyqWpi8uPYj
         BfiDyjHgKcNM+OlP5k3wZeT3bOFmkGy5qJ0gTEdOJZWtB7pPYzM2iTUQ6Z7s6elKtshu
         l4Eg==
X-Gm-Message-State: AO0yUKXexzAo34lZEH+Zqqb32JDJViMZzLrc7U5KV/leGTdcX7xFK8Cp
        HsN4wQGgkgCAXQdp9wPpt3x/uVXZjnwcSN5Es44=
X-Google-Smtp-Source: AK7set84EZGTIEMvwi1GVX+Zt903jcqPWmtaeEUXvbr0HhyY67V3IS/JK9Ni4uyhSGHNsTdPKw64UQ==
X-Received: by 2002:a05:600c:3b05:b0:3ea:e7e7:95da with SMTP id m5-20020a05600c3b0500b003eae7e795damr4833932wms.8.1677949412003;
        Sat, 04 Mar 2023 09:03:32 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id f13-20020a7bcd0d000000b003db01178b62sm9163050wmj.40.2023.03.04.09.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 09:03:31 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 04 Mar 2023 18:03:29 +0100
Message-Id: <CQXRF9CS3SAI.2TU7KF0UR6V7P@vincent-arch>
Subject: Re: [PATCH v4] netdevice: use ifmap instead of plain fields
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "Stephen Hemminger" <stephen@networkplumber.org>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
        <khc@pm.waw.pl>, "kernel test robot" <lkp@intel.com>
X-Mailer: aerc 0.14.0
References: <20230304122432.265902-1-vincenzopalazzodev@gmail.com>
 <20230304080650.74e8d396@hermes.local>
In-Reply-To: <20230304080650.74e8d396@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Mar 4, 2023 at 5:06 PM CET, Stephen Hemminger wrote:
> On Sat,  4 Mar 2023 13:24:33 +0100
> Vincenzo Palazzo <vincenzopalazzodev@gmail.com> wrote:
>
> > clean the code by using the ifmap instead of plain fields,
> > and avoid code duplication.
> >=20
> > v4 with some build error that the 0 day bot found while
> > compiling some drivers that I was not able to build on=20
> > my machine.
> >=20
> > Reported-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/oe-kbuild-all/202303041847.nRrrz1v9-lkp@i=
ntel.com/
> > Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> > ---
>
> Patching cadaver drivers is not worth it.

Mh, what is mean? they are drivers that are not longer
mantained and/or used?

Cheers!

Vincent.
