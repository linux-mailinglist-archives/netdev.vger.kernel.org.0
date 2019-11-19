Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0686D10122C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfKSD16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:27:58 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40760 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbfKSD16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:27:58 -0500
Received: by mail-qt1-f193.google.com with SMTP id o49so22979943qta.7
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 19:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVMWJPHKS5b0D789uPoJ9Xa2YJCvazHd/Qt98OC2/JU=;
        b=CRuTq0JewoxfdZz8Y99vLaSYTr45Ta2V/UgojmbgS8Sz5pLVEmMxUzdrSgIZsoJdB4
         BoffGkoPm+0W+nPVjU8vUgs50MU5MwZ4PR4So/wWzbMA7GEs1CkhHACtPWy6+mxkUyfp
         ekLnQCZ8QmjUBC2S/+nwih9Tp7FmERUaPF9YFNdyds+YxwPBa6qNVk5Xq0Qc4S+owyoP
         OEnb+0khYEAr7islGtx0nH5NwG7R4wk9ke+NMql1pTomaS4BWEMjHT6D3nNHPB9ipCC9
         axJR2mwMpzlOxn+5bLScKoX2yu6kixxIOS/qxPCZr6P/QyskTql4jguBQLPSjSS3nEJW
         Z7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVMWJPHKS5b0D789uPoJ9Xa2YJCvazHd/Qt98OC2/JU=;
        b=qgMJ7JHOAq98J7VXHYmJLCCueoQ3Cg4HusZSPaBH32XbY46eqz0Ixtvxf4/sk1vknV
         ySdkwJjcW6OSkAAg90YHzEeKxxH+4xK8WAmSHQWo8sSWpVuMGXpBcg1eY2tZjE6AcgyN
         IY0xuU8fYYVfCGRwv8I+Y9+BOb4yzTcO1lwOKLerCArmecW3zz61WaBYrYSE5Raftn3W
         cPwz6A6NwUzO5qa1lrKQcp1epoAKfsoxK8F6wqCcFqVhtbtbntT/fTD+C4109vg0lZT3
         gkCp01y0k4BfUQoXOG16Yrn0nq6Q7Kg9YwSIbtSBdbtVxcFrOF3QuUW8MBylBphEvja/
         zs+g==
X-Gm-Message-State: APjAAAVRykka6uf9i1uaOnOUfNhI9dE/v7LaSXbe0jcxNJJn1tj3Gg/2
        1xNJs22kFiydaRNryOTnO+dLbCfRacW3YMDZIxe7ug==
X-Google-Smtp-Source: APXvYqw5qE3tSdNUDhpR0IKDiQkN4t6llCwNKpHqlCQYmtBfEyv17dlcknaQgjDTgE//xnUWJZf+Q9RVKDisBNM1XBE=
X-Received: by 2002:ac8:721a:: with SMTP id a26mr30490320qtp.208.1574134075348;
 Mon, 18 Nov 2019 19:27:55 -0800 (PST)
MIME-Version: 1.0
References: <1574130314-25626-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1574130314-25626-1-git-send-email-zhengbin13@huawei.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Tue, 19 Nov 2019 11:27:43 +0800
Message-ID: <CAB4CAwcwxTPB_VAJyXxWnrcQbDOqxHdJcriSjCU6odgw2ng1Vg@mail.gmail.com>
Subject: Re: [PATCH -next v2] rtl8xxxu: Remove set but not used variable 'vif','dev','len'
To:     zhengbin <zhengbin13@huawei.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 10:18 AM zhengbin <zhengbin13@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5396:24: warning: variable vif set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5397:17: warning: variable dev set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5400:6: warning: variable len set but not used [-Wunused-but-set-variable]
>
> They are introduced by commit e542e66b7c2e ("rtl8xxxu:
> add bluetooth co-existence support for single antenna"), but never used,
> so remove them.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
> v1->v2: modify comment, it --> they
Reviewed-by: Chris Chiu <chiu@endlessm.com>

>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 1d94cab..aa2bb2a 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -5393,18 +5393,13 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
>  {
>         struct rtl8xxxu_priv *priv;
>         struct rtl8723bu_c2h *c2h;
> -       struct ieee80211_vif *vif;
> -       struct device *dev;
>         struct sk_buff *skb = NULL;
>         unsigned long flags;
> -       int len;
>         u8 bt_info = 0;
>         struct rtl8xxxu_btcoex *btcoex;
>
>         priv = container_of(work, struct rtl8xxxu_priv, c2hcmd_work);
> -       vif = priv->vif;
>         btcoex = &priv->bt_coex;
> -       dev = &priv->udev->dev;
>
>         if (priv->rf_paths > 1)
>                 goto out;
> @@ -5415,7 +5410,6 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
>                 spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);
>
>                 c2h = (struct rtl8723bu_c2h *)skb->data;
> -               len = skb->len - 2;
>
>                 switch (c2h->id) {
>                 case C2H_8723B_BT_INFO:
> --
> 2.7.4
>

Those variables are handled by the derived helper functions
rtl8723bu_handle_bt_xxx and no longer needed in
rtl8xxxu_c2hcmd_callback(). Thanks for reporting.

Chris
