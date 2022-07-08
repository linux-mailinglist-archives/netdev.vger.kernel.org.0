Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3A956B2A5
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbiGHGUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiGHGUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:20:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF66DF22;
        Thu,  7 Jul 2022 23:20:10 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z12so19531314wrq.7;
        Thu, 07 Jul 2022 23:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=9Bsq/YmtbEZM9i+J5Birgxi0LPEuTIPjjX9AQ+l9/Uk=;
        b=mzxDlJxTvduCAqcawUvsYB3Va6o+RuuHMZNjWpVm3dHN29bAH0oF4nyhzAernxjwoN
         B6FE8doN6yDwVDfQFWswhIsQpRolMrTeoMlaSRUC28pYXfKDvtx7Xi67/fOLEKPSaLEN
         g6lPR8oc9I9BrK2hqrVW/Znw9dV6dIzzKaVRnuUnFbg5zXlNNFUPty4bIvaJEZU5PZ/2
         fWEIykNzGR2u5NrZNj4rNcCsdindGVfB4Tbu9zzrQ6ZvsXuN7apDUVFNYpQx7ylw/l7O
         gmbiaaIpZGB3jdSaY9X9w7cV7XY+IJZhv7A+PlkDTynzANlx7D5gRST4euQJAjQ60Ow9
         H+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9Bsq/YmtbEZM9i+J5Birgxi0LPEuTIPjjX9AQ+l9/Uk=;
        b=iXvr/ME30azaIIwMIO7jCvQWVZVVhfNzHz+rX0iKXDdZvL32ZqgSDn5tErk0jzVXb9
         DFMLmcI4/BbSGpS7RzbcTA7X7BIyQqcrZl8bcSn4/UuxWkLSWVKYQCYBTyeIgx6lzyVw
         k/9HLlWGCngCqQmUZ73zgKq8HeKfIqlJuK0TPSjEI/ai2h7NqeXAAo++Y31frZ4MhH7t
         sCb7u+BeBs9DGYfAl7zNiSbP3Gf7krlotNSDHuydr+dLGDDkUzAVdb7wP+Yf4KEZnimH
         TxbBKEMGBIN7h3Kj1TWATPZ29p+HXRtdsub7HAgLNyS2SlGkhsgjwgqgHldLbriiFis4
         mWiw==
X-Gm-Message-State: AJIora+2vDKhn2ii7/3PEvFD+OA5t/TcsxG0Do35HNQlM7d66TG0OO38
        X7Ve2LLS6LtMpnQEk0jBul9GVDUiqrSXQ38faCbj6sxfPmU=
X-Google-Smtp-Source: AGRyM1vH26E4eemAuIrea9Ip7WJMjldZTGQB4HOHHdWGu+Ld7wjMehv2wpERxFK9jtnOHaK39mcMQ2Vld4xD35n8XIU=
X-Received: by 2002:adf:d1ca:0:b0:21b:a81c:47f3 with SMTP id
 b10-20020adfd1ca000000b0021ba81c47f3mr1658266wrd.22.1657261208890; Thu, 07
 Jul 2022 23:20:08 -0700 (PDT)
MIME-Version: 1.0
From:   Srivats P <pstavirs@gmail.com>
Date:   Fri, 8 Jul 2022 11:49:31 +0530
Message-ID: <CANzUK5_qwaRm=9c46yH8d_J54PAcNhZB-R5M=wYgXGGaJJaFAA@mail.gmail.com>
Subject: netdev stats for AF_XDP traffic
To:     Xdp <xdp-newbies@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
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

Hi,

Is there any update on the "consistency for XDP statistics" [1]
high-prio work item from the xdp-project.net project management page?

More specifically the fact that the mlx driver (are there others too?)
don't update netdev/ifconfig stats for XDP/AF_XDP traffic? The email
thread started for that item dates from 2018 and hasn't seen any
updates after that.

I see some recent patch/commit activity about XDP specific stats via
netlink but I believe this is different from the standard
netdev/ifconfig stats.

Srivats

[1] https://xdp-project.net/#Consistency-for-statistics-with-XDP
