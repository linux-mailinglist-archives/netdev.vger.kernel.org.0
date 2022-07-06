Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5ED5691FD
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 20:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiGFSiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 14:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGFSiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 14:38:15 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD5B26AEE
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 11:38:14 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id j15so7820500vkp.5
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 11:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=I3IfoJp98FO7XKW3dbZAz1aD9eHoVkYDWadjLLqnOKvq3uOIz91mwwb5gqVgulPTf+
         wxTJATnRt+eq+AwzIDHhrwx/CuU2fPLldnIg0vzThDD9zIlT1PL5sSp9NQ6AxFg2MJzN
         gHl6Hq1IHEQ81vn1z1PMYsKR26q07zcVU8HjxxzfMPO7Ma34MlBmRxjWorx7Cdy4Kx9x
         Iju2cjhzyO/q4IBhuNL2Hho0IuIuQ1ZqVUqOZqb/Mor5YFYj7akZFfvvujLxWSA+CBLh
         7g/yE3DZ/HDG8OZ5E9FZZgEtpIoleKqbBPCT10GPi94OC8kltuURphi0KuddSOAL4yO6
         nsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=nPu8cQJ7eOEJ6gkM44JsorJouV3FWgG6kaoQrJvrq7507p/VfvgtO3MuwIIpPBI+dk
         e+NOQWsOXow2kAOkhBJvyciH8y/2EvlMJGXCZUx8ksdqpgRxWonmT/D8a/pXdxLOWcXf
         Y2hGEwEDaasfqpJzW5SdOb2OV4P9UvZfwQaldsq3yZDEg/oL7DA1LVUIMqOEG0r6ToEb
         4Yj8dAIHn56Bj9KDFC7tBANwSyS3blHWawUotz15DWnmThkvORvtDy0BvIa7x8oAv0Po
         T2fBreBeEAEobmZu45cf0Pi7IIVYTqpRiRpdaiBqA+Z6kj3o3hFTOsr1I7snp4jpTkZn
         tINQ==
X-Gm-Message-State: AJIora/BXNPv/42EeElU75YyPgkXIaSOzBmt9AmkzlmA7pclVUld3RUq
        J0f0FgBihjGaaEKqm2QzkfkpIJwVc9lT3Fnzzt0=
X-Google-Smtp-Source: AGRyM1sZQAe+WuTXMvmwJvPC9fAgmY4ozz/Hwk/J6qkiAimluJSbi6KGL1iBuX+d0ZudtWtfX3dRO6FDSAx/Nh8NzlQ=
X-Received: by 2002:a1f:b254:0:b0:345:87e4:17fb with SMTP id
 b81-20020a1fb254000000b0034587e417fbmr24323914vkf.25.1657132693663; Wed, 06
 Jul 2022 11:38:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:aaec:0:b0:2d1:e31c:b58a with HTTP; Wed, 6 Jul 2022
 11:38:13 -0700 (PDT)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <moussapare92@gmail.com>
Date:   Wed, 6 Jul 2022 10:38:13 -0800
Message-ID: <CAA0Xjhp3gAwZ2pKxDdi8Z=P5zqnGkAr0RnGNPBtUXdF85kXhBQ@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dear,

My name is Dr Lily William from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lily
