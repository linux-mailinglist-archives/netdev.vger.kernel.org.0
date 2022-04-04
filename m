Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EF24F1B0D
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241103AbiDDVTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379141AbiDDQh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:37:26 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A02E094
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 09:35:30 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p21so11974093ioj.4
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 09:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u2tjCgL5q60NGSsrT51lKaR05T0paQW81C5vQQ853wY=;
        b=LU/LuEgYuinqEj95G4H6JtZIbQpHE6Wkox3vsqOb7m7lngKeo8ezZjUZB4v+fMzrXu
         i7Mox9Hha2YBG2+eHgJc2l9JEC4zF8ZM6xXEbdc37VoB58K8gfNWoq8c3Odp3BA/21Wj
         8xx8CnXdvah5jZ4gGbPfynV1of+K7wveZu6ohsinc1J4F7G1fu9EQEwU4GwH50u0dX/R
         tIVVPOC3JjPkru7Ee/eKnl5+bJQJ3/AshfySEgepXYEt9Ba7CQGsGL2IeBF9/KuX9IrP
         JbX5rZg2SYWlWHW9g+t4sfQ+vuvn6EP/KTcrv8ic5QexGre+YCX3K/iPVS+gp28DNVr7
         JX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u2tjCgL5q60NGSsrT51lKaR05T0paQW81C5vQQ853wY=;
        b=perYHRM6anJxoUVDJ8b/zeRK2x2+W7M2+COvcD8xVxLYFxtXoJXbOAcNZbKS0OoCeh
         2M4LP5UrxknqmMEPhQVy45xFNvyHscOilTbLg/xwNQjAlNp06509LayPVj6ObvotkLei
         51r9RxSFSirkN7YHRQIYSkb6Lg48Ici1P7U5gVSwEGJC3Lv0O5KvIzJrZ3eWPD2mhSBo
         +z4f6qrtMNwq3COqkc282z52If3dZtPQ/cqZXr8z7cltsrV9zlzuRtEbAlzojW1xHRU/
         zVRhNTSgY7MbDSXdGApC8es8qPheVTZ+/ZrcLBo63fjnlZVrf9goOBPh0hTspTNc3sOD
         2AXA==
X-Gm-Message-State: AOAM531eY6pmft/0asuC9XDY/1flqOc0HkN1IueKvvzEBDJk8GUIYLFt
        B1UKgF3nUZM2Wzhd1MEGlwbQKdNOt9dCNKu/W7M8bA==
X-Google-Smtp-Source: ABdhPJxGPGo6ZeYMtrmrzTqcFfxOkAJo2j1ZjwZE5kyqJVyLQGVWZDw37xIK3ZrpEfi7IjV6VOZwuUlNmhvG7sZ1KNI=
X-Received: by 2002:a05:6602:15d1:b0:649:1ed6:edcf with SMTP id
 f17-20020a05660215d100b006491ed6edcfmr506912iow.74.1649090129391; Mon, 04 Apr
 2022 09:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220404105324.13810-1-straube.linux@gmail.com>
In-Reply-To: <20220404105324.13810-1-straube.linux@gmail.com>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Mon, 4 Apr 2022 18:35:18 +0200
Message-ID: <CA+HBbNHEK=CbyeeyPG=s=D2xofdSbk8Lxx5R9nij_cp6t7ybDA@mail.gmail.com>
Subject: Re: [PATCH] ath11k: do not return random value
To:     Michael Straube <straube.linux@gmail.com>
Cc:     kvalo@kernel.org, David Miller <davem@davemloft.net>,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 4, 2022 at 12:54 PM Michael Straube <straube.linux@gmail.com> wrote:
>
> Function ath11k_qmi_assign_target_mem_chunk() returns a random value
> if of_parse_phandle() fails because the return variable ret is not
> initialized before calling of_parse_phandle(). Return -EINVAL to avoid
> possibly returning 0, which would be wrong here.
>
> Issue found by smatch.
>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> ---
>  drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
> index 65d3c6ba35ae..81b2304b1fde 100644
> --- a/drivers/net/wireless/ath/ath11k/qmi.c
> +++ b/drivers/net/wireless/ath/ath11k/qmi.c
> @@ -1932,7 +1932,7 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
>                         if (!hremote_node) {
>                                 ath11k_dbg(ab, ATH11K_DBG_QMI,
>                                            "qmi fail to get hremote_node\n");
> -                               return ret;
> +                               return -EINVAL;
>                         }
>
>                         ret = of_address_to_resource(hremote_node, 0, &res);
> --
> 2.35.1

Hi Michael,
This is already solved in ath-next and 5.18-rc1:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/ath/ath11k/qmi.c?h=v5.18-rc1&id=c9b41832dc080fa59bad597de94865b3ea2d5bab

Regards,
Robert
>
>
> --
> ath11k mailing list
> ath11k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath11k



-- 
Robert Marko
Staff Embedded Linux Engineer
Sartura Ltd.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
