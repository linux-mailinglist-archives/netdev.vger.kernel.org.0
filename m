Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5806821FD
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbjAaCWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjAaCWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:22:06 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20533401A
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 18:22:04 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id p26so26390129ejx.13
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 18:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SJlOo//NnyQRtXCAg7oRYYTwGMe/Y0tVPk/IwjimmSA=;
        b=Q8Xl3JFiCnghwz/mY4qoC7dOM4H0NZM7oxBiqsrrjuTdoiFa0B4Vn9W/bHVw3pkgUx
         GeCI31BYpx8euLV5CsD6CI7RQPqPYDnbxzNP0SyX8MsINzdam/bVdbZSNmU6A26HR2mx
         YkgYUQxLatXtJULhBhVdVDoYZ5bPTKVHvGLU/mhjdtm7JBsx4z4JM3fd3/aeZfiMbAlN
         dRgq4nHCnEjcI2XJeLfckP3hIxjvOfoZ/0kdE+OLWopRu44Sa1slidKpP8SbeMkSedu/
         z01STutxSvUIRX1eqxt1W38pQ6BtFZsaWqFQzgKbpq8zAxniZSVv8jASgKId+AZxXJfh
         51Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SJlOo//NnyQRtXCAg7oRYYTwGMe/Y0tVPk/IwjimmSA=;
        b=WDfijkC8kXfNNcElEq3NdUqrYm8iOov8ljohYx0UUosG31ChJf52Z8SqSY+ngXY7FL
         nIBoweTdYA+M9J5Lfb2jl7MEbPSertlShxtpgRtWA0zBpdeyH8woRynJvRlZ8/qJiu8+
         6xXHrQ1+7ShA5x1/t+zcvWcofhUo8ibrGltzWL4XfP8xtj3y0ukdR+hGxFRoGGtJTo+N
         IaGWDw3eglIH+EiILyeLysWV0vsy2NHUYXXkm/NEczm/3Gaq7nHk4vw3FsDQZ+hd16Fd
         BNhg7tfKo9a8GDU8GnVJCWiux4l6ACV6kY6ZVVIb14NsUaR1eszhBDR/MzvusoQSRYrX
         X5RA==
X-Gm-Message-State: AO0yUKUVG4dL6n6JuLpzWIcZD/AzBLz57UAPQwjl1qwamPW/tlkPT3mH
        rXa8ShslSjT05abOevck7zBDrEgPqe9oFvpFqkxUKA==
X-Google-Smtp-Source: AK7set8X/VWcBLz8Gkx/q+RO26aEHLZ9YC1cRzWZB8juJMU+rW+4PVZg7TOlZRqXNNg62oogE2gKcDvk7wQ7KnrXyVM=
X-Received: by 2002:a17:906:289b:b0:87a:574a:617d with SMTP id
 o27-20020a170906289b00b0087a574a617dmr3714217ejd.155.1675131723446; Mon, 30
 Jan 2023 18:22:03 -0800 (PST)
MIME-Version: 1.0
References: <20230129215136.5557-1-steev@kali.org> <20230129215136.5557-2-steev@kali.org>
 <20230130222337.GA3628858-robh@kernel.org>
In-Reply-To: <20230130222337.GA3628858-robh@kernel.org>
From:   Steev Klimaszewski <steev@kali.org>
Date:   Mon, 30 Jan 2023 20:21:52 -0600
Message-ID: <CAKXuJqhYZ7bLeWq1N_zabOaN2UamhhNu6g-vmtO9ShDA9Z8=JQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: net: Add WCN6855 Bluetooth bindings
To:     Rob Herring <robh@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Mon, Jan 30, 2023 at 4:23 PM Rob Herring <robh@kernel.org> wrote:
>
> Proper threading is all patches are reply to cover letter.
>
> Drop the last 'binding' in the subject. Don't need it twice.

Sorry, I'm not sure what happened with my threading here, I changed
chainreplyto=true to false in my .gitconfig so hopefully v2 will come
correctly.
