Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86665E706C
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 02:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiIWAA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 20:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiIWAAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 20:00:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54888F8584;
        Thu, 22 Sep 2022 17:00:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q3so11345187pjg.3;
        Thu, 22 Sep 2022 17:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=doTF54kxpUq01XVd1M1z4LBvecAkGoOPNNz/NgZ0K5o=;
        b=VjR+jvn8JGBYrkohscDoaleGHBdC7mA2kaT3LFTttWGJ8FF7BFhJbZ4w2TUfjh6jE5
         epQLPkRy/4XSLL1ss/R6uy0skzav1Kht5pEpkcUssi3BbyPDn95GFsf3TvQujqMWbli8
         gEEu3oWQm/ajmsq1ClEGHlJL4ljd2gHussTQiDE5wM/5rCTbAEAuGmKYA8wxmxR5wqIJ
         KGMi5jps7c++ZhWTXN2szoD7WmDsEt5f8GqN7ClZZBcZ3oUqeICfwNzLL5DG2UOeOtSZ
         QviHQYNQ+Cw9vg8CLROmLxelBvBGeQHmHQ/3rjlPam+xFAgaAREL3FTQh40tPCoyW2kj
         enQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=doTF54kxpUq01XVd1M1z4LBvecAkGoOPNNz/NgZ0K5o=;
        b=dM/fJOd5zVBOdZ9mlSy+vcI1GifMrOfPYt+6X2oucQ6e0GVf1lYfvSDSz9QtH4338N
         X+P8Z8cOx6MOMf9LSwFdRrsR8Jz99a2F83Vm0m39IZVJG2yiYj1/lFVydF0XvX3paPvp
         aVNc0+H3bCPhiAiFpae8PZIWyKVsh7yHNfKkHWxW+O98yJIv2f1c89qJr+X2ENGNHcgz
         SSfyI2TAMqbRf3EYrGLbxNzEeQEwJs1mt++wtnO6wORg7iRpR5x/C7hwjZ9UHXPtCjBy
         TBKxklBByrmQcVS9LMovAZS/OcVUWke+05XyeWfJ62vY+11k5PH+jO1ojgf4AlBiA9BV
         VP7A==
X-Gm-Message-State: ACrzQf2Ar1Winln45jMilhcOohjYpPTBLGpjoZAYja6RpGHN9iU6ETGm
        8s58GnfNEU8kMUbTST5S1TRISeGwEiY=
X-Google-Smtp-Source: AMsMyM5qT8sENZqnzkT5Z0IjzEeVY8nzXYzQOb9lsFr6dsdMc6GfRU/vk422OpVuoGJPjp5Lu7J6hg==
X-Received: by 2002:a17:90a:c258:b0:202:b93b:cb89 with SMTP id d24-20020a17090ac25800b00202b93bcb89mr17606585pjx.126.1663891220689;
        Thu, 22 Sep 2022 17:00:20 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.37.164])
        by smtp.googlemail.com with ESMTPSA id m7-20020a17090aab0700b002008ba3a74csm324645pjq.52.2022.09.22.17.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 17:00:20 -0700 (PDT)
Message-ID: <c6454874c531dd9e6c50c2110d47903b87a1e165.camel@gmail.com>
Subject: Re: [PATCH v2] headers: Remove some left-over license text
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>, yhs@fb.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Thu, 22 Sep 2022 17:00:18 -0700
In-Reply-To: <88410cddd31197ea26840d7dd71612bece8c6acf.1663871981.git.christophe.jaillet@wanadoo.fr>
References: <88410cddd31197ea26840d7dd71612bece8c6acf.1663871981.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-09-22 at 20:41 +0200, Christophe JAILLET wrote:
> Remove some left-over from commit e2be04c7f995 ("License cleanup: add SPD=
X
> license identifier to uapi header files with a license")
>=20
> When the SPDX-License-Identifier tag has been added, the corresponding
> license text has not been removed.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Changes since v1:
>   - add tools/include/uapi/linux/tc_act/tc_bpf.h   [Yonghong Song <yhs@fb=
.com>]
>=20
> v1: https://lore.kernel.org/all/2a15aba72497e78ff08c8b8a8bfe3cf5a3e6ee18.=
1662897019.git.christophe.jaillet@wanadoo.fr/
> ---
>  include/uapi/linux/tc_act/tc_bpf.h        |  5 -----
>  include/uapi/linux/tc_act/tc_skbedit.h    | 13 -------------
>  include/uapi/linux/tc_act/tc_skbmod.h     |  7 +------
>  include/uapi/linux/tc_act/tc_tunnel_key.h |  5 -----
>  include/uapi/linux/tc_act/tc_vlan.h       |  5 -----
>  tools/include/uapi/linux/tc_act/tc_bpf.h  |  5 -----
>  6 files changed, 1 insertion(+), 39 deletions(-)
>=20
>=20

<snip>

> diff --git a/include/uapi/linux/tc_act/tc_skbedit.h b/include/uapi/linux/=
tc_act/tc_skbedit.h
> index 6cb6101208d0..64032513cc4c 100644
> --- a/include/uapi/linux/tc_act/tc_skbedit.h
> +++ b/include/uapi/linux/tc_act/tc_skbedit.h
> @@ -2,19 +2,6 @@
>  /*
>   * Copyright (c) 2008, Intel Corporation.
>   *
> - * This program is free software; you can redistribute it and/or modify =
it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOU=
T
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License alo=
ng with
> - * this program; if not, write to the Free Software Foundation, Inc., 59=
 Temple
> - * Place - Suite 330, Boston, MA 02111-1307 USA.
> - *
>   * Author: Alexander Duyck <alexander.h.duyck@intel.com>
>   */
> =20

Looks good to me.

Acked-by: Alexander Duyck <alexanderduyck@fb.com>
