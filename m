Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9126526E3C5
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgIQSfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIQSey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:34:54 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B435AC06174A;
        Thu, 17 Sep 2020 11:34:53 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x18so825782ila.7;
        Thu, 17 Sep 2020 11:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zPDJUdvQHs4KWTgjCiT5lhv4aKDrK9sKrsn6icmW7p8=;
        b=a0N9D87u2X4EnPeQQo7ru8V5gotXYwKueZm2yQVWTfJ/ILuBMzGHZLcMgqL6dfkTy4
         FfzeoVNrZ4Id+9dpctvo9RB8GTQYx+sg7cjYuRLqUeEBofggJBS4lL86gpEoK7UorIbg
         g5sGLJffNN+Hmgj95LsyWSeYhss0D9t2zQ9Pt52E05X/p17kt34EmfMVpK6QQgDjZrwm
         Gnn5Dp5FryCJcDkyfethCZ8uX0OISIxgcAt2F2z47jMHzaF6MtCGE+TUvEfVW8LQco+n
         jMuL+x3yltTkkxUCPvC7No5xCX03ZDQGB2vX4zfpGi6Itt+n0ElLejfytcC0g7AboESx
         RVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zPDJUdvQHs4KWTgjCiT5lhv4aKDrK9sKrsn6icmW7p8=;
        b=PdCEIciPJkqcBVLvfpUVvfUpebQEfyELboHFSToxisGINZb2IdoizekqOrktI4pbl3
         ZOMj6+g8CRHzb7dQaWNNwGRgMzDAhBMQZn2yS+ddoRVrzxZh0dGVJlEMULf2mMHGX11Q
         7ecSh3nwV1Kk41/UbrJi++aQQ/gQ+zcsEeqJdFT0itJf+JYYtLuPgONELIV5O7Gx28KA
         jsCtQEojsS6Biq0phmT2mAtUP/hZSz1NTVVoX2dsOdnLMMmZbrA11XvjoZYAcAhNIqiG
         hCydyG358pG5dvH9rIYBEvQCkhSbN5YJer+MVO1w01DD8c0ZT+BkHdhz80YC0tDYKV0/
         3etw==
X-Gm-Message-State: AOAM533WuA2VGAwSVPHfaEs4yx/ZjX/7LIbL6P1ELyr6z+p/pqf2FWxF
        4dq/8CsMFUuTFBqo+V1Bhdq3cKyDszzNOuJWxUqEIXGP0e8r+w==
X-Google-Smtp-Source: ABdhPJxeZ+BrcQVhnruM0cnEHb/19pTKp7ffx/UzdnW5n6aWwmZu5swtR7N9kj5V9MjWlzGJx+W5NBsYlqfoA+rcaVA=
X-Received: by 2002:a92:5a48:: with SMTP id o69mr23266047ilb.268.1600367692957;
 Thu, 17 Sep 2020 11:34:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200916141728.34796-1-yuehaibing@huawei.com>
In-Reply-To: <20200916141728.34796-1-yuehaibing@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 17 Sep 2020 11:34:41 -0700
Message-ID: <CAM_iQpUgZo+xz8+iwma6FxLdoxXvdtq_tZc1aMipfqHEU3x6qA@mail.gmail.com>
Subject: Re: [PATCH net-next] genetlink: Remove unused function genl_err_attr()
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 9:33 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> It is never used, so can remove it.

This is a bit confusing, it was actually used before, see commit
ab0d76f6823cc3a4e2.
