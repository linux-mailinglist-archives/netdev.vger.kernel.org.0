Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4773951E81D
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 17:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiEGP0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 11:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiEGP0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 11:26:39 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE9D40931;
        Sat,  7 May 2022 08:22:53 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-edeb6c3642so10197220fac.3;
        Sat, 07 May 2022 08:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vfkw9TEuSvE0rf7NTGZm+jRNPS+m8UM4jfYleJJzY2I=;
        b=dRlALCBUBhDl/OKieHfQ0pxKgiE//oTxnop6TQW/2Knb7IFGzmmuUr1z3ECWTtCpma
         5ssjJTIA6VRImBoooABtpArDV6lfuD9DSxJhMc/zTNXaOEa3nj+BYhpUWUYQX6qD/3sk
         8ObaH6I+AqVpEWTO0kN8kP/XznM+DYAWXSHY9JFbmlu4Sx0TKHSvhi9Mu7HscePgHit/
         Ak3vDyMcFCU8x1nKKZkuVa5JM/5HcgWlJTn0C+S+rQs3B+QD83K4tct3q/1gDmvRyINr
         44FfQENIw2dhX96Rry4crw5NkHdnlx0LwOq6bQ7uDscvXQ/mMAt9wvvaBAK1iVqXQ6xN
         nfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vfkw9TEuSvE0rf7NTGZm+jRNPS+m8UM4jfYleJJzY2I=;
        b=O0kuH/qnihh3kSVDIt1ePrbb61PW+o88Ci025e6p6q24ybL8RtaJCc8VODAnKB5g1J
         BFRM94bf9KPvnTR1EhNvRhQxuWw3DXP6EEd5uh5nkpWMiVyiqh6dbqgGQaKF3elLcqE4
         cPUECQ1GIjZLah8bWaz3eMR467Wj9cXSelDUZCGc/4K4O3IG7SBHH/AxtxvaiBQF7n1d
         NOMNXkZwxMB648HB1ANiWg3JOa2XyLxDrNV++L9ppyB3Nwu0uqC/5zGXeBFgvkpvwur3
         QAdRsjRY3pJ72crRWptGNdPCR7jzN/jK1ST/uLfHrQzZ6vcciviTN30DkBdpikUEZr27
         KWVw==
X-Gm-Message-State: AOAM532XZAHIqUxMu06I0LqmAnx43/D+dl6seEhfHFJpbJAGVB/+t+Xr
        ZLX0nggkAVg/TcFieDLISALluBkGBYowpz2DRJtQnrE2nRs=
X-Google-Smtp-Source: ABdhPJxN44GTIfHBqhAYQNw6XCdxxwdvLIfkCjI7H44OLjM4nUg1Ig0fVDO7rYsX7ryRVRTzuISlkttqM5CIs1oZ6ZA=
X-Received: by 2002:a05:6870:60a6:b0:e1:937f:22e8 with SMTP id
 t38-20020a05687060a600b000e1937f22e8mr6687750oae.183.1651936972570; Sat, 07
 May 2022 08:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <CANL0fFQRBZiVcEM0OOxkLqiAKf=rFssGetrwN6vWj5SsxX__mA@mail.gmail.com>
 <20220505082256.72c9ee43@hermes.local> <CANL0fFSmqR4F=9bFgVRaKXyCDocwwhxySUBo5x=12900fhWn6A@mail.gmail.com>
In-Reply-To: <CANL0fFSmqR4F=9bFgVRaKXyCDocwwhxySUBo5x=12900fhWn6A@mail.gmail.com>
From:   Gonsolo <gonsolo@gmail.com>
Date:   Sat, 7 May 2022 17:22:41 +0200
Message-ID: <CANL0fFTkj=vOGOgHqPxoQ5srC+f_0v6Trwjs03-6UdMYVn6ytA@mail.gmail.com>
Subject: Re: Suspend/resume error with AWUS036ACM
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Going through the source it seems that the concerned field is
is_valid_ack_signal which is never set by mt76, only by ath10k.
