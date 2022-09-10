Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2AE5B4460
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 08:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIJGLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 02:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIJGLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 02:11:51 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3A4B81D3
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 23:11:47 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n12so6528305wru.6
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 23:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=ltnrTHMwin2QwZQ0ir+wXizUWe/YmefeTXqcMvcdKMc=;
        b=TSEbjRewPpk0caRnFfOHAYe3gfePTJoEDAoyufZOIQXjo7XGma3dZWmnaUQBay7gEx
         m5kj5BlEvv4vIVhEynrimmuryL9Etl/m+XAFndRmIoXrKhRwkYfyV8er20TeTpL0u8Hs
         /ymYfdQlDl6WsJbY7AVThGd1CJuEBYkKyg1bISS60mql5xne5frjfRngsjebs8/I29KH
         LTmbs/gaTh1I9U0xnCeX7KCOxLNKUSJOrKML1TEeVpLEiZfdO9YkoRXriMN0r8ANTLKS
         0hiTb7TVMBuqpxBQNdbLd5xHHNpTGBXsCpSuratFD7nyI8HMsRi/RtjKNNwkBp2Cuixg
         rz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ltnrTHMwin2QwZQ0ir+wXizUWe/YmefeTXqcMvcdKMc=;
        b=SYC5I0bUHxRUXRt+Iw5ajeyB6Qvlt3yvb8fnQh3JZr86KHhmNau29ToAYqbt8DXuhq
         sCpB6JroTfy7dRndDMza3TUJ2eXqLxBbm4KNdlibuPN4lZf6CgxphRKiEfa0Lk4OBWBr
         fCshcOqTxjWemCIboQYHw5Xuhmsa0VZGJJ4XEpLe8O2kH1TuxKoqk7Fg2hJ29bL1Emb6
         kI9jhDrtKhCeZiZRMgKmuaFXCLfOu/6/5Nl/qxsfh3FRFZHWyQoAVm/e78BMfK3V1nFz
         gNYbftfzd86QhA1TCdsj6TaAL1y9ZMzuKZx+xgevacHwFDkYuGHPhoC750fBCb3o5dkj
         G0Ow==
X-Gm-Message-State: ACgBeo3MzeLRLyA1i1X+u/aHaTjGB4hgnzi4V/l3ZZSkkKAUubxU/0md
        Djj8PYm/kfr+Bf0irVMz7lNCD0z87B8ZaZFqvp0=
X-Google-Smtp-Source: AA6agR63CcspHYTVd1ACe8j1TmyOMbTBiqKOIG7enqvp9dP1mzliTnWVTJ7VGxx+5QjzJnEL7799BlPZXrw0LdsbmS0=
X-Received: by 2002:a5d:574a:0:b0:228:b90c:e5ee with SMTP id
 q10-20020a5d574a000000b00228b90ce5eemr9630087wrw.328.1662790306281; Fri, 09
 Sep 2022 23:11:46 -0700 (PDT)
MIME-Version: 1.0
Sender: davisbrook764@gmail.com
Received: by 2002:a5d:4883:0:0:0:0:0 with HTTP; Fri, 9 Sep 2022 23:11:45 -0700 (PDT)
From:   Jessica Daniel <jessicadaniel7833@gmail.com>
Date:   Sat, 10 Sep 2022 06:11:45 +0000
X-Google-Sender-Auth: tFDoGerXfSRpW8RiAdTOWINPv_c
Message-ID: <CAE6Ejdjw8JJKb1uf=B8k3mKEKCUzrGt6nOgXWGEbyBjs4D54YA@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Good day??
