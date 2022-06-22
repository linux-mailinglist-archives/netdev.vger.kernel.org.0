Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789C6554108
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 05:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356521AbiFVD4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 23:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356385AbiFVD4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 23:56:53 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E323338A7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 20:56:52 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-101dc639636so11189635fac.6
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 20:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=GGJ5a6nsN1n16aIiduPIGZ0ruWZrfDVKCjBwjwxe33U=;
        b=CqQoNjqCMi5NpxzGg/roDYp9gLfQVinl9CBCQC0VTpH97CD+LR9nd0vghZGmzk2t+Y
         7/29uEzIy8apyEyhJ0zYDhJ6j33ar6P6OPvpMPrGemVtJ0e656n96oCI7bDRp16WWAFN
         iyu9gsDcFcMIeVKUb/TbJiC8NYESFGn9e79pSwQoHHeVv3WdUkrH36Lg99OG2/lepC5x
         foqutgt7n7flK8zuL1IZ5Osg22pVatW75S2F9gN0nfyHthYMrZRrrglIVcd9zjDMlE9S
         Ufv5ke1sFSeA1GkdJ0jS+gFspDOdaOM4cnm3rWiYdtRfce7+qB0tOPI99YDmOiqAxNcT
         Ezrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=GGJ5a6nsN1n16aIiduPIGZ0ruWZrfDVKCjBwjwxe33U=;
        b=MTZ2KV8xHWXK+stRrk/1RWe5ZetzVpZ57K8xWX+3cdIBnCSTdwxSuT7SaCMjUfMJ61
         TZAB51AtNEERANtfMPZHy9qJYCZYjnus+xtXzTzTqgujc0sgXrLx4e9j4x2c4gURKsWs
         jnlPWHeujc6izsS9+x2JTtwV3KNcto97md1oD3TvG14SFIASWTJEjCSHVT8MDQ8Mu4nP
         9FQMgQr4X+In9MnTTtB9C6qi/aMvdpw1QUMKkmepHr5XVxNT+dcoJlrP0ts0Tbbp5c2v
         0skuVqEglBMjl2lSz7qxsxdCnaRE6JJPnBHoNGVulZeVqI+jjeScjA2/UcEQSrkPOXbU
         jTCQ==
X-Gm-Message-State: AJIora80JXS+dD7+fKimGkcDT2VEc4dHLAG2Ch8NpYF6nXaKVOsnOA0R
        1APf2mpfk96EL15BXiEV9Dw=
X-Google-Smtp-Source: AGRyM1tJpdXkTutZOIcEQtqFGsnavBsqWNDCEFZUcRcQCRTQcmbwY5tbjZQQsrHvFwju0YWTJHQGbA==
X-Received: by 2002:a05:6870:c8a9:b0:f2:87f0:670b with SMTP id er41-20020a056870c8a900b000f287f0670bmr856445oab.143.1655870211616;
        Tue, 21 Jun 2022 20:56:51 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:96e6:64c:ef9b:3df0:9e8d? ([2804:14c:71:96e6:64c:ef9b:3df0:9e8d])
        by smtp.gmail.com with ESMTPSA id w8-20020a056808140800b0032b61c33352sm10732573oiv.7.2022.06.21.20.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 20:56:51 -0700 (PDT)
Message-ID: <cfe8c71d0291b5612afc3765da470c21a9fad87b.camel@gmail.com>
Subject: Re: [PATCH v2] net: usb: ax88179_178a: ax88179_rx_fixup corrections
From:   Jose Alonso <joalonsof@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Wed, 22 Jun 2022 00:56:48 -0300
In-Reply-To: <8cd9e84dabcf2efbf80f3bc43326bbea8bd21a98.camel@redhat.com>
References: <24289408a3d663fa2efedf646b046eb8250772f1.camel@gmail.com>
         <6dacc318fcb1425e85168a6628846258@AcuMS.aculab.com>
         <72d0a65781b833dd3b93b03695facd59a0214817.camel@gmail.com>
         <8cd9e84dabcf2efbf80f3bc43326bbea8bd21a98.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 2022-06-21 at 11:03 +0200, Paolo Abeni wrote:
>=20
> Possibly a slightly more accurate adjustment would be:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* for last skb */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skb->truesize =3D SKB_TRU=
ESIZE(pkt_len_buf);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* for other skbs */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skb->truesize =3D pkt_len=
_buf + SKB_DATA_ALIGN(sizeof(struct sk_buff);

For now I will use your suggestion and resend the patch.
I will think about David suggestions.

Thanks

Jose Alonso



