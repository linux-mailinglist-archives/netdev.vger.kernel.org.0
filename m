Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8989EA5E10
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 01:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfIBXVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 19:21:36 -0400
Received: from mx3.ucr.edu ([138.23.248.64]:29251 "EHLO mx3.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbfIBXVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 19:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1567466496; x=1599002496;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:cc;
  bh=2tF0euXR3VYfwevVZ1jCeatrtkAWORyVRWQSZY/zVZs=;
  b=fFDtwZha9ea9qra9b+6sRP15xg2qPaQF7Bv6DzFGAXNi72oucvD9h1Bf
   LtXk2C4irwN5AHyG/UZsNYcFVC8trVHlE4FDaPBsNLdSHw0SWcrRhVABP
   Mxidea39aFsbIgzSsDJY9smpf7gt6HlmTtwX86wz4St+D1Vw/M7pAztj/
   sgbrwrxcLWOEmdltpEyniT1s8b5a0sAVsXJzpsFFG84P6Lkh/4xDjCIUY
   S6YR3r2VMQERKc9sSHWoyaSDU9JNZqgTuS70iEz1WQv33/LHgv6X2MilL
   BVwx4J5n7ucuk9yj+lLWBlIJPT2hqsoDHeqYFwvNmqmfc66WRXJvMVN+x
   A==;
IronPort-SDR: R3Rr03bUUz8T6bq+bEU+713X6KYQOGKYYnJjLywgF7QFSupjwZ0ECksD/cUvHIAASSv7aIeTxn
 QgmEfROr35zXaaMP3RGAytuwHNTV6CKCAZ2Awdh7XrY7eq5MLZAhYWicZX7Bm50TzhkLg6fWYv
 o/Lv3/O2NC7IUR/K7yl9eymbCEOjSYL4i/ckntPPdS++X3ztnRrde4I9b9xcbAtE74VEoGDeuR
 ti8hvcWIcAb5bj9JTtiz3BY8q/4TbyRJAIdWYzZFhll7+fNTRKDGTu+pTQtnrC6BKKLLkrN/bl
 t+s=
IronPort-PHdr: =?us-ascii?q?9a23=3AjJA94R2NPxiQFU8VsmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8Zse0RKfad9pjvdHbS+e9qxAeQG9mCsbQd1LOd6fiocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmSSxbalvIBi0sAndudcajZd/Iast1x?=
 =?us-ascii?q?XFpWdFdf5Lzm1yP1KTmBj85sa0/JF99ilbpuws+c1dX6jkZqo0VbNXAigoPG?=
 =?us-ascii?q?Az/83rqALMTRCT6XsGU2UZiQRHDg7Y5xznRJjxsy/6tu1g2CmGOMD9UL45VS?=
 =?us-ascii?q?i+46ptVRTlkzkMOSIn/27Li8xwlKNbrwynpxxj2I7ffYWZOONjcq/BYd8WQG?=
 =?us-ascii?q?xMXsNQVyxaGYO8bo0PD+UcNuhGtof2ulUOrRqgCgmoGezk1ztEi3Hq0aE/1e?=
 =?us-ascii?q?kqDAPI0xE6H98Wv3vUotf6OqccX+620afH0S7Ob+9K1Trn9ITEbgwtrPOKUL?=
 =?us-ascii?q?ltccTR004vFwbdg1qSqIzkPjOV1vkKs2OG7OVgVfigi286oAx2ojmux8cshZ?=
 =?us-ascii?q?PIho4J1lzJ+z50wJspKt2iUkJ0f8OrEIZJuiycKoB4QdsiTnl2tComzrAKo5?=
 =?us-ascii?q?22cSgQxJg52xLSaOaLf5WM7x/gUuuaPC12i2h/eL2lgha/6U2gyurhWcaqyF?=
 =?us-ascii?q?tKtS9FksXUtnAKyhzT9tCLSvtj8Uel3jaCzwXT5ftFIUAwjKbbL5whzqMpmp?=
 =?us-ascii?q?odrEjOGiz7lF/5jK+RcUUk9eyo5Pr9brr6oZ+cMpd4igD4MqswhsyyGfo0Ph?=
 =?us-ascii?q?QKUmSB+umx1Kfv8VPlTLhJlPE6j63UvZPCKcQevKG5AgtV0og56xa4CjeryN?=
 =?us-ascii?q?QZnHgHLF1feRKLk5TlNl/VLfDlEfi/mU6gnyl2yPDbJrHhGInCLmDfkLf9er?=
 =?us-ascii?q?Zw80hcxxQvzd9C+Z1UFKoMIOz8WkDvrtzUFBw5PBKuw+bhFtp90pkSWWWVAq?=
 =?us-ascii?q?+WY+v8q1iNs9MuMemRY8cnuD/8Y6w09f7njCdhwncAdrPv0JcKPiPrVs96Kl?=
 =?us-ascii?q?mUNCK/yuwKFn0H609hFOE=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FaAAAyo21dgMbQVdFlHgEGBwaBVQc?=
 =?us-ascii?q?LAYNWMxoQhCGPDIIPiWqBCYV6gwmFJIF7AQgBAQEOLwEBhD8CI4JKIzYHDgI?=
 =?us-ascii?q?DCAEBBQEBAQEBBgQBAQIQAQEJDQkIJ4VDgjopgmAJAQEBAxIRBFIQCwsNAgI?=
 =?us-ascii?q?fBwICIhIBBQEcGSI5gkiCCp1qgQM8iyR/M4hmAQgMgUkSeiiLeIIXhCM+hA2?=
 =?us-ascii?q?DQhSCRASBLgEBAY1EhxaWDQEGAoINFIwviCwbgjOHNoQdimAtpisPIYE2CoI?=
 =?us-ascii?q?AMxolfwZnCoFEgnqOLSMwjRuCVAE?=
X-IPAS-Result: =?us-ascii?q?A2FaAAAyo21dgMbQVdFlHgEGBwaBVQcLAYNWMxoQhCGPD?=
 =?us-ascii?q?IIPiWqBCYV6gwmFJIF7AQgBAQEOLwEBhD8CI4JKIzYHDgIDCAEBBQEBAQEBB?=
 =?us-ascii?q?gQBAQIQAQEJDQkIJ4VDgjopgmAJAQEBAxIRBFIQCwsNAgIfBwICIhIBBQEcG?=
 =?us-ascii?q?SI5gkiCCp1qgQM8iyR/M4hmAQgMgUkSeiiLeIIXhCM+hA2DQhSCRASBLgEBA?=
 =?us-ascii?q?Y1EhxaWDQEGAoINFIwviCwbgjOHNoQdimAtpisPIYE2CoIAMxolfwZnCoFEg?=
 =?us-ascii?q?nqOLSMwjRuCVAE?=
X-IronPort-AV: E=Sophos;i="5.64,461,1559545200"; 
   d="scan'208";a="78457826"
Received: from mail-lj1-f198.google.com ([209.85.208.198])
  by smtp3.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2019 16:21:35 -0700
Received: by mail-lj1-f198.google.com with SMTP id 17so2231066ljc.20
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 16:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=11S+72wXCThjYHgY/hYu0pdk4ZjzkGTY7Jm1Oqj+h6Y=;
        b=PnYLzMajSKo2XPqFj5PM6w3ABLE2hTIh34zxm+mMC/hqQuXLJ8dazCiQeftbgJ2dP+
         ConVS/oAYBXpik1iyh2TbJNmkzyv3H/q30RUWdr+uJvm/K9azSp5bV3rHSiqotQcniFI
         zE/i1IvBND7B3JbrtdTBoStvRdPnd1u8nI+cQfendBO6nxfEGV92DHlr18EO3w56uEVa
         GaVEHdAATc7lN32ak6+lE6Omgv1tPnTxlx8wJzD3Yb3ZH36bnIVUeCMsrkII4zjw4SSQ
         eyMlP9Y+6gK2/Q7flfp47L4RA7l7x7qogD6xp3AS1YlpQ1whxUXA/pekU4F9gOMMzRy3
         xPAg==
X-Gm-Message-State: APjAAAVJm8dIvzVAF/QcJ5JMbs8O3p/OyI0dj0eyvtovTU5xi4Xnls44
        /Wyzsj6VLaSCZhZccwCsZRnTQG1jKsGWPoBeWCj3CiI3RHSqclCB81mxuwcv9aXg1jbgZbXY0H3
        nkxNys0eTA2XN9AvmTu0rEXkdBPjhjRgMeQ==
X-Google-Smtp-Source: APXvYqzagtcGa1G7dj7735BrefQ3wcMVlPJ8FZ55wNvzN2oHUyfNO0V8vrqkWiUgf7ZKhp7WQBwj/zDGMzNqzlDdptU=
X-Received: by 2002:a2e:8806:: with SMTP id x6mr17626931ljh.190.1567466493336;
        Mon, 02 Sep 2019 16:21:33 -0700 (PDT)
X-Received: by 2002:a2e:8806:: with SMTP id x6mt12995385ljh.190.1567466493181;
 Mon, 02 Sep 2019 16:21:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190902231510.21374-1-yzhai003@ucr.edu>
In-Reply-To: <20190902231510.21374-1-yzhai003@ucr.edu>
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Mon, 2 Sep 2019 16:22:03 -0700
Message-ID: <CABvMjLSeQjMi0DPLGH3qnoLNb=gc+P_4ZF7OQQMHa6uRMD42Dg@mail.gmail.com>
Subject: Re: [PATCH] net: hisilicon: Variable "reg_value" in function
 mdio_sc_cfg_reg_write() could be uninitialized
Cc:     Chengyu Song <csong@cs.ucr.edu>, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the inconvenience. I made some mistake here, please ignore
this patch and I will submit a new one.

On Mon, Sep 2, 2019 at 4:14 PM Yizhuo <yzhai003@ucr.edu> wrote:
>
> In function mdio_sc_cfg_reg_write(), variable reg_value could be
> uninitialized if regmap_read() fails. However, this variable is
> used later in the if statement, which is potentially unsafe.
>
> Signed-off-by: Yizhuo <yzhai003@ucr.edu>
> ---
>  drivers/net/ethernet/hisilicon/hns_mdio.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
> index 3e863a71c513..f5b64cb2d0f6 100644
> --- a/drivers/net/ethernet/hisilicon/hns_mdio.c
> +++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
> @@ -148,11 +148,17 @@ static int mdio_sc_cfg_reg_write(struct hns_mdio_device *mdio_dev,
>  {
>         u32 time_cnt;
>         u32 reg_value;
> +       int ret;
>
>         regmap_write(mdio_dev->subctrl_vbase, cfg_reg, set_val);
>
>         for (time_cnt = MDIO_TIMEOUT; time_cnt; time_cnt--) {
> -               regmap_read(mdio_dev->subctrl_vbase, st_reg, &reg_value);
> +               ret = regmap_read(mdio_dev->subctrl_vbase, st_reg, &reg_value);
> +               if (ret) {
> +                       dev_err(mdio_dev->regmap->dev, "Fail to read from the register\n");
> +                       return ret;
> +               }
> +
>                 reg_value &= st_msk;
>                 if ((!!check_st) == (!!reg_value))
>                         break;
> --
> 2.17.1
>


-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
