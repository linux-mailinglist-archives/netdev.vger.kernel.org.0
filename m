Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AA9670D62
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjAQX2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjAQX1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:27:42 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18F4613FC
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 13:28:33 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id t2so15500431vkk.9
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 13:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E+0rx2Q4mLmVz1bsrbMeBWXN6Pif4zx1fuKKBqFas0k=;
        b=UzNDOwFpNv/0XcizbhUKkDbQI/PUeYxuY031vJ7q8ux5ZLGpL7ciQJgQ3v/PRJ8lAR
         yQbuu4OFwdImsbZHuu1lBperhgc+5K+Bk3Q6/hziGsiliLmOGFXSzoL+zi9NJtlTLijq
         tn6nVdY1UToOgONyMuqR0zLMScyvAwDQdlXqraW8sM+05v2mfKu7ZcOB0CsxijM2jMm6
         Sa074s0fBhKkDNuypGsr0/cG+kNKC6qu7XzG80sCZk28n9IX9O3DbQRnQOV2Bum5UOEJ
         4+DFqTAX0T8Pfg9kzY6Rb3VKGggd/fqrGHFcw+oz/hkDIH366RZ4GH0Crn/n3dZ7SiAN
         NFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E+0rx2Q4mLmVz1bsrbMeBWXN6Pif4zx1fuKKBqFas0k=;
        b=0ZRKlCgLwOCcoIvhZqK0XCAUDf15Zi08mmlEPdQdGo3ASUqp4QnL0b3tLjvTivmZt9
         MkmCjYlTwXZW3uFrdDrt8eH1b6OqZFV33jZ6JiUc3fuRtEGrmZUa7s/YsAhEiz/hAITV
         Jh6B+vGQdt7gxEPGCdmnoHSf8Qj1YbQD+Fw2iEQmw+cilT6l9qZ+0E8ZHDGBaGqFHgWY
         V8/uZ83SB+8hEu6Rv9zgqF54Zq3oaFw0kmtGyNlVwJaXAAMveArMDl53rVTIIOkCLnFm
         5GU6mnzHkyiOWX/hpj0CHGrRtQEwOmDsfSieA+V2xUCFwmN4AhzRVm0+m9zFGvyKnh+l
         we7A==
X-Gm-Message-State: AFqh2kor+H7AEvRZEkSf44J4rnG4ZQLAxMLM2WVIv6knEwgVqAlvOBJV
        ZgFjUKUgmZNWdjBewpMTE7yUm7NQUMmo+NPa9TU=
X-Google-Smtp-Source: AMrXdXsmqJlwjdjivx2e/c7XPBJXE0LB1JAS7zL1c/WZ/1RTzkkXuPUsIMcIxMDT8KVHx51EsJU9LTDAeZjLmTzJySk=
X-Received: by 2002:a05:6122:219e:b0:3d5:dcb7:5f88 with SMTP id
 j30-20020a056122219e00b003d5dcb75f88mr636187vkd.37.1673990913017; Tue, 17 Jan
 2023 13:28:33 -0800 (PST)
MIME-Version: 1.0
References: <20230117190141.60795-1-kuba@kernel.org>
In-Reply-To: <20230117190141.60795-1-kuba@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 17 Jan 2023 16:27:56 -0500
Message-ID: <CAF=yD-+xShOJT=hFtMGFoi8soDzoCQ=UdEgg8oDDs2Q6DxqYVA@mail.gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: add networking entries for Willem
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
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

On Tue, Jan 17, 2023 at 3:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> We often have to ping Willem asking for reviews of patches
> because he doesn't get included in the CC list. Add MAINTAINERS
> entries for some of the areas he covers so that ./scripts/ will
> know to add him.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Please LMK if anyone would like to be added to these entries,
> the maintainership is not meant to be exclusive.
> ---

Acked-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>

Thanks. Always happy to help review for these areas for sure.
