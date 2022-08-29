Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A80D5A4C49
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiH2Msz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiH2Msj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:48:39 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813FFB775E
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:34:32 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by gnuweeb.org (Postfix) with ESMTPSA id E8BEB80B4F
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 12:34:31 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661776471;
        bh=N1uDE91BqGxI7oqT6ZPOAuib3sKIAcIKvPFQNbnaYxM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cj/5EiuksvAtUjyMmn4aZqVyxlpZLPb6ng2YG/1uTnVbncK+3A4+nBH7Zdxp6AN5e
         fL60A9jw7nXZL15bBIUt68u1X0B2cx4R1ovBIZ2Zn1TWoEhwOi5O2nQQ8u1Ot6qy0O
         Q5a/frtZArUHr25DgYlJb+JTWMaCJEGl0BeaEiduIcRnIfNsqVuHjw8RKXPqhx4Z6V
         xzxa19ddlFflfNKt6ZmTpLauuMwUoo8+/4jB6wYkyuji3YM5av/lBft4vdFRsUJm3B
         AjZoLQ8mlcWCiII6XeQd/5ypJsQW5T045sDlZyYj19OXvFp19d6hp8oS1ViKUd+jvy
         1gCK2ThuHzyQA==
Received: by mail-lf1-f46.google.com with SMTP id v26so694166lfd.10
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:34:31 -0700 (PDT)
X-Gm-Message-State: ACgBeo2TJIG0Bxbtyw5V+DjxFMPld1M0STNzPHnM8dmsOSRmzRVaJPtZ
        a7J7zVANjkuWkCYOEaAJGJCyGIZZ8e10TKhs/62w6w==
X-Google-Smtp-Source: AA6agR5GbTehGGG7rAld1ZY9g1RxolXE4vO8PFMy3NVNbJcN02f2heEEbGWkSswl8x7LF06IOKxexLhBjrUnAxndPJM=
X-Received: by 2002:a05:6512:12c2:b0:492:dc0c:f4ac with SMTP id
 p2-20020a05651212c200b00492dc0cf4acmr6997012lfg.612.1661776469902; Mon, 29
 Aug 2022 05:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220829111643.266866-1-cui.jinpeng2@zte.com.cn>
In-Reply-To: <20220829111643.266866-1-cui.jinpeng2@zte.com.cn>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Mon, 29 Aug 2022 19:34:18 +0700
X-Gmail-Original-Message-ID: <CAGzmLMW-D8cGbZruQ=Vy7Yu8j5nCqGvNC8mMw-XeNjHr62Mf6g@mail.gmail.com>
Message-ID: <CAGzmLMW-D8cGbZruQ=Vy7Yu8j5nCqGvNC8mMw-XeNjHr62Mf6g@mail.gmail.com>
Subject: Re: [PATCH linux-next] wifi: cfg80211: remove redundant ret variable
To:     cgel.zte@gmail.com
Cc:     ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        kvalo@kernel.org, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 6:35 PM <cgel.zte@gmail.com> wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
>
> Return value from cfg80211_rx_mgmt() directly instead of
> taking this in another redundant variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
