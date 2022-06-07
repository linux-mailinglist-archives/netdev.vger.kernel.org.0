Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541A4540033
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 15:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244903AbiFGNgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 09:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244866AbiFGNgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 09:36:48 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF99F45DB;
        Tue,  7 Jun 2022 06:36:41 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id s14so14836330plk.8;
        Tue, 07 Jun 2022 06:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q2p6RtJ3zfFJHYB0dynXXwUzBesfE7braw4qjAb9U4M=;
        b=ncrbT3DW+LxfD6RZeyBb+ZTza4A5BQTcDqx8zRnGwjHHPjn6mOFI3dV5DtAcZp11Bf
         ODpYCXAdDkwK1nj7O8BrLVC+1pgTa3j8XX3URCNiPPIvMHVcDmywOF0K7vjV+OhWuT5z
         KtbKALzfHjcTWNFVtWcqIua3q6yk66MgFTgjZFk80vAez88fmeSt/9SGllMfyTRVcXb4
         80udPsdU/dQGBlXKk4iPbUskKcnTAgQpc9jFrFFGZ8KuQp7Q6O3jqJbsqDqFM2fjD2t3
         8gPWe3CBV1+vmmebKAsOID9fA/KmLjApP+iJ7Cki5rj+6z+sIDp9jj+WrbhMMq85o4h9
         605A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q2p6RtJ3zfFJHYB0dynXXwUzBesfE7braw4qjAb9U4M=;
        b=2QjtyvQhHCkppmFN/LqCCqwyZySozFVIMmThOXsL1442x4RyM1icpHi+jNogzc9HAr
         sxa0OOvFzaPEWuce9nWXnfo/LJU6dRgUUQk+pH4LTP9Y323ftHw59B4+ENhu0xTzbu8a
         Q1WlKDXk1TfJmZY0KKvpkgEmDZejiIVyRYGplB3FXTU4rKVLtFEMV9eccGfVFbWfHQgF
         yOPRF65sBtrsbTlS6BplCqMuOdOWVDQJfG+RnfnhH8YwRBwvZzuC8MR8ZUBxc/OtF5vp
         EnPR2MuyAfoZJkJEjxBlu5SQwDelPhiNGlGr/PR9aez67y12Nor/UqJEAOmdB52QXVzD
         HNbg==
X-Gm-Message-State: AOAM5330fRKV3p+1EYOWjEs0NGu/anyilkD6pu2mp1xflx7TKhj9hywN
        CKk6hzR+5TTgk4tk9n8wBshsYe7+MftEgqBTijA=
X-Google-Smtp-Source: ABdhPJw1NSGI3cPwyvK4jD99d85CXeNvCxeaQXouratPMHSckXM9bOc3gt1SCX9d93d3Pl1YuJbltyObb6CfEkH06x8=
X-Received: by 2002:a17:903:22cb:b0:167:992f:60c3 with SMTP id
 y11-20020a17090322cb00b00167992f60c3mr2182651plg.59.1654609000450; Tue, 07
 Jun 2022 06:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220606134553.2919693-1-alvin@pqrs.dk> <20220606134553.2919693-2-alvin@pqrs.dk>
In-Reply-To: <20220606134553.2919693-2-alvin@pqrs.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 7 Jun 2022 10:36:29 -0300
Message-ID: <CAJq09z4aPE81bwVoDO3TLJDdpjpbB-QxghCXiLD-d_sPYS552A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] net: dsa: realtek: rtl8365mb: rename macro
 RTL8367RB -> RTL8367RB_VB
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
