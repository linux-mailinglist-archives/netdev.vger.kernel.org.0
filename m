Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63A369535A
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 22:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjBMVsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 16:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjBMVsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 16:48:07 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80321EB6D;
        Mon, 13 Feb 2023 13:48:06 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z1so14989413plg.6;
        Mon, 13 Feb 2023 13:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dI9DvMLbtzBAWFtPw6yhIul4CbP/+FfHPb/9cZPQWfE=;
        b=flX3Igx11SdyUAKm0NUHvNhiDp/k2Ibx0g4uaENDaEug8KA0E7rJd9f68hOcmbmmzL
         9Ua7UB1irXGv9JdnvCfGubkyd8awMwyVnAGBFlF2CgEShHk5DQPfdq+EoAnY5QzYcDhW
         a/mqCcMifPzjC12IQN/wybsF6tm+ElB9iZ2vc9Rx4bfFsg9Oo2yDaDm41Wlaucv0gDyI
         jGx4ZLKZJ+aDtPGNH9I974bq/MY+8ckkq+amU8a7Q4e7EthKQ1Xck17eup9ZexhypN9B
         TEvK6r0Z57hHMYw0mf1QASA0fweyiDSZt/D7kKO3GoNeZWenQsKtqMZ23aFUHHNIUSTt
         9QFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dI9DvMLbtzBAWFtPw6yhIul4CbP/+FfHPb/9cZPQWfE=;
        b=LYEgFMOJvMP91HkYMZIYIhW94oWTeTC29aQIu7s/k5Qs5nMxNcoVZB0epQgaCkjbVz
         wdfd5pGjjnFXp138Jq6S1FFokK20xpr9JNqGKSiNvxOWaPMY/0CpNDg1QP5XZPOrrS/V
         uE6vr2lTw8QVQjMmRWgusLKUXB591IY2bQ7lmPTZ08eRKMhpOituke7WxZyG/j//8bHi
         klsyQMkc0u51SY2/4qXyVN5sPkH9I9UjrMadgAb2jvHuSyfWODHLrE5DF3iQff7ih78X
         E0jJgOsP0SYK8d6QWqBngVO7vlMXUo/XlFjjxWggHQldWSJ72CUJCjTTAVu+2KteD2gb
         qP8Q==
X-Gm-Message-State: AO0yUKV2B7D5D6B9ADO3j//HaoAx81n8mPQezagNWYZV/IOz0208+Nn6
        GqR0ixs8PCua3cgR3P43+ST5ZxLXlVgxsYj9ZlE=
X-Google-Smtp-Source: AK7set/jGsgXJH0z+uu/JC4wFRBssRg6vpaea0uJu1GR6Bop5ldqt914lPObeM5jXLw/hC3mg3EpCopLC4Ud5upZZmU=
X-Received: by 2002:a17:90a:684a:b0:233:a8ae:d198 with SMTP id
 e10-20020a17090a684a00b00233a8aed198mr2751698pjm.99.1676324885969; Mon, 13
 Feb 2023 13:48:05 -0800 (PST)
MIME-Version: 1.0
References: <20230213213104.78443-1-ahalaney@redhat.com> <20230213213104.78443-2-ahalaney@redhat.com>
In-Reply-To: <20230213213104.78443-2-ahalaney@redhat.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 13 Feb 2023 18:47:55 -0300
Message-ID: <CAOMZO5C3mXXu7G=HDV1kytPMf2QFVuf2WGeP-YQHxFtaoggUXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        linux-imx@nxp.com, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com, mripard@kernel.org,
        shenwei.wang@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

On Mon, Feb 13, 2023 at 6:31 PM Andrew Halaney <ahalaney@redhat.com> wrote:
>
> The property is named snps,reset-gpio. Update the name accordingly so
> the corresponding phy is reset.
>
> Fixes: 8dd495d12374 ("arm64: dts: freescale: add support for i.MX8DXL EVK board")
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Fabio Estevam <festevam@gmail.com>
