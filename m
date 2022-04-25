Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41F250ECFF
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiDYX56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238853AbiDYX5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:57:55 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A371110561;
        Mon, 25 Apr 2022 16:54:34 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id x5so2510193uap.8;
        Mon, 25 Apr 2022 16:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rgDrZbVI8+g9RyKT/pE1kwz+Nl/a1c9fkrp8CVoMJkQ=;
        b=GEwD9m95rm0zL5C7FqVqhtVCfItGfUyxEy+vtFLoUyvtRtFNUasfA2t5bx7cBh5bWr
         3CJD49YlFONz7MyYwidVxQ4yi6jupb3LzdxXdn5tXG1bXoTdfGq7ARxMDR3d1QiZIiNd
         5ahv6P7M3c+31k14NwvkK5dY9HSDHDkJzrIKMwRtRb9FDM4TTYXgRx2qIp/FcbceNIU1
         rUVslxtjN9mVvY+iAxY4u7PCZZBdP+M8GN4QxsmjZ9DFz7XyHQI2c4u1YnIzQLo9o+Oq
         iUEH80cJ6X8bBoApIGFCtkcbJUzFHLxk+GvffY/lhu8+GKghUbdkt9GEgHHPXCXVtwfN
         ipWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rgDrZbVI8+g9RyKT/pE1kwz+Nl/a1c9fkrp8CVoMJkQ=;
        b=y2E6nLTTkeVxnE9y/A+eOQgLJ2gNphUNR+U6owfsEzWHWZm4McRs1CKuWSF2pVkFO3
         4eIJ/Px8nPFu+XCQXBmRvKzDXLFMPXJKB5zAS2T+p+GOx+Gepv+TB8PlUirsOZoXIhSB
         8RQnUw4CGDlBaUunySCyHPErpxsbv8JU44tqzfBBwo0VwGx3nfk7C2rVEXjVhEz8jizd
         0rDbrstu9JsqaNlh68xitiRiJr0HLbP8ldixe4E15qRv+xIkt37GOQbXVri8Ipe91Wn2
         DM50qMxOWOKClNRoIAG3SFy67zoCjw1vPcZjssjUPm9VNc6rUeXk15wOThTV88GQq8TU
         0qgg==
X-Gm-Message-State: AOAM531UQJuts9gj/JTIW46HzzSg2z1z0nICZXsK+yWA6AC/XQJDegLb
        vy9P+GPq/t5Zw/dHbuATRe9cnhkrNiougmv+UH0=
X-Google-Smtp-Source: ABdhPJwS34ErAjJG4a9eezCiJSLGaGueH6w1PrvkDG3TENHE+RUm6TxVhPwCH/53L1H/fhq5vZ3U2amFkh5LQVKoRNk=
X-Received: by 2002:ab0:2002:0:b0:35f:fd13:960 with SMTP id
 v2-20020ab02002000000b0035ffd130960mr6015970uak.50.1650930873454; Mon, 25 Apr
 2022 16:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-7-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-7-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:54:33 +0300
Message-ID: <CAHNKnsQsvuBsRnfv-NJA_fEK5WTydCDvJ6iTR9Pz_KqxsiPF=w@mail.gmail.com>
Subject: Re: [PATCH net-next v6 06/13] net: wwan: t7xx: Add AT and MBIM WWAN ports
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Adds AT and MBIM ports to the port proxy infrastructure.
> The initialization method is responsible for creating the corresponding
> ports using the WWAN framework infrastructure. The implemented WWAN port
> operations are start, stop, and TX.
>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
