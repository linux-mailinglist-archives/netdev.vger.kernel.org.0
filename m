Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE685982C8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243857AbiHRL5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244231AbiHRL5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:57:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942BE97529;
        Thu, 18 Aug 2022 04:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 466EEB82046;
        Thu, 18 Aug 2022 11:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA35CC433D7;
        Thu, 18 Aug 2022 11:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660823820;
        bh=bJo0tbnIc+uswTk43OUBgIat/qOTrgP5knO6gmn3Bmc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=go5HpSiEnb9Silfkia44lBj3KV8z3dJE8lEfxSn5sJPOSR0QdUW/En0yF+R+nxfzt
         xmonlgM5DxQO1OFaO2pSFEEZcF6BwxtR9e4jT3Bj+gOltY1fCfU9VuncNOwueGEEzH
         CiO4UKvsFyYAkW+qfr5OijhVOPMTi97BGCJlND2dFJksnmhANyajez99f+yHC20siX
         +auEC7lStZu03a7jy8o6/F2YQe+mBo0mLMBpxKkvvBvq8kym6OHh/4mEUnUX/2Dmw7
         IVcIcJqzujxNq7XdYpHe9QADo880u9JifaKd7+2cGg7Hg+fU+8j54BbAhkGqtBN22N
         UBL0epRdsThXA==
Received: by mail-ed1-f44.google.com with SMTP id o22so1554015edc.10;
        Thu, 18 Aug 2022 04:56:59 -0700 (PDT)
X-Gm-Message-State: ACgBeo1Vs3hbSsiqwjyxg6FO/k9kvO17f7YfDklTgKt3JFFdsqQvq/Jd
        yJFcBokeLck48m1K/gMK8yFdKJ0rrgPB/wMaUEs=
X-Google-Smtp-Source: AA6agR6AO8wc32jrPP5FVrfyEjUtRFP0mRTGqvME4Xvs3TOlgChDy7zm29iMH2ed0Jgru/VFydihw0NQ86oOPPucLE8=
X-Received: by 2002:a05:6402:100c:b0:43d:9009:c705 with SMTP id
 c12-20020a056402100c00b0043d9009c705mr1969311edu.49.1660823818224; Thu, 18
 Aug 2022 04:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <Yv4lFKIoek8Fhv44@debian> <CAK8P3a2_YDCS0Ate7b_nBibsbinjNqvMj9h5foA83NJjq8nE0g@mail.gmail.com>
In-Reply-To: <CAK8P3a2_YDCS0Ate7b_nBibsbinjNqvMj9h5foA83NJjq8nE0g@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 18 Aug 2022 13:56:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2STwH+QZPSB-3aJzap8_bu43EUd9GmeY7pLN8Lfh7b0g@mail.gmail.com>
Message-ID: <CAK8P3a2STwH+QZPSB-3aJzap8_bu43EUd9GmeY7pLN8Lfh7b0g@mail.gmail.com>
Subject: Re: build failure of next-20220818 due to 341dd1f7de4c ("wifi: rtw88:
 add the update channel flow to support setting by parameters")
To:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc:     Chih-Kang Chang <gary.chang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        clang-built-linux <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 1:56 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> Hi Sudeep,
>

Sorry Sudip for misspelling your name...

       Arnd
