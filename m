Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552644D6B03
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiCKXqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 18:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiCKXqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 18:46:44 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206C6B862
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 15:45:40 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k29-20020a05600c1c9d00b003817fdc0f00so6203640wms.4
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 15:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=q38oEdOQixC6SomV8pHildgIaIsnOalYl2ymfk7GiP8=;
        b=qDGZg2M+7h9tf0NaBxqZlSf7uFqssEzkLvgfeUcQ6GsOZq+Ckg1Lq7WcW6JCCkN03l
         5BoxWMRUu0NXiz3iTJ20L03FD5ROmTagxXqKAJYn7IDo2riqMqg1DWUdoPTMX5vrwKhg
         z89MjHK5SErPw2M5ibXKeWeEbST6miDcaxr339/pY9NYcCrvfs8hw9cB17PqzJkJz1Dq
         rj155VTqg0xDFQDp+9HfKYtqREG6kbNK2KhkRno/vj0sI+EjmrkYDn23VPv5NAx4G1Eu
         98G3XI+SmPpi6YEypyK8i0sAWMVFVNB9lNwoDA05pW5nx/WPB68E1R6U0/FDWCXVTBd/
         hk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=q38oEdOQixC6SomV8pHildgIaIsnOalYl2ymfk7GiP8=;
        b=DsstFOS/JJkobMB3/ZeLwaBV8PZYGYpwlFZ892f0n6d541J1mGeVZhuU4nHaeesuxc
         62BXzlcWoBOWSm3TKp0pXB817uF31iH+jyh9zSKJ1Bgv6GOgTywtGdAQjl+GV+YSWaNH
         Olug/F2hGt1d/HzqdrksuS/pECHi4ojnNs7/Zt7jFH/nahbydhFjSOwrSZFfqX0KI5qq
         y5VdnyV41FlYQeG2dpGrMZHTdRxbdcwElz8a/tYMB0rzfEncI5zg+uOtfaRQYFKmgOqq
         Dp+ysHy/BYHPioPttF0q9QunDBv2Yci5z/A+XaxiDp4q6plyhxJA9KC1xF9QwyLd7o7L
         f56A==
X-Gm-Message-State: AOAM5336sKle5Ly5eZqAb8oY++M3AKsswA2+eI4+QVsCvtItCsK+2OQI
        vHUsl0Wv1OVe51LqFRRAFrYm2nnQw2iYJXbcnro=
X-Google-Smtp-Source: ABdhPJyScH5+Ihi02hlk6TGYUsjTshtb4MsUlsfXd+bhOSQShm5TMwrTi3WZwUta+8v3KFdTwd7IgrHR7DejqYDBg/E=
X-Received: by 2002:a1c:4b0e:0:b0:389:bf16:d8fb with SMTP id
 y14-20020a1c4b0e000000b00389bf16d8fbmr17272091wma.103.1647042338706; Fri, 11
 Mar 2022 15:45:38 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c3:0:0:0:0 with HTTP; Fri, 11 Mar 2022 15:45:38
 -0800 (PST)
From:   "Capt. Sherri" <agoromariam18@gmail.com>
Date:   Fri, 11 Mar 2022 23:45:38 +0000
Message-ID: <CACNu13PZviefdBob+c1OJ8iqrkLW0OdvC+dZ-v0aKx8v-Ooz2g@mail.gmail.com>
Subject: Re: Hello Dear, How Are You
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0JfQtNGA0LDQstC+LA0KDQrQiNCwINC/0YDQuNC80LjQstGC0LUg0LzQvtGY0LDRgtCwINC/0YDQ
tdGC0YXQvtC00L3QsCDQv9C+0YDQsNC60LA/INCS0LUg0LrQvtC90YLQsNC60YLQuNGA0LDQsiDQ
v9GA0LXRgtGF0L7QtNC90L4sINC90L4NCtC/0L7RgNCw0LrQsNGC0LAg0L3QtSDRg9GB0L/QtdCw
LCDQv9CwINGA0LXRiNC40LIg0L/QvtCy0YLQvtGA0L3QviDQtNCwINC/0LjRiNCw0LwuINCS0LUg
0LzQvtC70LjQvNC1INC/0L7RgtCy0YDQtNC10YLQtQ0K0LTQsNC70Lgg0LPQviDQtNC+0LHQuNCy
0LDRgtC1INC+0LLQsCDQt9CwINC00LAg0LzQvtC20LDQvCDQtNCwINC/0YDQvtC00L7Qu9C20LDQ
vCwNCg0K0YfQtdC60LDRmNGc0Lgg0LPQviDQstCw0YjQuNC+0YIg0L7QtNCz0L7QstC+0YAuDQoN
CtCf0L7Qt9C00YDQsNCyLA0K0JrQsNC/0LXRgtCw0L0g0KjQtdGA0LgNCg==
