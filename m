Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC484DD8C1
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 12:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiCRLLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 07:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiCRLLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 07:11:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3492A129247;
        Fri, 18 Mar 2022 04:10:22 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m12so9808956edc.12;
        Fri, 18 Mar 2022 04:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ef0foZ/Lhp3vdLotjxqBcg5ZuGhPExET5NDJ7Qn2nt4=;
        b=G23J7mlk9uiqUxt8EBwlyGNJVDhN4tnj9q0Mhnpeob3yXoRdeNgoTq5QqJ2gJtF8Ps
         eJPImGRWpGEVAHTv1KGcBqW+IP32reenXjghMRX0qgfMLo1QqTi9n3ST4QKVr34yhNOa
         4rrwshWVYYlleQ7zwHbVQARoZ9XETwh5qekdPstXtYQlMcGS/wBfT3xL/bcUKjiwIcYS
         OnYKNk91X+jvrhy/X5iHpjBDutwnECE4WX653PmgejV1mfQmEvtwCfGJFcEx5Xxp4tDU
         JT2xFgCUxUvF+MHlSrPB+0mLPuK+4v2U7NF2QqL34KAUFWYkM3y/sdCS9DoLsH9SSR66
         eliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ef0foZ/Lhp3vdLotjxqBcg5ZuGhPExET5NDJ7Qn2nt4=;
        b=7JnSQSMsI2/bPXUcDNdiP7OIJPfPt+TBx0Y2Nmk0vqsJVIEAAwTV/exsHNQqpmXAC3
         0JwWoke0diWnEr269JMvBO3Vn2dnGLIPxNPc2PWUonHutE0tnN/NhqXMXr7LIbAXUUnX
         4D5ApZ4Fx2hRkedz8EwH1DD/KK1MxLaeEZdd9/nGKwpeJE3BXWBt/3VxnTreYYPjWmMG
         nZ6sQNkHTehbwE6y+DzBZu36l2r46tiUPZ53V9053JbJl1yBqML82Uf5LyzPCACSB1x+
         O38vrt0Lmna8a0rst9ikYTv7OcnGNNbHn3QWa6tsDKpB4VolCijlmWKzbiDjj+EGsARf
         lIMw==
X-Gm-Message-State: AOAM531LS+BdYFz6DWwArFe6EFMFC5nU1Ul05IcJ8Cl8ngwadjvkCeQP
        IDKjmCl7p9nQ8yBvM0fwBuBtNfisAee4A7nttCKx4S0h9Uo=
X-Google-Smtp-Source: ABdhPJzeCl64vSVre7pbZluHa7ubAPPnEUl1+jgwYGvlFL6lHA5/hqOqrXpt6FaPrG5uTMjcdksY5rrwCBxZ0stSMZw=
X-Received: by 2002:a05:6402:27ce:b0:416:9d78:9f1f with SMTP id
 c14-20020a05640227ce00b004169d789f1fmr8911654ede.356.1647601820316; Fri, 18
 Mar 2022 04:10:20 -0700 (PDT)
MIME-Version: 1.0
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 18 Mar 2022 08:10:09 -0300
Message-ID: <CAOMZO5BqzQ1vMRHHem1pRydjYQiMJOzBzyHtmaPU07jiY_4JTg@mail.gmail.com>
Subject: smsc95xx: Commits for 5.10 stable inclusion
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        netdev <netdev@vger.kernel.org>, m.reichl@fivetechno.de,
        Martyn Welch <martyn.welch@collabora.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jakub Kicinski <kuba@kernel.org>
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

I would like to request the following patches to be included
into the stable 5.10 tree:

a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
0bf3885324a8 ("net: usb: Correct reset handling of smsc95xx")
c70c453abcbf ("smsc95xx: Ignore -ENODEV errors when device is unplugged")

They are already present in 5.15 and 5.16 and they fix real issues
on 5.10 too. I have been running 5.10 with these 3 patches applied locally
and no reboot/disconnect errors are seen anymore. Alexander Stein also
sees an smsc95xx suspend/resume issue fixed in 5.10 with the series applied.

Thanks,

Fabio Estevam
