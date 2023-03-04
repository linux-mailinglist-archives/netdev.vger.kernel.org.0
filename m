Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3986AAC1F
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 20:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjCDTdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 14:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCDTdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 14:33:43 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1FDCDE6
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 11:33:41 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id az36so3474396wmb.1
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 11:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677958420;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pYJuOHy6ey6sKW/GVsJJOVLV3R+SJynIVwsy0b2HCrE=;
        b=pgVhJShZuzbLJxqmMY7P3JuzmuDkQkmmQksMw8r+vYQ7j2vuhdspSOCvAihJ0sZGu5
         kFckdUq2vMcaSpPB5ObwmWCRKMeNcBVrmqtMeWUdX+acSfmg6Aq+AC/vKWkjsH4AZPid
         +pyQ30BMjyikz+Ekozndq0ck1xwm+5xIHLoAuXyGcJ23GxrZwYhRmJDWmz+Vl1QgmdAN
         c01VgfucaR9So8ayadVkOPAOGOx4xl+KUf1+gtoDFcXfWPFxSitbH1zZYX+4TLYyx0Ji
         MlpBXLSPcFJVQitnrYvbVEpQH2jEMD7eflqIokxoKNSL3S6Hz7U7ZgxXykLoxxujZKtR
         XJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677958420;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pYJuOHy6ey6sKW/GVsJJOVLV3R+SJynIVwsy0b2HCrE=;
        b=7v92gIuaqFqQox3xfLa9y9EJFQPm//YrCGiCXCXf3INZONXgTmgk5mu6sr7yMND3tq
         3z1SrRNK6yFeHY6MSkRZXHRdlJPJxzlGSE81LomSFoyLr0eOklJKDdP0AOFEr0URkSMy
         Cu2MXgA7/5GfvE3jZU0dKPo3IiRC8WOXatGQ2pQsorZznNTVrVRRq1vJYzKUtXppHyh6
         egwsxRV6gmxCFtKjJgAIEGuQSibDwlm2zmDvUHXf2OivcCRCRbKjMBwRILD1WDPQwpuz
         H9CAVr7cq4I6ND+1mGlUMiG+UlbynDYf78YiypRnlwHcseaaspEogDtepX2juAi14v/Q
         MbLA==
X-Gm-Message-State: AO0yUKXzVpbglv8QscO+Z0dOcN5Szbr22vBBRTeiqB9ZgvcTQmdUHxeS
        gPiyayE21fqGAwYFpJGbeJ8=
X-Google-Smtp-Source: AK7set88FRPib16c0RvSSUbf250TGhbybX3NvuZ3eFFUcS3Belffl9daDxa/nz+2lkq940Wp9gqrkw==
X-Received: by 2002:a05:600c:524b:b0:3df:de28:f819 with SMTP id fc11-20020a05600c524b00b003dfde28f819mr5143013wmb.15.1677958420080;
        Sat, 04 Mar 2023 11:33:40 -0800 (PST)
Received: from localhost (93-55-83-125.ip262.fastwebnet.it. [93.55.83.125])
        by smtp.gmail.com with ESMTPSA id g12-20020a05600c310c00b003dc49e0132asm10852100wmo.1.2023.03.04.11.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 11:33:39 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 04 Mar 2023 20:33:38 +0100
Message-Id: <CQXUM7MRJU3X.321CXIWRLP8ZL@vincent-arch>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
        <khc@pm.waw.pl>, "kernel test robot" <lkp@intel.com>
Subject: Re: [PATCH v3] netdevice: use ifmap instead of plain fields
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
X-Mailer: aerc 0.14.0
References: <20230304115626.215026-1-vincenzopalazzodev@gmail.com>
 <20230304110641.6467996b@kernel.org>
In-Reply-To: <20230304110641.6467996b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Mar 4, 2023 at 8:06 PM CET, Jakub Kicinski wrote:
> On Sat,  4 Mar 2023 12:56:26 +0100 Vincenzo Palazzo wrote:
> > clean the code by using the ifmap instead of plain fields,
> > and avoid code duplication.
> >=20
> > Reported-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/oe-kbuild-all/202303041847.nRrrz1v9-lkp@i=
ntel.com/
> > Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
>
> Please don't, as already explained it's not worth the code churn.

Ah! ok I got it, yes maybe this should be an RFC, I thought also that
this change will impact in so many things!

Ok, so I will remove just the FIXME that at this point is not=20
useful anymore.

Cheers!

Vincent.
