Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2136056BA5A
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 15:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbiGHNJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 09:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237978AbiGHNJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 09:09:51 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A73E38
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 06:09:48 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 64so28452947ybt.12
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 06:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3qbbdkbAw1jL4eXJulzz54VRa4gNTCO/akalow9brow=;
        b=awWqeNpz2wlj5CmDNuaDy8X1AXeqTGh1I0pJKCS/alq5q3tUN6R/ZBQwhoDtUUaCVQ
         lgfMlwNpKos6d1MLgrrAe+fXK2hR1Yv1pNG146waYWVKGKuOGIohVriVkX1DxKRCIWgt
         dwmJz0T/KFr9a3ziTeo6kuRDh3K73wNln10d70ukNnFUWFO1UlG7WKehuLUOp9+Uq+fF
         jp7YW6ZE5cfL9rp6Qmoq6OUvbqOmgsqHca5BOzfof9om1XNwnSRUhqrlMn3FIBEf/0Ix
         BtCde///EOcoD1FkMdRTCWZFs0qqtf2g1RX5U4axwFrH18FQj38ggEqizf2nAa1xaI6c
         Rlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=3qbbdkbAw1jL4eXJulzz54VRa4gNTCO/akalow9brow=;
        b=SuEdK9nvyh1cfL9zaT4oOlA7dYJMJAJeZGoocYQmdOSUzsVokVxMR65rvNMsrK/u7f
         TE2UQcbyPTPjt1pkyOmvaT3kSHG7yXTaG7pd8ZHxbXwA2NC06+WrRC9+cD239OiFZC7/
         +k0UMkJFlOxVlsyXGfLykdXCGCNw+sO6dBXMxdhPFygnPG4uuDNuO2yJcPAnB3XgRtPF
         f14RNnTSn4bEm2M/1OdWtmfrz0SpDqCwG1MpyiM/uW5aVNed0QoqLH/mH98LMrBA8FWv
         2qtIO/3AP8NvsbU0DMbOgg6zQNt1G+racjhbEjiJn8oCVxjBr+zDH8q7ULy94e/dbyfl
         jD2w==
X-Gm-Message-State: AJIora/hqL69X97q/xwlfWob5CFx8BaoPby6OAURdWfwl436Lb2Kv/Ct
        uHGbigFeijIeElcE6ai391vqrjZJaIJTBN5MYlo=
X-Google-Smtp-Source: AGRyM1t+mlzpP7gSxpv6gTwm2F6FaP+4Oi0dhby+qEv988qZ/xJq3/ZNXRK9jqU017OLRxdQbsJp5bw86j+mpnMjU74=
X-Received: by 2002:a25:2649:0:b0:66e:448b:5af4 with SMTP id
 m70-20020a252649000000b0066e448b5af4mr3470812ybm.321.1657285788273; Fri, 08
 Jul 2022 06:09:48 -0700 (PDT)
MIME-Version: 1.0
Sender: madjatomwarga@gmail.com
Received: by 2002:a05:7010:6306:b0:2e7:f03b:6bf with HTTP; Fri, 8 Jul 2022
 06:09:48 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Fri, 8 Jul 2022 13:09:48 +0000
X-Google-Sender-Auth: hCrUddpOpdaq4rGpIDRSLII53Ss
Message-ID: <CAJ3F4K-VOGUvWHt2zG5KTuHfJ9GYQwGtEDB1TNZmA5m0r=TKAg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dobr=C3=BD de=C5=88, nedostal som od v=C3=A1s odpove=C4=8F na moje predch=
=C3=A1dzaj=C3=BAce e-maily,
pros=C3=ADm skontrolujte a odpovedzte mi.
